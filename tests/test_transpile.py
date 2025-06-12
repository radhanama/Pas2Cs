import unittest
from pathlib import Path
from pas2cs import transpile

class TranspileTests(unittest.TestCase):
    def test_mathutils(self):
        src = Path('tests/MathUtils.pas').read_text()
        expected = Path('tests/MathUtils.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_exportar_dados(self):
        src = Path('tests/ExportarDados.pas').read_text()
        expected = Path('tests/ExportarDados.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_example_procedures(self):
        src = Path('tests/Example.pas').read_text()
        expected = Path('tests/Example.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_multi_params(self):
        src = Path('tests/MultiParams.pas').read_text()
        expected = Path('tests/MultiParams.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_multi_vars(self):
        src = Path('tests/MultiVars.pas').read_text()
        expected = Path('tests/MultiVars.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_comments(self):
        src = Path('tests/Commented.pas').read_text()
        expected = Path('tests/Commented.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_single_stmt(self):
        src = Path('tests/SingleStmt.pas').read_text()
        expected = Path('tests/SingleStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_escaped_str(self):
        src = Path('tests/EscapedStr.pas').read_text()
        expected = Path('tests/EscapedStr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_array_var(self):
        src = Path('tests/ArrayVar.pas').read_text()
        expected = Path('tests/ArrayVar.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_index_assign(self):
        src = Path('tests/IndexAssign.pas').read_text()
        expected = Path('tests/IndexAssign.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_generic_example(self):
        src = Path('tests/GenericExample.pas').read_text()
        expected = Path('tests/GenericExample.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_generic_static(self):
        src = Path('tests/GenericStatic.pas').read_text()
        expected = Path('tests/GenericStatic.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_sections(self):
        src = Path('tests/Sections.pas').read_text()
        expected = Path('tests/Sections.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_generic_base(self):
        src = Path('tests/GenericBase.pas').read_text()
        expected = Path('tests/GenericBase.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_complex_function(self):
        src = Path('tests/ComplexFunction.pas').read_text()
        expected = Path('tests/ComplexFunction.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_return_only(self):
        src = Path('tests/ReturnOnly.pas').read_text()
        expected = Path('tests/ReturnOnly.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_error_reporting(self):
        src = Path('tests/BadSyntax.pas').read_text()
        with self.assertRaises(SyntaxError) as cm:
            transpile(src)
        self.assertIn('Parse error', str(cm.exception))

if __name__ == '__main__':
    unittest.main()
