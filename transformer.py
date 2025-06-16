import textwrap
from lark import Transformer, v_args, Token
from utils import indent, map_type_ext

@v_args(inline=True)
class ToCSharp(Transformer):
    def __init__(self, manual_translate=None):
        super().__init__()
        self.todo = []   # collect unsupported notices
        self.ns   = "Unnamed"
        self.curr_method = None
        self.curr_params = []
        self.curr_kind = None
        # optional callback invoked when a construct cannot be automatically
        # translated. It should accept (rule_name, children, line) and return a
        # string translation or None.
        self.manual_translate = manual_translate

    # ── root rule -------------------------------------------------
    def start(self, ns, *parts):
        parts = [p for p in parts if p]
        class_section, *impls = parts
        impl_code = "\n".join(impls)
        return f"{class_section}\n{impl_code}" if impl_code else class_section

    def class_impl(self, *parts):
        # method implementations may be preceded by modifiers we ignore
        impl = parts[-1]
        return impl

    def interface_section(self, *args):
        return ""

    def uses(self, *args):
        return ""

    # ── module / class ───────────────────────────────────────
    def namespace(self, name):
        self.ns = str(name)
        return ""

    def dotted(self, *parts):
        return ".".join(parts)

    def array_type(self, *parts):
        base = parts[-1]
        return f"{base}[]"

    def generic_type(self, base, *parts):
        type_nodes = [p for p in parts if not isinstance(p, Token)]
        mapped = [map_type_ext(str(t)) for t in type_nodes]
        ts = ", ".join(mapped)
        return f"{base}<{ts}>"

    def class_def(self, cname, *parts):
        if len(parts) == 2:
            base, sign = parts
        else:
            sign = parts[0]
            base = None
        prev = getattr(self, "curr_class", None)
        self.curr_class = str(cname)
        base_cs = f" : {map_type_ext(str(base))}" if base else ""
        body = f"public static partial class {cname}{base_cs} {{\n{indent(str(sign).rstrip())}\n}}"
        self.curr_class = prev
        return body

    def class_section(self, *classes):
        return "\n\n".join(classes)

    def class_sign(self, *members):
        return "\n".join(members)

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
        return f"public static {ret} {name}({params_cs});"

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
        return f"public static {ret} {name}({params_cs});"

    def dotted_method(self, first, *rest):
        parts = [str(first)]
        for tok in rest:
            if isinstance(tok, Token):
                if tok.value != '.':
                    parts.append(str(tok))
            else:
                parts.append(str(tok))
        cls = ".".join(parts[:-1])
        name = parts[-1]
        return (cls, name)

    def simple_method(self, name):
        return name

    def params(self, items=None):
        return items or []

    def rettype(self, typ):
        return typ

    def names(self, *parts):
        return list(parts)

    def param(self, *parts):
        # allow optional 'var'/'out' modifier and default value
        parts = list(parts)
        if parts and isinstance(parts[0], Token):
            parts.pop(0)
        names, ptype = parts[0], parts[1]
        t = map_type_ext(str(ptype))
        return [f"{t} {n}" for n in names]

    def param_list(self, *ps):
        out = []
        for p in ps:
            out.extend(p)
        return out

    def arg_list(self, *args):
        return list(args)

    def method_decl(self, *parts):
        for p in parts:
            if isinstance(p, str) and p.strip().startswith("public"):
                return p
        return ""

    def member_decl(self, item):
        return item

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

    def var_decl(self, names, typ, expr=None):
        t = map_type_ext(str(typ))
        decl = f"{t} {', '.join(names)}"
        if expr is not None:
            decl += f" = {expr}"
        return decl + ";"

    def field_decl(self, *parts):
        names, typ = parts[-2:]
        t = map_type_ext(str(typ))
        info = f"// TODO: field {', '.join(names)}: {t} -> declare a field"
        impl = f"public {t} {', '.join(names)};"
        self.todo.append(info)
        return info + "\n" + impl

    def property_sig(self, name, *parts):
        parts = list(parts)
        if parts and isinstance(parts[0], list):
            parts.pop(0)
        typ = parts[0]
        return (str(name), map_type_ext(str(typ)))

    def property_index(self, *args):
        return []

    def property_decl(self, *parts):
        sig = parts[-1]
        name, typ = sig
        info = f"// TODO: property {name}: {typ} -> implement as auto-property"
        impl = f"public {typ} {name} {{ get; set; }}"
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
        info = f"// TODO: const {name} -> define a constant"
        impl = f"public const {t} {name} = {expr};"
        self.todo.append(info)
        return info + "\n" + impl

    def const_block(self, *parts):
        decls = parts[1:] if parts and parts[0] == "" else parts
        return "\n".join(decls)

    # ── implementation part ─────────────────────────────────
    def m_impl(self, head, *parts):
        if len(parts) == 1:
            vars_code = ""
            body = parts[0]
        else:
            vars_code, body = parts
        cls, name, params, rettype = head
        params_cs = params or ""
        ret       = map_type_ext(rettype) if rettype else "void"
        if vars_code:
            inner = textwrap.dedent(body[2:-2]).strip()
            body = "{\n" + indent(vars_code + ("\n" + inner if inner else "")) + "\n}"
        method = f"public static {ret} {name}({params_cs}) {body}"
        result = f"public static partial class {cls} {{\n{indent(method)}\n}}"
        # clear method context after generating its body
        self.curr_method = None
        self.curr_params = []
        return result

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
        return (cls, name, ", ".join(param_list), str(rettype or ""))

    # ── statements ──────────────────────────────────────────
    def assign(self, var, expr):
        return f"{var} = {expr};"

    def result_ret(self, _tok, expr):
        return f"return {expr};"

    def exit_ret(self, _tok, expr=None):
        return f"return{(' ' + expr) if expr else ''};"

    def if_stmt(self, cond, then_block, else_block=None):
        else_part = f" else {else_block}" if else_block else ""
        return f"if ({cond}) {then_block}{else_part}"

    def for_stmt(self, var, start, direction, stop, body):
        if isinstance(direction, Token):
            dir_tok = direction.type
        else:
            dir_tok = str(direction)
        if dir_tok == 'DOWNTO':
            cond = f"{var} >= {stop}"
            inc = f"{var}--"
        else:
            cond = f"{var} <= {stop}"
            inc = f"{var}++"
        return f"for (var {var} = {start}; {cond}; {inc}) {body}"

    def while_stmt(self, cond, body):
        return f"while ({cond}) {body}"

    def try_stmt(self, *parts):
        parts = list(parts)
        body = []
        while parts and not isinstance(parts[0], list):
            body.append(parts.pop(0))
        except_body = []
        finally_body = []
        if parts:
            except_body = parts.pop(0)
        if parts:
            finally_body = parts.pop(0)
        body_cs = "\n".join(indent(s, 0) for s in body if s.strip())
        exc_cs = "\n".join(indent(s, 0) for s in except_body if s.strip())
        fin_cs = "\n".join(indent(s, 0) for s in finally_body if s.strip())
        res = f"try {{\n{indent(body_cs)}\n}}"
        if except_body:
            res += f" catch (Exception) {{\n{indent(exc_cs)}\n}}"
        if finally_body:
            res += f" finally {{\n{indent(fin_cs)}\n}}"
        return res

    def case_stmt(self, expr, *branches):
        info = "// TODO: case statement"
        self.todo.append(info)
        return info

    def case_branch(self, *parts):
        return ""

    def case_label(self, tok):
        return str(tok)

    def block(self, *stmts):
        body = "\n".join(indent(s, 0) for s in stmts if s.strip())
        if body:
            return "{\n" + indent(body) + "\n}"
        return "{\n}"

    def empty(self):
        return ""

    # ── expressions ─────────────────────────────────────────
    def binop(self, left, op, right):
        op_map = {"and": "&&", "or": "||", "<>": "!=", "=": "=="}
        return f"{left} {op_map.get(op, op)} {right}"

    def not_expr(self, _tok, expr):
        return f"!{expr}"

    def neg(self, expr):
        return f"-{expr}"

    def pos(self, expr):
        return f"{expr}"

    def number(self, n):
        return n

    def string(self, s):
        return s

    def true(self, _):
        return "true"

    def false(self, _):
        return "false"

    def null(self, _):
        return "null"

    def var(self, base, *parts):
        out = [str(base)]
        for p in parts:
            if isinstance(p, Token):
                out.append(p.value)
            else:
                out.append('.' + str(p))
        return ''.join(out)

    def call(self, fn, *parts):
        parts = list(parts)
        first_args = []
        if parts and isinstance(parts[0], list):
            first_args = parts.pop(0)
        call = str(fn)
        if not parts and len(first_args) == 1 and '.' not in call:
            simple_casts = {'Integer','String','Boolean','Double','DateTime','Object'}
            if call.split('.')[-1] in simple_casts:
                typ = map_type_ext(call)
                call = f"({typ}){first_args[0]}"
            else:
                call += f"({', '.join(first_args)})"
        else:
            call += f"({', '.join(first_args)})"
        i = 0
        while i < len(parts):
            name = parts[i]
            i += 1
            arglist = []
            if i < len(parts) and isinstance(parts[i], list):
                arglist = parts[i]
                i += 1
            call += f".{name}({', '.join(arglist)})"
        return call

    def call_stmt(self, fn, *parts):
        return self.call(fn, *parts) + ";"

    def inherited(self):
        if self.curr_method:
            args = ", ".join(self.curr_params)
            call = f"base.{self.curr_method}({args})" if args else f"base.{self.curr_method}()"
            return f"{call};"
        return "// TODO: inherited call"

    def new_expr(self, name):
        return f"new {name}()"

    def set_lit(self, *elems):
        vals = ", ".join(elems)
        return f"new[]{{{vals}}}"

    def in_expr(self, val, _tok, set_):
        return f"System.Array.Exists({set_}, x => x == {val})"

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
