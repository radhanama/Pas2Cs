#!/usr/bin/env python
# pas2cs.py  –  “v0.3” Oxygene → C# transpiler
# ------------------------------------------------------------
# MIT‑0 licence.  Usage:  python pas2cs.py  InFile.pas  > OutFile.cs
# ------------------------------------------------------------
import sys, textwrap
from pathlib import Path
from lark import Lark, Transformer, v_args

# ────────────────────────── Grammar ──────────────────────────
GRAMMAR = r"""
?start:      namespace class_section "implementation" class_impl+

namespace:   "namespace" CNAME ";"                               -> namespace
class_section: "type" class_def+                                 -> class_section
class_def:   CNAME "=" "public" "class" class_signature "end" ";"-> class_def

class_signature: ("public" "class" "method" method_sig ";")*     -> class_sign

method_sig:  CNAME "." CNAME "(" param_list? ")" (":" type_name)?-> m_sig
param_list:  param (";" param)*
param:       CNAME ":" type_name                                 -> param
?type_name:  SIMPLETYPE

class_impl:  "class" "method" method_impl
method_impl: m_head ";" block                                    -> m_impl
m_head:      CNAME "." CNAME "(" param_list? ")" (":" type_name)?

block:       "begin" stmt* "end" ";"

?stmt:       assign_stmt
           | return_stmt
           | if_stmt
           | for_stmt
           |                         -> empty

assign_stmt: var_ref ":=" expr ";"                               -> assign
return_stmt: ("result" ":=" expr ";"                             -> result_ret
            | "exit" expr? ";")                                  -> exit_ret
if_stmt:     "if" expr "then" block ("else" block)?              -> if_stmt
for_stmt:    "for" CNAME ":=" expr "to" expr ("do") block        -> for_stmt

?expr:       expr OP_SUM   expr          -> binop
           | expr OP_MUL   expr          -> binop
           | expr OP_REL   expr          -> binop
           | "(" expr ")"
           | NUMBER                       -> number
           | STRING                       -> string
           | var_ref
           | call_expr
call_expr:   CNAME "(" arg_list? ")"     -> call
arg_list:    expr ("," expr)*

var_ref:     CNAME                       -> var

SIMPLETYPE:  "Integer" | "String" | "Boolean"

OP_SUM:      "+" | "-" | "or"
OP_MUL:      "*" | "/" | "and"
OP_REL:      "=" | "<>" | "<=" | ">=" | "<" | ">"

%import common.CNAME
%import common.NUMBER
%import common.ESCAPED_STRING -> STRING
%import common.WS
%ignore WS
"""

# ─────────────────── Utility helpers ─────────────────────────
def indent(code: str, lvl: int = 1) -> str:
    return textwrap.indent(code, "    " * lvl, lambda _: True)

def map_type(pas_type: str) -> str:
    return {"Integer": "int", "String": "string", "Boolean": "bool"}.get(pas_type, "object")

# ─────────────── AST → C# visitor (Lark) ─────────────────────
@v_args(inline=True)
class ToCSharp(Transformer):
    def __init__(self):
        super().__init__()
        self.todo = []   # collect unsupported notices
        self.ns   = "Unnamed"

    # ── module / class ───────────────────────────────────────
    def namespace(self, name):
        self.ns = str(name)
        return ""

    def class_def(self, cname, sign):
        return f"public static class {cname} {{\n{indent(sign.rstrip())}\n}}"

    def class_section(self, *classes):
        return "\n\n".join(classes)

    def class_sign(self, *members):
        return "\n".join(members)

    # ── method declarations (interface part) ────────────────
    def m_sig(self, cls, name, params=None, rettype=None):
        params_cs = params or ""
        ret       = map_type(str(rettype)) if rettype else "void"
        return f"public static {ret} {name}({params_cs});"

    def param(self, pname, ptype):
        return f"{map_type(str(ptype))} {pname}"

    def param_list(self, *ps):
        return ", ".join(ps)

    # ── implementation part ─────────────────────────────────
    def m_impl(self, head, body):
        cls, name, params, rettype = head
        params_cs = params or ""
        ret       = map_type(rettype) if rettype else "void"
        return f"public static {ret} {name}({params_cs}) {body}"

    def m_head(self, cls, name, params=None, rettype=None):
        return (cls, name, params or "", str(rettype or ""))

    # ── statements ──────────────────────────────────────────
    def assign(self, var, expr):
        return f"{var} = {expr};"

    def result_ret(self, expr):
        return f"return {expr};"

    def exit_ret(self, expr=None):
        return f"return{(' ' + expr) if expr else ''};"

    def if_stmt(self, cond, then_block, else_block=None):
        else_part = f" else {else_block}" if else_block else ""
        return f"if ({cond}) {then_block}{else_part}"

    def for_stmt(self, var, start, stop, body):
        return f"for (var {var} = {start}; {var} <= {stop}; {var}++) {body}"

    def block(self, *stmts):
        body = "\n".join(indent(s, 0) for s in stmts if s.strip())
        return "{\n" + indent(body) + "\n}"

    def empty(self):
        return ""

    # ── expressions ─────────────────────────────────────────
    def binop(self, left, op, right):
        op_map = {"and": "&&", "or": "||", "<>": "!=", "=": "=="}
        return f"{left} {op_map.get(op, op)} {right}"

    def number(self, n):
        return n

    def string(self, s):
        return s

    def var(self, n):
        return n

    def call(self, fn, *args):
        return f"{fn}({', '.join(args)})"

    # ── catch‑all for unimplemented rules ───────────────────
    def __default__(self, data, children, meta):
        info = f"// TODO: unsupported construct «{data}» at line {meta.line}"
        self.todo.append(info)
        return info

# ───────────────────────── Main ─────────────────────────────
def transpile(source: str) -> tuple[str, list[str]]:
    parser = Lark(GRAMMAR, parser="lalr", maybe_placeholders=True)
    tree   = parser.parse(source)
    gen    = ToCSharp()
    body   = gen.transform(tree)
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
