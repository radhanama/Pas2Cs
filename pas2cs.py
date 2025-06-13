#!/usr/bin/env python
# pas2cs.py  –  "v0.3" Oxygene → C# transpiler
# ------------------------------------------------------------
# MIT‑0 licence.  Usage:  python pas2cs.py  InFile.pas  > OutFile.cs
# ------------------------------------------------------------
import sys
from pathlib import Path
from lark import Lark
from grammar import GRAMMAR
from transformer import ToCSharp
from utils import indent, fix_keyword

def transpile(source: str) -> tuple[str, list[str]]:
    source = source.lstrip('\ufeff')
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
