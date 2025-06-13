#!/usr/bin/env python
# pas2cs.py  –  “v0.3” Oxygene → C# transpiler
# ------------------------------------------------------------
# MIT‑0 licence.  Usage:  python pas2cs.py  InFile.pas  > OutFile.cs
# ------------------------------------------------------------
import sys, textwrap
from pathlib import Path
from lark import Lark, Transformer, v_args, Token

# ────────────────────────── Grammar ──────────────────────────
GRAMMAR = r"""
?start:      namespace interface_section? class_section "implementation" class_impl+ ("end" ".")?

interface_section: "interface" uses_clause?
uses_clause:   "uses" dotted_name ("," dotted_name)* ";"         -> uses

namespace:   "namespace" dotted_name ";"                          -> namespace
dotted_name: CNAME ("." CNAME)*                                    -> dotted
class_section: "type" class_def+                                  -> class_section
class_def:   CNAME "=" "public" "static"? "partial"? "class" ("(" type_name ")")? class_signature "end" ";" -> class_def

class_signature: member_decl*                                     -> class_sign
member_decl: access_modifier                                      -> section
           | access_modifier? "class"? method_kind method_sig ";" "override"? ";"? -> method_decl
           | access_modifier? name_list ":" type_name ";"         -> field_decl
           | access_modifier? "property" property_sig ";"          -> property_decl
           | access_modifier? "const" const_decl+                  -> const_block
method_kind: METHOD | PROCEDURE | FUNCTION | CONSTRUCTOR | DESTRUCTOR
access_modifier: "public" | "protected" | "private"

method_sig:   method_name param_block? return_block?              -> m_sig
             | param_block? return_block?                        -> m_sig_no_name
method_name: CNAME "." CNAME               -> dotted_method
           | CNAME                         -> simple_method
param_block: "(" param_list? ")"           -> params
return_block: ":" type_name                -> rettype
param_list:  param (";" param)*
param:       name_list ":" type_name                              -> param
name_list:   CNAME ("," CNAME)*                                 -> names
?type_name:  array_type | generic_type | dotted_name
ARRAY_RANGE: "[" /[^\]]*/ "]"
array_type:  "array" ARRAY_RANGE? "of" type_name

generic_type: dotted_name LT type_name ("," type_name)* GT

property_sig: CNAME ":" type_name ("read" CNAME)? ("write" CNAME)?
const_decl: CNAME (":" type_name)? OP_REL expr ";"

class_impl:  "class" method_kind method_impl
            | method_kind method_impl
method_impl: impl_head ";" var_section? block                     -> m_impl
impl_head:   method_name param_block? return_block?

block:       "begin" stmt* "end" ";"?

?stmt:       assign_stmt
           | return_stmt
           | if_stmt
           | for_stmt
           | inherited_stmt
           | call_stmt
           | block
           |                         -> empty

assign_stmt: var_ref ":=" expr ";"?                              -> assign
return_stmt: RESULT ":=" expr ";"?                             -> result_ret
            | EXIT expr? ";"?                                  -> exit_ret
if_stmt:     "if" expr "then" stmt ("else" stmt)?                 -> if_stmt
for_stmt:    "for" CNAME ":=" expr "to" expr ("do") stmt          -> for_stmt

call_stmt:   var_ref ("(" arg_list? ")")? ";"?     -> call_stmt

inherited_stmt: "inherited" ";"?                          -> inherited

?expr:       NOT expr                    -> not_expr
           | expr OP_SUM   expr          -> binop
           | expr OP_MUL   expr          -> binop
           | expr (OP_REL|LT|GT) expr    -> binop
           | "(" expr ")"
           | NUMBER                       -> number
           | STRING                       -> string
           | SQ_STRING                    -> string
           | TRUE                         -> true
           | FALSE                        -> false
           | NIL                          -> null
           | var_ref
           | call_expr
           | "new" type_name "(" ")"   -> new_expr
           | "new" type_name             -> new_expr

?name_term:  generic_type | dotted_name

call_expr:   var_ref "(" arg_list? ")"     -> call
arg_list:    expr ("," expr)*

var_ref:     name_term (ARRAY_RANGE | "." name_term)*   -> var

var_section: "var" var_decl+
var_decl:    name_list ":" type_name ";"        -> var_decl

LT:          "<"
GT:          ">"
OP_SUM:      "+" | "-" | "or"
OP_MUL:      "*" | "/" | "and"
OP_REL:      "=" | "<>" | "<=" | ">="

NOT:         "not"i

METHOD:      "method"i
PROCEDURE:   "procedure"i
FUNCTION:    "function"i
CONSTRUCTOR: "constructor"i
DESTRUCTOR:  "destructor"i

TRUE:        "true"i
FALSE:       "false"i
NIL:         "nil"i
SQ_STRING:   /'(?:[^'\n]|'')*'/
RESULT:      "result"i
EXIT:        "exit"i

%import common.CNAME
%import common.NUMBER
%import common.ESCAPED_STRING -> STRING
%import common.WS
COMMENT_BRACE: /\{[^}]*\}/
LINE_COMMENT: /\/\/[^\n]*/
COMMENT_PAREN: /\(\*[^*]*\*\)/
%ignore WS
%ignore COMMENT_BRACE
%ignore LINE_COMMENT
%ignore COMMENT_PAREN
"""

# ─────────────────── Utility helpers ─────────────────────────
def indent(code: str, lvl: int = 1) -> str:
    return textwrap.indent(code, "    " * lvl, lambda _: True)

def map_type(pas_type: str) -> str:
    simple = pas_type.split('.')[-1]
    mapping = {
        "Integer": "int",
        "String": "string",
        "Boolean": "bool",
        "Object": "object",
    }
    return mapping.get(simple, pas_type)

def map_type_ext(typ: str) -> str:
    if typ.endswith('[]'):
        return map_type(typ[:-2]) + '[]'
    return map_type(typ)

def fix_keyword(tok):
    v = tok.value.lower()
    if v == "and":
        tok.type = "OP_MUL"
    elif v == "or":
        tok.type = "OP_SUM"
    elif v == "not":
        tok.type = "NOT"
    return tok

# ─────────────── AST → C# visitor (Lark) ─────────────────────
@v_args(inline=True)
class ToCSharp(Transformer):
    def __init__(self):
        super().__init__()
        self.todo = []   # collect unsupported notices
        self.ns   = "Unnamed"
        self.curr_method = None
        self.curr_params = []
        self.curr_kind = None

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

    def dotted_method(self, cls, name):
        return (cls, name)

    def simple_method(self, name):
        return name

    def params(self, items=None):
        return items or []

    def rettype(self, typ):
        return typ

    def names(self, *parts):
        return list(parts)

    def param(self, names, ptype):
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
        return parts[-1]

    def section(self, token=None):
        return ""

    def method_kind(self, token=None):
        self.curr_kind = str(token) if token else None
        return ""

    def access_modifier(self, token=None):
        return ""

    def var_section(self, *decls):
        return "\n".join(decls)

    def var_decl(self, names, typ):
        t = map_type_ext(str(typ))
        return f"{t} {', '.join(names)};"

    def field_decl(self, *parts):
        names, typ = parts[-2:]
        t = map_type_ext(str(typ))
        info = f"// TODO: field {', '.join(names)}: {t}"
        self.todo.append(info)
        return info

    def property_sig(self, name, typ, *rest):
        return (str(name), map_type_ext(str(typ)))

    def property_decl(self, *parts):
        sig = parts[-1]
        name, typ = sig
        info = f"// TODO: property {name}: {typ}"
        self.todo.append(info)
        return info

    def const_decl(self, name, *parts):
        info = f"// TODO: const {name}"
        self.todo.append(info)
        return info

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
        cls, name = name_parts
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

    def for_stmt(self, var, start, stop, body):
        return f"for (var {var} = {start}; {var} <= {stop}; {var}++) {body}"

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

    def call(self, fn, *args):
        if len(args) == 1 and isinstance(args[0], list):
            arg_list = args[0]
        else:
            arg_list = list(args)
        return f"{fn}({', '.join(arg_list)})"

    def call_stmt(self, fn, args=None):
        call = f"{fn}({', '.join(args)})" if args else f"{fn}()"
        return call + ";"

    def inherited(self):
        if self.curr_method:
            args = ", ".join(self.curr_params)
            call = f"base.{self.curr_method}({args})" if args else f"base.{self.curr_method}()"
            return f"{call};"
        return "// TODO: inherited call"

    def new_expr(self, name):
        return f"new {name}()"

    # ── catch‑all for unimplemented rules ───────────────────
    def __default__(self, data, children, meta):
        line = getattr(meta, "line", "?")
        info = f"// TODO: unsupported construct «{data}» at line {line}"
        self.todo.append(info)
        return info

# ───────────────────────── Main ─────────────────────────────
def transpile(source: str) -> tuple[str, list[str]]:
    source = source.lstrip('\ufeff')  # strip UTF-8 BOM if present
    parser = Lark(
        GRAMMAR,
        parser="lalr",
        maybe_placeholders=True,
        lexer_callbacks={"CNAME": fix_keyword},
    )
    try:
        tree = parser.parse(source)
    except Exception as e:
        from lark import UnexpectedInput
        if isinstance(e, UnexpectedInput):
            ctx = e.get_context(source)
            expected = getattr(e, "expected", None)
            exp = f" Expected: {', '.join(expected)}" if expected else ""
            msg = f"Parse error at line {e.line}, column {e.column}:{exp}\n{ctx}"
            raise SyntaxError(msg) from None
        raise
    gen = ToCSharp()
    body = gen.transform(tree)
    header = f"namespace {gen.ns} {{\n{indent(body.rstrip())}\n}}"
    return header, gen.todo

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: pas2cs.py <input.pas>  (redirect output to .cs)")
    src_txt = Path(sys.argv[1]).read_text(encoding="utf-8")
    cs_out, todos = transpile(src_txt)
    print(cs_out)
    if todos:
        print("\n".join(todos), file=sys.stderr)
