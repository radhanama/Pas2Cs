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

    def test_for_downto(self):
        src = Path('tests/ForDownTo.pas').read_text()
        expected = Path('tests/ForDownTo.cs').read_text().strip()
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

    def test_class_members(self):
        src = Path('tests/ClassMembers.pas').read_text()
        expected = Path('tests/ClassMembers.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(
            todos,
            [
                "// TODO: field count: int -> declare a field",
                "// TODO: property Name: string -> implement as auto-property",
                "// TODO: const DefaultCount -> define a constant",
            ],
        )

    def test_ctor_no_name(self):
        src = Path('tests/CtorNoName.pas').read_text()
        expected = Path('tests/CtorNoName.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_param_defaults(self):
        src = Path('tests/Defaults.pas').read_text()
        expected = Path('tests/Defaults.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_property_write_only(self):
        src = Path('tests/WriteProp.pas').read_text()
        expected = Path('tests/WriteProp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ["// TODO: property Flag: bool -> implement as auto-property"])

    def test_indexed_property(self):
        src = Path('tests/IndexedProp.pas').read_text()
        expected = Path('tests/IndexedProp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ["// TODO: property Items: string -> implement as auto-property"])

    def test_no_implementation(self):
        src = Path('tests/NoImpl.pas').read_text()
        expected = Path('tests/NoImpl.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_interface_only(self):
        src = Path('tests/InterfaceOnly.pas').read_text()
        expected = Path('tests/InterfaceOnly.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_ctor_impl_no_name(self):
        src = Path('tests/CtorImplNoName.pas').read_text()
        expected = Path('tests/CtorImplNoName.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_while_var_init(self):
        src = Path('tests/WhileVarInit.pas').read_text()
        expected = Path('tests/WhileVarInit.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_chained_call(self):
        src = Path('tests/ChainedCall.pas').read_text()
        expected = Path('tests/ChainedCall.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_method_attr(self):
        src = Path('tests/MethodAttr.pas').read_text()
        expected = Path('tests/MethodAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_case_stmt(self):
        src = Path('tests/CaseStmt.pas').read_text()
        expected = Path('tests/CaseStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ['// TODO: case statement'])

    def test_class_var(self):
        src = Path('tests/ClassVar.pas').read_text()
        expected = Path('tests/ClassVar.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ['// TODO: field Log: int -> declare a field'])

    def test_new_args(self):
        src = Path('tests/NewArgs.pas').read_text()
        expected = Path('tests/NewArgs.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_mod_expr(self):
        src = Path('tests/ModExpr.pas').read_text()
        expected = Path('tests/ModExpr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_less_than_call(self):
        src = Path('tests/LessThanCall.pas').read_text()
        expected = Path('tests/LessThanCall.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_long_if(self):
        src = Path('tests/LongIf.pas').read_text()
        expected = Path('tests/LongIf.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_complex_if(self):
        src = Path('tests/ComplexIf.pas').read_text()
        expected = Path('tests/ComplexIf.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_raise_stmt(self):
        src = Path('tests/Raise.pas').read_text()
        expected = Path('tests/Raise.cs').read_text().strip()
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
