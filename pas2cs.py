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


def interactive_translate(rule: str, children, line: int) -> str | None:
    """Prompt the user for a manual translation of an unsupported construct."""
    snippet = " ".join(str(c) for c in children)
    print(f"Cannot translate '{rule}' at line {line}: {snippet}")
    try:
        inp = input("Provide translation (leave blank to keep TODO): ")
    except EOFError:
        inp = ""
    return inp.strip() or None

def transpile(source: str, manual_translate=None, manual_parse_error=None) -> tuple[str, list[str]]:
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
            if manual_parse_error:
                translation = manual_parse_error(e, source)
                if translation is not None:
                    return translation, []
            ctx = e.get_context(source)
            expected = getattr(e, "expected", None)
            exp = f" Expected: {', '.join(expected)}" if expected else ""
            msg = f"Parse error at line {e.line}, column {e.column}:{exp}\n{ctx}"
            raise SyntaxError(msg) from None
        raise
    gen = ToCSharp(manual_translate=manual_translate)
    body = gen.transform(tree)
    header = f"namespace {gen.ns} {{\n{indent(body.rstrip())}\n}}"
    return header, gen.todo

def interactive_parse_error(err, source: str) -> str | None:
    """Prompt the user when parsing fails and optionally return a manual translation."""
    from lark import UnexpectedInput
    if isinstance(err, UnexpectedInput):
        ctx = err.get_context(source)
        expected = getattr(err, "expected", None)
        exp = f" Expected: {', '.join(expected)}" if expected else ""
        print(f"Parse error at line {err.line}, column {err.column}:{exp}\n{ctx}")
    try:
        inp = input("Provide translation for this section (leave blank to abort): ")
    except EOFError:
        inp = ""
    return inp.strip() or None

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: pas2cs.py [--interactive] <input.pas>  (redirect output to .cs)")

    interactive = False
    if "--interactive" in sys.argv:
        interactive = True
        sys.argv.remove("--interactive")

    src_file = sys.argv[1]
    src_txt = Path(src_file).read_text(encoding="utf-8")
    # try:
    manual = interactive_translate if interactive else None
    parse_manual = interactive_parse_error if interactive else None
    cs_out, todos = transpile(
        src_txt,
        manual_translate=manual,
        manual_parse_error=parse_manual,
    )
    # except SyntaxError as e:
    #     print(str(e), file=sys.stderr)
    #     print(
    #         f"Manual intervention required near the location above in {src_file}."
    #         " Please edit the source to resolve the issue and rerun.",
    #         file=sys.stderr,
    #     )
    #     sys.exit(1)
    print(cs_out)
    # if todos:
    #     print("\n".join(todos), file=sys.stderr)
