# Pas2CsCS

This C# project is a thin wrapper around the Python `pas2cs` transpiler.
It also includes a lexer generated with **gplex**.

## Generated scanner

`PascalScanner.cs` is produced from `Pas2CsScanner.lex` using
[gplex](https://github.com/qsnake/gplex). The generated file is checked
into version control so you do not need gplex installed unless you
modify the lexer rules. To regenerate the scanner run:

```bash
gplex Pas2CsScanner.lex
```

## Building and running

Make sure Python 3 and the `lark-parser` package are available (as
required by the Python version). Then you can transpile a Pascal file to
C# like this:

```bash
# Build the wrapper
dotnet build Pas2CsCS/Pas2CsCS.csproj

# Run the transpiler
dotnet run -p Pas2CsCS/Pas2CsCS.csproj -- path/to/input.pas > output.cs
```

Any TODO notices from the underlying Python transpiler will be printed to
`stderr`.

## Tests

The same samples used by the Python tests are executed by the C# test
suite:

```bash
dotnet test Pas2CsCS.Tests/Pas2CsCS.Tests.csproj -v minimal
python3 -m pytest -q tests/test_transpile.py
```
