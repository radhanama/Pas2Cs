````markdown
# pas2cs – Oxygene / Object-Pascal → C# Transpiler (v0.3)

Small transpiler that converts the *simple* parts of an Oxygene
(`.pas`) codebase to compilable C# (`.cs`).
It lets you **migrate a legacy Pascal project one file at a time** while
keeping both languages building in the same .NET solution.

---

## ✨ Features

| Status | Capability |
|--------|------------|
| ✅ | Parses `namespace`, `type … public class`, static `class method`s |
| ✅ | Converts `Integer`, `String`, `Boolean` → `int`, `string`, `bool` |
| ✅ | Handles `begin … end` blocks, `if … then … else`, `for … to … do` |
| ✅ | Supports `exit …;` and implicit `Result` variables |
| ✅ | Arithmetic/logic ops (`+ - * / and or`, `= <> <= >=`) |
| ✅ | Emits **comments** + stderr warnings for unsupported constructs |
| 🔜 | Add `while`, `try/finally`, `record`, generics, properties, etc. |

---

## 📦  Requirements

* **Python 3.9+** (tested on 3.11 & 3.12)
* **Lark-parser** library

```bash
pip install lark-parser
````

> Want a single executable?
> `pip install pyinstaller` then `pyinstaller --onefile pas2cs.py`

---

## 🚀  Quick Start

```bash
# 1. Generate C# from one file
python pas2cs.py  Demo/MathUtils.pas  >  Demo/MathUtils.cs

# 2. Batch-convert on Linux/macOS
./batch_transpile.sh errors.log Demo/

# 3. Batch-convert a project (PowerShell example)
Get-ChildItem . -Recurse -Filter *.pas | ForEach-Object {
    $out = $_.FullName -replace '\.pas$','.cs'
    python pas2cs.py $_.FullName > $out
}
```

> Any **unsupported syntax** is inserted as comments so the generated `.cs`
> still compiles (after you stub or fix the line manually).

---

## 🛠️  Integrate with MSBuild

Add this snippet to your `.csproj` to regenerate C# before each build:

```xml
<ItemGroup>
  <PascalFiles Include="**\*.pas" />
</ItemGroup>

<Target Name="TranspilePascal" BeforeTargets="Compile">
  <!-- Write each .pas → .cs next to the original file -->
  <Exec Command="python $(ProjectDir)pas2cs.py @(PascalFiles->'%(FullPath)') > %(PascalFiles.Filename).cs" />
  <ItemGroup>
    <!-- Prevent Roslyn from trying to compile the Pascal files -->
    <Compile Remove="@(PascalFiles)" />
  </ItemGroup>
</Target>
```

Now `dotnet build` or Visual Studio’s **Build** button transparently converts
and compiles everything.

### Fixing identifier casing

Oxygene source is case-insensitive but C# is not. After transpilation you can
run the optional `CaseFixer` utility to update the casing of identifiers by
querying an OmniSharp server. Build the tool with `dotnet build` and execute it
on the root of your generated C# files:

```bash
dotnet run --project CaseFixer.csproj ./MyProject --backup --threads 4
```

The tool rewrites the files in place (optionally keeping `.bak` backups) so your
C# code matches the canonical casing known to Roslyn.

### Installing OmniSharp

`CaseFixer` expects an OmniSharp HTTP server listening on port `2000`.
Run the provided script to download and unpack a local copy:

```bash
./install_omnisharp.sh
```

Start the server from your solution root:

```bash
~/.omnisharp/OmniSharp -s .
```

Then execute `CaseFixer` on your generated files.

---

## 🏗️  Extending

1. **Add syntax**
   *Edit `GRAMMAR`*: insert new rules (`while_stmt`, `property_decl`, …).
2. **Emit C#**
   *Add a method to the `ToCSharp` visitor* that turns the new rule into C#.
3. **Unit-test**
   Feed a sample `.pas`, assert the produced C# builds & unit tests stay green.
4. **Switch to Roslyn (optional)**
   Replace the current string concat with `SyntaxFactory` nodes for perfect
   formatting and easier refactoring.

Each new rule shrinks the comment count and lets you delete more
legacy `.pas` files.

More in-depth development guidance can be found in
[docs/Development.md](docs/Development.md).

---

## 🤝  Contributing

* Fork → feature branch → PR.
* Include a *before/after* Pascal sample + generated C# in `tests/`.
* Keep the script self-contained; avoid heavy dependencies.

---

## 📄  License

**MIT Zero (MIT-0)** – do anything, no warranty.

*Happy porting!*

```
```
