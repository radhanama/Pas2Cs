import textwrap
import json
import ast
import re
from collections import defaultdict, OrderedDict
from lark import Transformer, v_args, Token
from utils import indent, map_type_ext, escape_cs_keyword

@v_args(inline=True)
class ToCSharp(Transformer):
    def __init__(self, manual_translate=None):
        super().__init__()
        self.todo = []   # collect unsupported notices
        self.ns   = "Unnamed"
        self.curr_method = None
        self.curr_params = []
        self.curr_kind = None
        self.curr_static = False
        self.curr_locals = set()
        self.used_result = False
        self.curr_rettype = None
        self.class_defs = OrderedDict()
        self.class_impls = defaultdict(list)
        self.alias_defs = []
        self.class_order = []
        self.impl_methods = defaultdict(set)
        self.class_fields = defaultdict(set)
        self.method_attrs = defaultdict(dict)
        self.curr_impl_class = None
        self.curr_unsafe = False
        self.curr_class = None
        # optional callback invoked when a construct cannot be automatically
        # translated. It should accept (rule_name, children, line) and return a
        # string translation or None.
        self.manual_translate = manual_translate
        self.usings = OrderedDict()
        self.assembly_attrs = []
        self.class_attributes = defaultdict(list)
        self.in_attribute = False

    def _translate_expr_text(self, text: str) -> str:
        """Translate simple Pascal expressions used inside array indexes."""
        text = text.replace("'", '"')
        text = text.replace('<>', '!=')
        # Replace standalone equality
        text = re.sub(r'(?<![<>=:])=(?![=])', '==', text)
        op_map = {
            r'\bdiv\b': '/',
            r'\bmod\b': '%',
            r'\band\b': '&&',
            r'\bor\b': '||',
            r'\bshl\b': '<<',
            r'\bshr\b': '>>',
            r'\bxor\b': '^',
        }
        for pat, repl in op_map.items():
            text = re.sub(pat, repl, text)
        return text

    def _safe_name(self, name):
        text = str(name)
        if text.lower() == 'self':
            return 'this'
        if text.lower().startswith('self.'):
            return 'this.' + '.'.join(escape_cs_keyword(p) for p in text.split('.')[1:])
        if '.' in text:
            parts = text.split('.')
            return '.'.join(escape_cs_keyword(p) for p in parts)
        return escape_cs_keyword(text)

    def attributes(self, *items):
        return list(items)

    def attribute(self, *parts):
        name = str(parts[0])
        args = None
        if len(parts) > 1:
            args = parts[1]
        if args:
            pieces = []
            for a in args:
                if isinstance(a, tuple) and a[0] == 'named':
                    pieces.append(f"{a[1]} = {a[2]}")
                else:
                    pieces.append(str(a))
            arg_text = ", ".join(pieces)
            result = f"[{name}({arg_text})]"
        else:
            result = f"[{name}]"
        return result

    @staticmethod
    def attribute_visit_wrapper(f, data, children, meta):
        self = f.__self__
        prev = self.in_attribute
        self.in_attribute = True
        res = f(*children)
        self.in_attribute = prev
        return res

    attribute.visit_wrapper = attribute_visit_wrapper

    def assembly_attr(self, *parts):
        _assembly = parts[0]
        name = str(parts[1])
        args = parts[2] if len(parts) > 2 else None
        if args:
            arg_text = ", ".join(args)
            attr = f"[assembly: {name}({arg_text})]"
        else:
            attr = f"[assembly: {name}]"
        self.assembly_attrs.append(attr)
        return ""

    # ── root rule -------------------------------------------------
    def start(self, ns, *parts):
        classes = []
        for cname in self.class_order:
            kind, base, sign_list, mods = self.class_defs.get(cname, ("class", "", [], set()))
            body_lines = []
            for line in sign_list:
                info = self._parse_sig(line)
                if info and info in self.impl_methods.get(cname, set()):
                    continue
                if info:
                    stub = line.rstrip().rstrip(';') + ' { /* TODO: implement */ }'
                    body_lines.append(stub)
                else:
                    body_lines.append(line.rstrip())
            body_lines.extend(self.class_impls.get(cname, []))
            body = "\n".join(body_lines).rstrip()
            body = indent(body) if body else ""
            attrs = self.class_attributes.get(cname, [])
            attr_lines = "\n".join(attrs) + "\n" if attrs else ""
            if kind == "enum":
                enum_body = ",\n".join(sign_list)
                classes.append(f"{attr_lines}public enum {cname} {{\n{indent(enum_body)}\n}}")
            else:
                kw = "interface" if kind == "interface" else ("struct" if kind == "record" else "class")
                partial = "partial " if kind in ("class", "record") else ""
                sealed_kw = "sealed " if 'sealed' in mods else ""
                classes.append(f"{attr_lines}public {sealed_kw}{partial}{kw} {cname}{base} {{\n{body}\n}}")
        ns_body = "\n\n".join(classes)
        using_lines = ""
        if self.usings:
            using_lines = "\n".join(f"using {u};" for u in self.usings.keys())
        alias_lines = "\n".join(self.alias_defs)

        header_parts = []
        if self.assembly_attrs:
            header_parts.append("\n".join(self.assembly_attrs))
        if using_lines:
            header_parts.append(using_lines)
        if alias_lines:
            if using_lines:
                header_parts.append("")
            header_parts.append(alias_lines)
        header = "\n".join(header_parts)
        if header:
            header += "\n\n"
        return f"{header}namespace {self.ns} {{\n{indent(ns_body)}\n}}"

    def _parse_sig(self, line):
        line = line.strip()
        if "[" in line:
            parts = line.split("\n")
            line = parts[-1].strip()
            while line.startswith("[") and "]" in line:
                line = line.split("]", 1)[1].strip()
        if not line.startswith("public"):
            return None
        line = line[len("public"):].strip()
        static_flag = False
        if line.startswith("static"):
            static_flag = True
            line = line[len("static"):].strip()
        if not line.endswith(";"):
            return None
        line = line[:-1].strip()
        if "(" not in line:
            return None
        head, params = line.split("(", 1)
        params = params.rstrip(")")
        if " " not in head:
            return None
        ret, name = head.split(None, 1)
        return (name.strip(), params.strip(), ret.strip(), static_flag)

    def class_impl(self, *parts):
        attrs = []
        if parts and isinstance(parts[0], list):
            attrs = parts[0]
            parts = parts[1:]
        # last element is the processed method implementation (ignored)
        if attrs and self.curr_impl_class:
            methods = self.class_impls.get(self.curr_impl_class, [])
            if methods:
                method = methods.pop()
                method = "\n".join(attrs) + "\n" + method
                methods.append(method)
                self.class_impls[self.curr_impl_class] = methods
        self.curr_impl_class = None
        return ""

    def interface_section(self, *args):
        return ""

    def uses(self, *args):
        for item in args:
            name = str(item)
            if name not in self.usings:
                self.usings[name] = None
        return ""

    def class_modifier(self, token=None):
        self.curr_static = True
        return ""

    def CLASSVAR(self, token=None):
        self.curr_static = True
        return "var"

    # ── module / class ───────────────────────────────────────
    def namespace(self, name):
        self.ns = str(name)
        return ""

    def dotted(self, *parts):
        pieces = [p.value if isinstance(p, Token) else str(p) for p in parts]
        return ".".join(pieces)

    def name_part(self, tok):
        return tok.value

    def array_type(self, *parts):
        base = parts[-1]
        return f"{base}[]"

    def generic_type(self, base, args):
        inner = args[1:-1]
        parts = [map_type_ext(p.strip()) for p in inner.split(',')]
        return f"{base}<{', '.join(parts)}>"

    def nullable_type(self, _tok, typ):
        return str(typ) + "?"

    def pointer_type(self, _caret, typ):
        self.curr_unsafe = True
        return map_type_ext(str(typ)) + "*"

    def set_type(self, typ):
        t = map_type_ext(str(typ))
        return f"System.Collections.Generic.HashSet<{t}>"

    def type_spec(self, typ, qmark=None):
        base = str(typ)
        if qmark is not None:
            return base + "?"
        return base

    def range_type(self, start, _dd, end):
        return "int"

    def tuple_type(self, _tok, _of, _lp, first, *rest):
        types = [map_type_ext(str(first))]
        i = 0
        while i < len(rest):
            t = rest[i]
            if isinstance(t, Token) and t.type == ',':
                i += 1
                continue
            types.append(map_type_ext(str(t)))
            i += 1
        inner = ', '.join(types)
        return f"System.ValueTuple<{inner}>"

    def generic_params(self, *names):
        # grammar only yields the parameter identifiers
        cleaned = [str(n) for n in names]
        return '<' + ', '.join(cleaned) + '>'

    def _add_type(self, cname, kind, base, sign_list, mods=None):
        cname_str = str(cname)
        self.class_defs[cname_str] = (kind, base, sign_list, mods or set())
        if cname_str not in self.class_order:
            self.class_order.append(cname_str)
        # capture method attributes from interface declarations
        for line in sign_list:
            if '[' in line:
                parts = line.split('\n')
                attrs = [p.strip() for p in parts[:-1] if p.strip()]
                decl = parts[-1].strip()
                info = self._parse_sig(decl)
                if info:
                    self.method_attrs[cname_str][info] = attrs

    def class_def(self, cname, *parts):
        generics = ''
        if parts and isinstance(parts[0], str) and parts[0].startswith('<'):
            generics = parts[0]
            parts = parts[1:]
        sealed = False
        if parts and isinstance(parts[0], Token) and parts[0].type in {'SEALED','FINAL'}:
            sealed = True
            parts = parts[1:]
        # detect modifiers like "sealed" appearing as identifiers
        while parts and isinstance(parts[0], Token) and parts[0].type == 'CNAME':
            val = str(parts[0]).lower()
            if val in {'sealed', 'final'}:
                sealed = True
            parts = parts[1:]
        sign = parts[-1]
        bases = list(parts[:-1]) if len(parts) > 1 else []
        prev = getattr(self, "curr_class", None)
        self.curr_class = str(cname) + generics
        base_cs = ""
        if bases:
            base_cs = " : " + ", ".join(map_type_ext(str(b)) for b in bases)
        sign_list = sign if isinstance(sign, list) else []
        name_full = str(cname) + generics
        mods = set()
        if sealed:
            mods.add('sealed')
        self._add_type(name_full, "class", base_cs, sign_list, mods)
        self.curr_class = prev
        return ""

    def record_def(self, cname, *parts):
        generics = ''
        if parts and isinstance(parts[0], str) and parts[0].startswith('<'):
            generics = parts[0]
            parts = parts[1:]
        if parts and isinstance(parts[0], Token) and parts[0].type == 'PACKED':
            parts = parts[1:]
        if len(parts) == 2:
            base, sign = parts
        else:
            sign = parts[0]
            base = None
        prev = getattr(self, "curr_class", None)
        self.curr_class = str(cname) + generics
        base_cs = f" : {map_type_ext(str(base))}" if base else ""
        sign_list = sign if isinstance(sign, list) else []
        name_full = str(cname) + generics
        self._add_type(name_full, "record", base_cs, sign_list)
        self.curr_class = prev
        return ""

    def interface_def(self, cname, *parts):
        generics = ''
        if parts and isinstance(parts[0], str) and parts[0].startswith('<'):
            generics = parts[0]
            parts = parts[1:]
        if len(parts) > 1 and isinstance(parts[0], list):
            bases = parts[0]
            sign = parts[1]
        elif len(parts) == 2:
            base = parts[0]
            sign = parts[1]
            bases = [base]
        else:
            sign = parts[0]
            bases = []
        prev = getattr(self, "curr_class", None)
        self.curr_class = str(cname) + generics
        base_cs = ""
        if bases:
            first = map_type_ext(str(bases[0]))
            rest = ", ".join(map_type_ext(str(b)) for b in bases[1:])
            base_cs = " : " + ", ".join([first] + ([rest] if rest else []))
        sign_list = sign if isinstance(sign, list) else []
        name_full = str(cname) + generics
        self._add_type(name_full, "interface", base_cs, sign_list)
        self.curr_class = prev
        return ""

    def enum_def(self, cname, items, *rest):
        enum_items = items if isinstance(items, list) else []
        self._add_type(cname, "enum", "", enum_items)
        return ""

    def alias_def(self, *parts):
        if len(parts) == 4:
            _acc, cname, generics, typ = parts
        elif len(parts) == 3:
            if isinstance(parts[1], str) and parts[1].startswith('<'):
                cname, generics, typ = parts
            else:
                _acc, cname, typ = parts
                generics = ''
        else:
            cname, typ = parts
            generics = ''
        val = typ.value if isinstance(typ, Token) else str(typ)
        t = map_type_ext(val)
        self.alias_defs.append(f"using {cname}{generics} = {t};")
        return ""

    def type_def(self, *parts):
        attrs = []
        if parts and isinstance(parts[0], list):
            attrs = parts[0]
            parts = parts[1:]
        item = parts[-1]
        result = item
        if attrs and self.class_order:
            self.class_attributes[self.class_order[-1]].extend(attrs)
        return result

    def class_section(self, *classes):
        return ""

    def class_sign(self, *members):
        lines = []
        for m in members:
            if m:
                if isinstance(m, list):
                    lines.extend(m)
                else:
                    lines.append(m)
        return lines

    # ── method declarations (interface part) ────────────────
    def m_sig(self, name_parts, *rest):
        if isinstance(name_parts, tuple):
            _, name = name_parts
        else:
            name = name_parts

        params = None
        rettype = None
        for item in rest:
            if isinstance(item, list):
                params = item
            else:
                rettype = item

        params_cs = ", ".join(params or [])
        ret = map_type_ext(str(rettype)) if rettype else "void"
        modifier = "static " if self.curr_static else ""
        sig = f"public {modifier}{ret} {name}({params_cs});"
        return sig

    def m_sig_no_name(self, *rest):
        params = None
        rettype = None
        for item in rest:
            if isinstance(item, list):
                params = item
            else:
                rettype = item
        kind = (self.curr_kind or "").lower()
        if kind == "constructor":
            name = "Create"
        elif kind == "destructor":
            name = "Destroy"
        else:
            name = "Unnamed"
        params_cs = ", ".join(params or [])
        ret = map_type_ext(str(rettype)) if rettype else "void"
        modifier = "static " if self.curr_static else ""
        sig = f"public {modifier}{ret} {name}({params_cs});"
        return sig

    def dotted_method(self, first, *rest):
        parts = [str(first)]
        generics = ""
        for tok in rest:
            if isinstance(tok, Token):
                if tok.type == 'GENERIC_ARGS':
                    generics = tok.value
                elif tok.value != '.':
                    parts.append(str(tok))
            else:
                parts.append(str(tok))
        cls = ".".join(parts[:-1])
        name = parts[-1] + generics
        return (cls, name)

    def simple_method(self, name, *rest):
        generics = rest[0].value if rest else ""
        return str(name) + generics

    def params(self, items=None):
        return items or []

    def rettype(self, typ):
        return typ

    def names(self, *parts):
        return [self._safe_name(p) for p in parts]

    def param(self, *parts):
        # allow optional 'var'/'out' modifier and default value
        parts = list(parts)
        if parts and isinstance(parts[0], Token):
            parts.pop(0)
        names = parts.pop(0)
        ptype = None
        default_val = None
        if parts and not isinstance(parts[0], Token):
            ptype = parts.pop(0)
        if parts:
            # skip '=' or ':=' token if present
            if isinstance(parts[0], Token):
                parts.pop(0)
            if parts:
                default_val = parts.pop(0)
        if ptype is None:
            t = "object"
            info = f"// TODO: parameter {', '.join(names)} missing type"
            self.todo.append(info)
        else:
            t = map_type_ext(str(ptype))
        if default_val is not None:
            return [f"{t} {self._safe_name(n)} = {default_val}" for n in names]
        return [f"{t} {self._safe_name(n)}" for n in names]

    def param_untyped(self, *parts):
        # variant of param rule when no type is declared
        return self.param(*parts)

    def param_list(self, *ps):
        out = []
        for p in ps:
            out.extend(p)
        return out

    def arg_list(self, *args):
        return list(args)

    def arg(self, value):
        return value

    def out_arg(self, _tok, value):
        return f"out {value}"

    def var_arg(self, _tok, value):
        return f"ref {value}"

    def const_arg(self, _tok, value):
        return value

    def named_arg(self, name, expr):
        return ('named', str(name), expr)

    def method_decl(self, *parts):
        for p in parts:
            if isinstance(p, str) and p.strip().startswith("public"):
                sig = p
                break
        else:
            sig = ""
        self.curr_static = False
        return sig

    def member_decl(self, *items):
        attrs = []
        items = list(items)
        if items and isinstance(items[0], list):
            attrs = items.pop(0)
        if not items:
            return ""
        decl = items[-1]
        if attrs:
            return "\n".join(attrs + [decl])
        return decl

    def section(self, token=None):
        return ""

    def method_kind(self, token=None):
        self.curr_kind = str(token) if token else None
        return ""

    def access_modifier(self, token=None):
        return ""

    def method_attr(self, token=None):
        return ""

    def var_section(self, *decls):
        return "\n".join(decls)

    def pre_class_decl(self, item):
        return item

    def main_block(self, *stmts):
        return ""

    def var_stmt(self, *decls):
        return "\n".join(decls)

    def var_decl(self, names, typ, expr=None):
        t = map_type_ext(str(typ))
        safe_names = [self._safe_name(n) for n in names]
        decl = f"{t} {', '.join(safe_names)}"
        if expr is not None:
            decl += f" = {expr}"
        for n in safe_names:
            self.curr_locals.add(str(n))
        return decl + ";"

    def var_decl_infer(self, names, expr):
        safe_names = [self._safe_name(n) for n in names]
        decl = f"var {', '.join(safe_names)} = {expr}"
        for n in safe_names:
            self.curr_locals.add(str(n))
        return decl + ";"

    def field_decl(self, *parts):
        is_static = self.curr_static
        self.curr_static = False
        attrs = []
        items = []
        for p in parts:
            if p in ("", "var"):
                continue
            if isinstance(p, list):
                if p and str(p[0]).startswith('['):
                    attrs.extend(p)
                    continue
                items.append(p)
                continue
            items.append(p)
        if len(items) == 3:
            names, typ, expr = items
        else:
            names, typ = items
            expr = None
        t = map_type_ext(str(typ))
        info = f"// TODO: field {', '.join(names)}: {t} -> declare a field"
        init = f" = {expr}" if expr is not None else ""
        static_kw = "static " if is_static else ""
        impl = f"public {static_kw}{t} {', '.join(names)}{init};"
        self.todo.append(info)
        if self.curr_class:
            self.class_fields[self.curr_class].update(names)
        if attrs:
            return info + "\n" + "\n".join(attrs + [impl])
        return info + "\n" + impl

    def property_sig(self, name, *parts):
        parts = list(parts)
        if parts and isinstance(parts[0], list):
            parts.pop(0)
        typ = parts.pop(0)
        read_val = "get;"
        write_val = "set;"
        has_read = False
        has_write = False
        i = 0
        while i < len(parts):
            token = parts[i]
            tval = str(token).lower()
            if tval == 'read':
                has_read = True
                if i + 1 < len(parts) and isinstance(parts[i+1], Token):
                    field_name = self._safe_name(parts[i+1])
                    if re.match(r'(?i)^(get_|set_)', field_name):
                        read_val = f"get => {field_name}();"
                    else:
                        read_val = f"get => {field_name};"
                    i += 2
                else:
                    read_val = "get;"
                    i += 1
            elif tval == 'write':
                has_write = True
                if i + 1 < len(parts) and isinstance(parts[i+1], Token):
                    field_name = self._safe_name(parts[i+1])
                    if re.match(r'(?i)^(get_|set_)', field_name):
                        write_val = f"set => {field_name}(value);"
                    else:
                        write_val = f"set => {field_name} = value;"
                    i += 2
                else:
                    write_val = "set;"
                    i += 1
            else:
                i += 1
        if not has_read:
            read_val = ""
        if not has_write:
            write_val = ""
        return (self._safe_name(name), map_type_ext(str(typ)), read_val, write_val)

    def property_index(self, *args):
        return []

    # Ignore event option nodes
    def event_raise(self, *args):
        return None

    def event_attr(self, *args):
        return None

    def event_full(self, *args):
        return None

    def event_simple(self, *args):
        return None

    def property_decl(self, *parts):
        sig = parts[-1]
        name, typ, getter, setter = sig
        parts_cs = " ".join(p for p in [getter, setter] if p)
        impl = f"public {typ} {name} {{ {parts_cs} }}"
        return impl

    def event_decl(self, *parts):
        # parts: [attributes?, access_modifier?, name, type_spec, event_end]
        if len(parts) >= 4:
            name = self._safe_name(parts[-3])
            typ = map_type_ext(str(parts[-2]))
        else:
            name = self._safe_name(parts[-2])
            typ = map_type_ext(str(parts[-1]))
        info = f"// TODO: event {name}: {typ} -> implement"
        impl = f"public event {typ} {name};"
        self.todo.append(info)
        return info + "\n" + impl

    def const_decl(self, name, *parts):
        parts = list(parts)
        typ = None
        if parts and isinstance(parts[0], Token) and parts[0].type == 'OP_REL':
            parts.pop(0)
        else:
            if parts:
                typ = parts.pop(0)
            if parts and isinstance(parts[0], Token) and parts[0].type == 'OP_REL':
                parts.pop(0)
        expr = parts[0] if parts else None
        t = map_type_ext(str(typ)) if typ else 'var'
        safe_name = self._safe_name(name)
        if self.curr_method:
            if typ:
                line = f"const {t} {safe_name} = {expr};"
            else:
                line = f"var {safe_name} = {expr};"
            self.curr_locals.add(str(safe_name))
            return line
        info = f"// TODO: const {safe_name} -> define a constant"
        impl = f"public const {t} {safe_name} = {expr};"
        self.todo.append(info)
        return info + "\n" + impl

    def const_block(self, *parts):
        decls = parts[1:] if parts and parts[0] == "" else parts
        return "\n".join(decls)

    def method_decls(self, *sections):
        parts = [s for s in sections if s]
        return "\n".join(parts)

    # ── implementation part ─────────────────────────────────
    def m_impl(self, *parts):
        attrs = []
        if parts and isinstance(parts[0], list):
            attrs = parts[0]
            parts = parts[1:]
        head = parts[0]
        tail = parts[1:]
        if len(tail) == 1:
            vars_code = ""
            body = tail[0]
        else:
            vars_code, body = tail
        cls, name, params, rettype = head
        params_cs = params or ""
        ret       = map_type_ext(rettype) if rettype else "void"
        inner = textwrap.dedent(body[2:-2]).strip()

        if rettype:
            lines = [ln.strip() for ln in inner.split('\n') if ln.strip()]
            has_ret = bool(lines) and lines[-1].startswith("return ")
            if self.used_result:
                result_decl = f"{map_type_ext(rettype)} result;"
                if vars_code:
                    vars_code = result_decl + "\n" + vars_code
                else:
                    vars_code = result_decl
                if not has_ret:
                    if inner:
                        inner += "\n"
                    inner += "return result;"
            else:
                if not has_ret:
                    if inner:
                        inner += "\n"
                    inner += f"return default({map_type_ext(rettype)});"

        if vars_code:
            body = "{\n" + indent(vars_code + ("\n" + inner if inner else "")) + "\n}"
        else:
            if inner:
                body = "{\n" + indent(inner) + "\n}"
            else:
                body = "{\n}"
        modifier = "static " if self.curr_static else ""
        unsafe_kw = "unsafe " if self.curr_unsafe else ""
        method = f"public {modifier}{unsafe_kw}{ret} {name}({params_cs}) {body}"
        key = (name, params_cs, ret, self.curr_static)
        attrs_all = []
        iface_attrs = self.method_attrs.get(cls, {}).get(key)
        if iface_attrs:
            attrs_all.extend(iface_attrs)
        if attrs:
            attrs_all.extend(attrs)
        if attrs_all:
            method = "\n".join(attrs_all) + "\n" + method
        self.class_impls[cls].append(method)
        self.impl_methods[cls].add(key)
        # clear method context after generating its body (except curr_impl_class)
        self.curr_method = None
        self.curr_params = []
        self.curr_static = False
        self.curr_locals = set()
        self.curr_rettype = None
        self.used_result = False
        self.curr_unsafe = False
        # curr_impl_class will be cleared by class_impl
        return ""

    def impl_head(self, name_parts, *rest):
        if isinstance(name_parts, (list, tuple)):
            if len(name_parts) >= 2:
                cls = ".".join(name_parts[:-1])
                name = name_parts[-1]
            else:
                cls = name_parts[0]
                kind = (self.curr_kind or "").lower()
                if kind == "constructor":
                    name = "Create"
                elif kind == "destructor":
                    name = "Destroy"
                else:
                    name = ""
        else:
            kind = (self.curr_kind or "").lower()
            if kind in ("constructor", "destructor"):
                cls = str(name_parts)
                name = "Create" if kind == "constructor" else "Destroy"
            else:
                cls = ""
                name = str(name_parts)
        params = None
        rettype = None
        for item in rest:
            if isinstance(item, list):
                params = item
            else:
                rettype = item
        # store current method context so `inherited` can suggest a base call
        param_list = params or []
        param_names = []
        for p in param_list:
            p = p.strip()
            if not p:
                continue
            param_names.append(p.split()[-1])
        self.curr_method = name
        self.curr_params = param_names
        self.curr_locals = set(param_names)
        self.curr_rettype = str(rettype or "")
        if self.curr_rettype:
            self.curr_locals.add("result")
        self.used_result = False
        self.curr_impl_class = cls
        return (cls, name, ", ".join(param_list), self.curr_rettype)

    # ── statements ──────────────────────────────────────────
    def assign(self, var, expr):
        return f"{var} = {expr};"

    def op_assign(self, var, op, expr):
        return f"{var} {op} {expr};"

    def result_ret(self, _tok, expr):
        self.used_result = True
        return f"result = {expr};"

    def exit_ret(self, _tok, expr=None):
        return f"return{(' ' + expr) if expr else ''};"

    def raise_stmt(self, _tok, expr=None):
        return f"throw{(' ' + expr) if expr else ''};"

    def repeat_stmt(self, *parts):
        cond = parts[-1]
        body = parts[:-1]
        body_cs = "\n".join(indent(s, 0) for s in body if s.strip())
        inner = "{\n" + indent(body_cs) + "\n}"
        return f"do {inner} while (!({cond}));"

    def break_stmt(self, _tok):
        return "break;"

    def continue_stmt(self, _tok):
        return "continue;"

    def using_var(self, _tok, name, *rest):
        if len(rest) == 4:
            typ, expr, _do, body = rest
        else:
            expr, _do, body = rest
            typ = None
        t = "var" if typ is None else map_type_ext(str(typ))
        return f"using ({t} {name} = {expr}) {body}"

    def using_expr(self, _tok, expr, _do, body):
        return f"using ({expr}) {body}"

    def using_pool(self, _tok, _pool, _do, body):
        return f"using (var __pool = new autoreleasepool()) {body}"

    def locking_stmt(self, _tok, expr, _do, body):
        return f"lock ({expr}) {body}"

    def with_stmt(self, _tok, expr, _do, body):
        info = "// TODO: with statement"
        self.todo.append(info)
        return info

    def except_clause(self, *handlers):
        handlers = [h for h in handlers if not isinstance(h, Token)]
        return list(handlers)

    def except_empty(self, *_):
        return []

    def case_else(self, _else_tok, *stmts):
        return list(stmts)

    def case_else_empty(self, _else_tok, _semi=None):
        return [""]

    def finally_clause(self, *stmts):
        return list(stmts)

    def on_handler(self, _on, name, typ, _do, stmt):
        return ('on_handler', str(name), typ, stmt)

    def on_handler_empty(self, _on, name, typ, _do):
        return ('on_handler', str(name), typ, '')

    def yield_stmt(self, _tok, expr, _semi=None):
        return f"yield return {expr};"

    def initialization_section(self, *stmts):
        return ""

    def finalization_section(self, *stmts):
        return ""

    def if_stmt(self, cond, _then=None, then_block=None, _else=None, else_block=None):
        then_part = then_block if then_block is not None else "{}"
        else_part = f" else {else_block}" if else_block else ""
        return f"if ({cond}) {then_part}{else_part}"

    def for_stmt(self, var, *parts):
        parts = list(parts)
        typ = None
        if len(parts) > 3 and isinstance(parts[1], Token) and parts[1].type in {'TO','DOWNTO'}:
            start, direction, stop = parts[0], parts[1], parts[2]
            rest = parts[3:]
        else:
            typ, start, direction, stop = parts[0], parts[1], parts[2], parts[3]
            rest = parts[4:]
        step = None
        if rest and isinstance(rest[0], Token) and rest[0].type == 'STEP':
            step = rest[1]
            body = rest[2]
        else:
            body = rest[0]
        if isinstance(direction, Token):
            dir_tok = direction.type
        else:
            dir_tok = str(direction)
        safe_var = self._safe_name(var)
        if dir_tok == 'DOWNTO':
            cond = f"{safe_var} >= {stop}"
            step_code = step or "1"
            inc = f"{safe_var} -= {step_code}" if step else f"{safe_var}--"
        else:
            cond = f"{safe_var} <= {stop}"
            step_code = step or "1"
            inc = f"{safe_var} += {step_code}" if step else f"{safe_var}++"
        if safe_var in self.curr_locals:
            prefix = ""
        else:
            prefix = map_type_ext(str(typ)) + " " if typ else "var "
            self.curr_locals.add(safe_var)
        return f"for ({prefix}{safe_var} = {start}; {cond}; {inc}) {body}"

    def for_each_stmt(self, var, *parts):
        parts = list(parts)
        typ = None
        if parts and getattr(parts[0], 'type', None) != 'IN' and str(parts[0]) != 'in':
            typ = parts.pop(0)
        if parts and isinstance(parts[0], Token) and parts[0].type == 'IN':
            parts.pop(0)
        seq = parts.pop(0)
        idx_var = None
        if parts and isinstance(parts[0], Token) and parts[0].type == 'INDEX':
            parts.pop(0)
            idx_var = parts.pop(0)
        if parts and isinstance(parts[0], Token) and parts[0].type == 'DO':
            parts.pop(0)
        body = parts[0]

        t = "var" if typ is None else map_type_ext(str(typ))
        safe_var = self._safe_name(var)

        if idx_var is None:
            return f"foreach ({t} {safe_var} in {seq}) {body}"

        safe_idx = self._safe_name(idx_var)
        body_cs = str(body)
        if body_cs.strip().startswith('{'):
            inner = body_cs.strip()[1:-1].strip()
        else:
            inner = body_cs.strip()
        inner = f"{t} {safe_var} = {seq}[{safe_idx}];\n{inner}"
        new_body = "{\n" + indent(inner) + "\n}"
        return f"for (var {safe_idx} = 0; {safe_idx} < {seq}.Length; {safe_idx}++) {new_body}"

    def loop_stmt(self, _tok, body):
        return f"while (true) {body}"

    def while_stmt(self, cond, body):
        return f"while ({cond}) {body}"

    def try_stmt(self, *parts):
        body_stmts = []
        except_clause = None
        finally_clause = None

        for part in parts:
            if isinstance(part, list):
                if except_clause is None:
                    except_clause = part
                else:
                    finally_clause = part
            elif not isinstance(part, Token):
                body_stmts.append(part)

        body_cs = "\n".join(indent(s,0) for s in body_stmts if isinstance(s,str) and s.strip())
        res = f"try\n{{\n{indent(body_cs)}\n}}"

        if except_clause is not None:
            generic_body = []
            for handler in except_clause:
                if isinstance(handler, tuple) and handler[0] == 'on_handler':
                    _tag, name, typ, stmt = handler
                    if stmt.strip():
                        catch_body = stmt if stmt.strip().startswith('{') else f"{{\n{indent(stmt)}\n}}"
                    else:
                        catch_body = "{}"
                    res += f"\ncatch ({map_type_ext(str(typ))} {name})\n{catch_body}"
                else:
                    generic_body.append(handler)
            if generic_body or not except_clause:
                exc_cs = "\n".join(indent(s,0) for s in generic_body if isinstance(s,str) and s.strip())
                if exc_cs:
                    res += f"\ncatch (Exception)\n{{\n{indent(exc_cs)}\n}}"
                else:
                    res += "\ncatch (Exception)\n{}"

        if finally_clause:
            fin_cs = "\n".join(indent(s,0) for s in finally_clause if isinstance(s,str) and s.strip())
            res += f"\nfinally\n{{\n{indent(fin_cs)}\n}}"

        return res

    def case_stmt(self, expr, *parts):
        branches = [p for p in parts if isinstance(p, tuple) and p[0] == 'branch']
        else_branch = [p for p in parts if not (isinstance(p, tuple) and p[0] == 'branch')]
        else_branch = [p for p in else_branch if not (isinstance(p, Token) and p.type == 'ELSE')]
        flat_else = []
        for eb in else_branch:
            if isinstance(eb, list):
                flat_else.extend(eb)
            else:
                flat_else.append(eb)
        else_branch = flat_else

        switch_body = []
        for _tag, labels, stmt in branches:
            patterns = []
            for label in labels:
                if isinstance(label, tuple) and label[0] == 'range':
                    start, end = label[1], label[2]
                    patterns.append(f">= {start} and <= {end}")
                else:
                    patterns.append(str(label))
            case_line = "case " + " or ".join(patterns) + ":"
            if '\n' in stmt or not stmt.strip().endswith(';'):
                body = f"{{\n{indent(stmt)}\nbreak;\n}}"
            else:
                body = f" {stmt} break;"
            switch_body.append(f"{case_line}{body}")

        if else_branch:
            else_stmts = "\n".join(s for s in else_branch if s.strip())
            if else_stmts:
                switch_body.append(f"default:\n{{\n{indent(else_stmts)}\nbreak;\n}}")
            else:
                switch_body.append("default:\n{\nbreak;\n}")

        body_cs = indent("\n".join(switch_body))
        return f"switch ({expr})\n{{\n{body_cs}\n}}"

    def case_branch(self, *parts):
        stmt = parts[-1]
        labels = parts[:-1]
        return ('branch', labels, stmt)

    def case_label(self, tok):
        if isinstance(tok, Token):
            return "null" if tok.type == "NIL" else tok.value
        return str(tok)

    def label_range(self, start, _dd, end):
        return ('range', int(str(start)), int(str(end)))

    def block(self, *stmts):
        body = "\n".join(indent(s, 0) for s in stmts if s.strip())
        if body:
            return "{\n" + indent(body) + "\n}"
        return "{\n}"

    def empty(self):
        return ""

    # ── expressions ─────────────────────────────────────────
    def binop(self, left, op, right):
        op_map = {
            "and": "&&",
            "or": "||",
            "and then": "&&",
            "or else": "||",
            "<>": "!=",
            "=": "==",
            "mod": "%",
            "div": "/",
            "shl": "<<",
            "shr": ">>",
            "xor": "^",
        }
        return f"{left} {op_map.get(op, op)} {right}"

    def short_or(self, left, _or, _else, right):
        return self.binop(left, "or else", right)

    def short_and(self, left, _and, _then, right):
        return self.binop(left, "and then", right)

    def not_expr(self, _tok, expr):
        return f"!{expr}"

    def neg(self, expr):
        return f"-{expr}"

    def pos(self, expr):
        return f"{expr}"

    def number(self, n):
        return str(n).replace('_', '').replace(',', '')

    def signed_number(self, *parts):
        if len(parts) == 2:
            sign, num = parts
            sign = str(sign)
        else:
            sign, num = '', parts[0]
        val = int(str(num).replace('_', '').replace(',', ''))
        if sign == '-':
            val = -val
        return val

    def hex_number(self, tok):
        return '0x' + tok.value[1:]

    def binary_number(self, tok):
        return '0b' + tok.value[1:]

    def string(self, s):
        s = str(s)
        if s.startswith("'"):
            inner = s[1:-1].replace("''", "'")
            inner = inner.replace('\\', '\\\\')
            inner = inner.replace('"', '\\"')
            return f'"{inner}"'
        else:
            inner = s[1:-1]
            inner = inner.replace('\\', '\\\\').replace('"', '\\"')
            return f'"{inner}"'

    def true(self, _):
        return "true"

    def false(self, _):
        return "false"

    def null(self, _):
        return "null"

    def var(self, base, *parts):
        out = [self._safe_name(base)]
        for p in parts:
            if isinstance(p, Token):
                text = p.value
                if p.type == 'ARRAY_RANGE':
                    inner = text[1:-1]
                    inner = self._translate_expr_text(inner)
                    text = f"[{inner}]"
                elif p.type == 'CNAME':
                    text = self._safe_name(text)
                out.append(text)
            else:
                out.append('.' + self._safe_name(p))
        return ''.join(out)

    def prop_call(self, name, generics=None, args=None):
        nm = str(name)
        if isinstance(generics, list) and args is None:
            args = generics
            generics = None
        if generics is not None:
            nm += generics.value
        if args is None:
            return ('prop', nm, None)
        else:
            return ('prop', nm, list(args))

    def index_postfix(self, tok):
        inner = tok.value[1:-1]
        inner = self._translate_expr_text(inner)
        return ('index', f"[{inner}]")

    def call_args(self, args=None):
        return [] if args is None else list(args)

    def call(self, fn, *parts):
        parts = list(parts)
        first_args = []
        if parts and isinstance(parts[0], list):
            first_args = parts.pop(0)
        first_args = [a[2] if isinstance(a, tuple) and a[0]=='named' else a for a in first_args]
        call = str(fn)
        if ' as ' in call and (first_args or parts):
            call = f"({call})"
        if len(first_args) == 1 and '.' not in call:
            name = call.split('.')[-1]
            clean = name[1:] if name.startswith('@') else name
            simple_casts = {'integer', 'string', 'boolean', 'double', 'datetime', 'object'}
            lower = clean.lower()
            if lower in simple_casts:
                typ = map_type_ext(clean)
                expr = first_args[0]
                need_paren = any(ch in expr for ch in ' +-*/%<>=')
                if need_paren:
                    expr = f"({expr})"
                cast_expr = f"({typ}){expr}"
                call = f"({cast_expr})" if parts else cast_expr

            elif lower == 'round':
                inner = first_args[0]
                round_expr = f"Math.Round({inner})"
                call = f"({round_expr})" if parts else round_expr
            else:
                call += f"({', '.join(first_args)})"
        else:
            if not first_args:
                is_literal = call.startswith('"') or call[0].isdigit() or call.startswith('0x') or call.startswith('0b') or call.lower() in {'true','false','null'}
                if not parts:
                    if call.startswith('typeof(') or call.startswith('new '):
                        pass
                    elif ' as ' in call:
                        pass
                    elif not is_literal:
                        call += "()"
                elif '.' not in call and ' as ' not in call and not call.startswith('typeof(') and not call.startswith('new ') and not is_literal:
                    call += "()"
            else:
                call += f"({', '.join(first_args)})"
        i = 0
        while i < len(parts):
            part = parts[i]
            i += 1
            if isinstance(part, tuple):
                kind = part[0]
                if kind == 'prop':
                    name, args = part[1], part[2]
                    if args is None:
                        call += f".{name}"
                    else:
                        args = [a[2] if isinstance(a, tuple) and a[0]=='named' else a for a in args]
                        call += f".{name}({', '.join(args)})"
                elif kind == 'index':
                    call += part[1]
            elif isinstance(part, Token) and part.type == 'GENERIC_ARGS':
                if call.endswith("()"):
                    call = call[:-2] + part.value + "()"
                    if i < len(parts) and isinstance(parts[i], list):
                        i += 1
                else:
                    call += part.value
                    if i < len(parts) and isinstance(parts[i], list):
                        extra = [a[2] if isinstance(a, tuple) and a[0]=='named' else a for a in parts[i]]
                        call += f"({', '.join(extra)})"
                        i += 1
            else:
                name = part
                arglist = []
                if i < len(parts) and isinstance(parts[i], list):
                    arglist = [a[2] if isinstance(a, tuple) and a[0]=='named' else a for a in parts[i]]
                    i += 1
                call += f".{name}({', '.join(arglist)})"
        return call

    def call_stmt(self, fn, *parts):
        return self.call(fn, *parts) + ";"

    def new_stmt(self, expr):
        return expr + ";"

    def inherited(self, name=None, args=None):
        if name is None:
            if self.curr_method:
                base = self.class_defs.get(self.curr_impl_class, ("", "", [], set()))[1]
                if base.strip():
                    call_args = ", ".join(self.curr_params)
                    call = f"base.{self.curr_method}({call_args})" if call_args else f"base.{self.curr_method}()"
                    return call + ";"
                return ""
            return "// TODO: inherited call"
        if str(name).lower() == "constructor":
            base_name = self.curr_method or "constructor"
            arglist = ", ".join(args or [])
            base = self.class_defs.get(self.curr_impl_class, ("", "", [], set()))[1]
            if base.strip():
                return f"base.{base_name}({arglist});"
            return ""
        arglist = ", ".join(args or [])
        base = self.class_defs.get(self.curr_impl_class, ("", "", [], set()))[1]
        if base.strip():
            return f"base.{name}({arglist});"
        return ""

    def inherited_call_expr(self, name, args=None):
        arglist = "" if args is None else ", ".join(args)
        if str(name).lower() == "constructor":
            base_name = self.curr_method or "constructor"
            base = self.class_defs.get(self.curr_impl_class, ("", "", [], set()))[1]
            if base.strip():
                return f"base.{base_name}({arglist})"
            return ""
        base = self.class_defs.get(self.curr_impl_class, ("", "", [], set()))[1]
        if base.strip():
            return f"base.{name}({arglist})"
        return ""

    def new_obj(self, name, args=None):
        arglist = "" if args is None else ", ".join(args)
        return f"new {name}({arglist})"

    def new_obj_noargs(self, name):
        return f"new {name}()"

    def new_array(self, name, range_tok):
        inner = range_tok.value[1:-1]
        return f"new {map_type_ext(str(name))}[{inner}]"

    def addr_of(self, _at, var):
        self.curr_unsafe = True
        return f"&{var}"

    def deref(self, expr, _caret):
        self.curr_unsafe = True
        return f"*{expr}"

    def paren_index(self, expr, range_tok):
        inner = range_tok.value[1:-1]
        inner = self._translate_expr_text(inner)
        return f"({expr})[{inner}]"

    def typeof_expr(self, _tok, expr, _rp=None):
        s = str(expr)
        if re.fullmatch(r"-?\d+", s):
            return "typeof(int)"
        if re.fullmatch(r"-?\d+\.\d+", s):
            return "typeof(double)"
        low = s.lower()
        if low in {"true", "false"}:
            return "typeof(bool)"
        if s.startswith('"') and s.endswith('"'):
            return "typeof(string)"
        if re.fullmatch(r"@?[A-Za-z_][A-Za-z_0-9]*\??", s):
            return f"typeof({map_type_ext(s)})"
        return f"({s}).GetType()"

    def is_not_inst(self, expr, _is_tok, _not_tok, typ):
        return f"{expr} is not {map_type_ext(str(typ))}"

    def is_inst(self, expr, _tok, typ):
        return f"{expr} is {map_type_ext(str(typ))}"

    def as_cast(self, expr, _tok, typ):
        return f"{expr} as {map_type_ext(str(typ))}"

    def lambda_sig(self, params=None):
        if params is None:
            return "()"
        param_names = []
        for p in params:
            name = str(p).split()[-1]
            param_names.append(self._safe_name(name))
        if len(param_names) == 1:
            return param_names[0]
        return f"({', '.join(param_names)})"

    def lambda_expr(self, sig, body):
        return f"{sig} => {body}"

    def anon_proc(self, _kind, params=None, block=None):
        # Anonymous procedure or function converted to a lambda
        sig = self.lambda_sig(params)
        return f"{sig} => {block}"

    def if_expr(self, *parts):
        """Handle inline conditional expressions."""
        if len(parts) == 3:
            cond, true_val, false_val = parts
        elif len(parts) == 5:
            cond, true_val, false_val = parts[0], parts[2], parts[4]
        else:
            cond, true_val, false_val = parts[1], parts[3], parts[5]
        return f"{cond} ? {true_val} : {false_val}"

    def char_code(self, tok):
        nums = [int(n) for n in tok.value[1:].split('#') if n]
        chars = []
        for val in nums:
            if val == 10:
                chars.append('\\n')
            elif val == 13:
                chars.append('\\r')
            else:
                chars.append(f"\\x{val:02X}")
        inner = ''.join(chars)
        return f'"{inner}"'

    def generic_call_base(self, base, args):
        from utils import map_type
        inner = args[1:-1]
        types = [map_type(t.strip()) for t in inner.split(',')]
        return f"{base}<{', '.join(types)}>"

    def set_lit(self, *elems):
        vals = ", ".join(elems)
        return f"new[]{{{vals}}}"

    def array_of_expr(self, typ, args=None):
        from utils import map_type_ext
        if args is None:
            arglist = ""
        else:
            parts = list(args)
            if len(parts) == 1 and parts[0].startswith("new[]"):
                inner = parts[0][6:-1]
                arglist = inner
            else:
                arglist = ", ".join(parts)
        return f"new {map_type_ext(str(typ))}[]{{{arglist}}}"

    def enum_item(self, name, *rest):
        if rest:
            return f"{name} = {rest[-1]}"
        return str(name)

    def enum_items(self, first, *rest):
        items = [first]
        for itm in rest:
            if isinstance(itm, str):
                items.append(itm)
        return items

    def in_expr(self, val, _tok, set_):
        return f"System.Array.Exists({set_}, x => x == {val})"

    def not_in_expr(self, val, _not, _in_tok, set_):
        return f"!System.Array.Exists({set_}, x => x == {val})"

    # ── catch‑all for unimplemented rules ───────────────────
    def __default__(self, data, children, meta):
        line = getattr(meta, "line", "?")
        info = f"// TODO: unsupported construct «{data}» at line {line}"
        self.todo.append(info)
        if self.manual_translate:
            translation = self.manual_translate(data, children, line)
            if translation is not None:
                return translation
        return info
