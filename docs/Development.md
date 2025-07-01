# Developer Guide

This document describes the structure of **pas2cs** and how to extend it.

## Project Layout

```
Readme.md           – quick overview and usage
pas2cs.py           – command line entry point and transpile() function
grammar.py          – Lark grammar for Object Pascal
transformer.py      – visitor that converts the parse tree to C# code
utils.py            – helper routines
batch_transpile.sh  – Bash helper to convert many files
/tests/             – sample Pascal files and expected C# outputs
```

## Running the Transpiler

```
python pas2cs.py path/to/File.pas > File.cs
```

Use `--interactive` to be prompted for translations when the parser
encounters unsupported constructs.

To batch convert a directory you can run `./batch_transpile.sh log.txt DIR`.

## How It Works

1. `pas2cs.py` loads `GRAMMAR` from **grammar.py** and parses the Pascal source
   using the [Lark](https://github.com/lark-parser/lark) LALR parser.
2. A `ToCSharp` transformer defined in **transformer.py** walks the parse tree
   and builds a C# string. Unsupported rules add comments.
3. `transpile()` returns the generated source and any collected notes.

## Making Changes

Changes usually touch three areas:

1. **grammar.py** – adds new parsing rules.
2. **transformer.py** – converts the new rules to C#.
3. **tests/** – Pascal input and expected C# output to prevent regressions.

When adding new features, update the grammar first, then implement the
translation logic and finally create a test case demonstrating the new behaviour.
Run `pytest` to ensure everything still works.

### Editing the Grammar

The syntax accepted by the parser is defined in the `GRAMMAR` constant of
`grammar.py`.  It follows the [Lark](https://lark-parser.readthedocs.io/) EBNF
format where each rule is written as `name: ...` or `?name: ...`.  A rule name
that appears after `->` becomes a method of the same name in `ToCSharp`.

When you need to support a new Pascal construct:

1. Add or modify the appropriate rule inside `GRAMMAR`.
2. Implement `ToCSharp.<rule_name>` to emit the corresponding C# code.
3. Add a `.pas` input and the expected `.cs` output under `tests/`.
4. Update any relevant scenarios in `tests/test_transpile.py` and run
   `pytest`.

Keeping grammar and transformer names aligned ensures the visitor picks up your
new rules automatically.

### Common Scenarios

- **Adding a control statement** (e.g. `repeat … until`)
  1. Extend `GRAMMAR` with a `repeat_stmt` rule.
  2. Implement a `repeat_stmt` method in `ToCSharp` returning valid C#.
  3. Add a `.pas`/`.cs` pair under `tests/` and update `tests/test_transpile.py`.

- **Mapping a new type**
  1. Edit `utils.map_type()` to map the Pascal type name to its C# equivalent.
  2. Add a sample file showing the type being used and expected output.

- **Handling a new expression or operator**
  1. Describe its syntax in `grammar.py`.
  2. Emit the C# form from the transformer.
  3. Add tests covering success cases and edge cases.

## Running Tests

Install dependencies and execute:

```
pip install lark-parser
pytest -q
```

All tests should pass before committing changes.  The suite transpiles every
example in `tests/` and compares it with the expected C# output.

---

For more general usage information see [Readme.md](../Readme.md).
