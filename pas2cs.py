#!/usr/bin/env python
# pas2cs.py  –  "v0.3" Oxygene → C# transpiler
# ------------------------------------------------------------
# MIT‑0 licence.  Usage:  python pas2cs.py  InFile.pas  > OutFile.cs
# ------------------------------------------------------------
import sys
import re
from pathlib import Path
from lark import Lark
from grammar import GRAMMAR
from transformer import ToCSharp
from utils import (
    fix_keyword,
    set_source,
    safe_print,
    remove_accents_code,
    pascal_comments_to_csharp,
)


def interactive_translate(rule: str, children, line: int) -> str | None:
    """Prompt the user for a manual translation of an unsupported construct."""
    snippet = " ".join(str(c) for c in children)
    print(f"Cannot translate '{rule}' at line {line}: {snippet}")
    try:
        inp = input("Provide translation (leave blank to keep note): ")
    except EOFError:
        inp = ""
    return inp.strip() or None

_PARSER: Lark | None = None


def _get_parser() -> Lark:
    global _PARSER
    if _PARSER is None:
        _PARSER = Lark(
            GRAMMAR,
            parser="lalr",
            maybe_placeholders=True,
            lexer_callbacks={"CNAME": fix_keyword},
            cache=True,
        )
    return _PARSER


def transpile(source: str, manual_translate=None, manual_parse_error=None) -> tuple[str, list[str]]:
    source = source.lstrip('\ufeff')
    # Collapse accidental double semicolons. For lines that consist solely of a
    # semicolon we strip the semicolon but keep the line break so error
    # positions still match the original source.
    # Move semicolons on their own line up to the previous line.
    # When the preceding line ends with a comment, place the semicolon before
    # the comment so it's not swallowed by the lexer.
    source = re.sub(r'(?<!\})\n\s*;\s*(?=\n)', ';\n', source)
    source = re.sub(r'\}\s*;', '}', source)
    source = re.sub(r';[ \t;]*(?=\n|$)', ';', source)
    source = remove_accents_code(source)

    # Insert placeholder type for untyped lambda parameters
    def _fix_lambda(match):
        params = match.group(1)
        if ':' in params:
            return match.group(0)
        return f"({params}: Object)"

    source = re.sub(r'\(([^()]*?)\)\s*(?=->|=>)', _fix_lambda, source)
    set_source(source)
    parser = _get_parser()
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
    gen = ToCSharp(manual_translate=manual_translate, emit_comments=False)
    body = gen.transform(tree)
    comments = pascal_comments_to_csharp(source)
    if comments:
        body = comments + "\n" + body
    return body, gen.todo

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
    import argparse

    parser = argparse.ArgumentParser(description="Transpile Pascal to C#")
    parser.add_argument("files", nargs="+", help="Input Pascal source files")
    parser.add_argument(
        "--interactive", action="store_true", help="Prompt for translations on errors"
    )
    args = parser.parse_args()

    manual = interactive_translate if args.interactive else None
    parse_manual = interactive_parse_error if args.interactive else None

    if len(args.files) == 1:
        src_file = args.files[0]
        try:
            src_txt = Path(src_file).read_text(encoding="utf-8")
        except UnicodeDecodeError:
            src_txt = Path(src_file).read_text(encoding="cp1252")

        cs_out, _ = transpile(
            src_txt,
            manual_translate=manual,
            manual_parse_error=parse_manual,
        )
        safe_print(cs_out)
    else:
        success = 0
        fail = 0
        total = len(args.files)
        bar_width = 40
        for i, src_file in enumerate(args.files, 1):
            try:
                try:
                    src_txt = Path(src_file).read_text(encoding="utf-8")
                except UnicodeDecodeError:
                    src_txt = Path(src_file).read_text(encoding="cp1252")

                cs_out, _ = transpile(
                    src_txt,
                    manual_translate=manual,
                    manual_parse_error=parse_manual,
                )
                Path(src_file).with_suffix(".cs").write_text(cs_out, encoding="utf-8")
                success += 1
            except Exception as e:  # pylint: disable=broad-except
                fail += 1
                print(f"ERROR in {src_file}: {e}", file=sys.stderr)

            percent = i * 100 // total
            hashes = percent * bar_width // 100
            dots = bar_width - hashes
            bar = "#" * hashes + "." * dots
            print(f"[{bar}] {percent}% ({i}/{total}) OK:{success} ERR:{fail}", end="\r", flush=True)

        print()
        print(f"Processed {total} files: ok={success}, errors={fail}")
        if fail:
            sys.exit(1)
