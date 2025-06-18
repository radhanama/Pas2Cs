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

    def test_loops(self):
        src = Path('tests/Loops.pas').read_text()
        expected = Path('tests/Loops.cs').read_text().strip()
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

    def test_generics(self):
        src = Path('tests/Generics.pas').read_text()
        expected = Path('tests/Generics.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_sections(self):
        src = Path('tests/Sections.pas').read_text()
        expected = Path('tests/Sections.cs').read_text().strip()
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

    def test_chained_call(self):
        src = Path('tests/ChainedCall.pas').read_text()
        expected = Path('tests/ChainedCall.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_post_call_index(self):
        src = Path('tests/PostCallIndex.pas').read_text()
        expected = Path('tests/PostCallIndex.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_string_cast(self):
        src = Path('tests/StringCast.pas').read_text()
        expected = Path('tests/StringCast.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_round_double(self):
        src = Path('tests/RoundDouble.pas').read_text()
        expected = Path('tests/RoundDouble.cs').read_text().strip()
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

    def test_control_flow(self):
        src = Path('tests/ControlFlow.pas').read_text()
        expected = Path('tests/ControlFlow.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_raise_stmt(self):
        src = Path('tests/Raise.pas').read_text()
        expected = Path('tests/Raise.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])


    def test_using_stmt(self):
        src = Path('tests/UsingStmt.pas').read_text()
        expected = Path('tests/UsingStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_locking_stmt(self):
        src = Path('tests/LockingStmt.pas').read_text()
        expected = Path('tests/LockingStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_yield_stmt(self):
        src = Path('tests/YieldStmt.pas').read_text()
        expected = Path('tests/YieldStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_try_except_on(self):
        src = Path('tests/TryExceptOn.pas').read_text()
        expected = Path('tests/TryExceptOn.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_with_stmt(self):
        src = Path('tests/WithStmt.pas').read_text()
        expected = Path('tests/WithStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ['// TODO: with statement'])

    def test_enum_record(self):
        src = Path('tests/EnumRecord.pas').read_text()
        expected = Path('tests/EnumRecord.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [
            "// TODO: field R: int -> declare a field",
            "// TODO: field G: int -> declare a field",
            "// TODO: field B: int -> declare a field",
        ])

    def test_set_type(self):
        src = Path('tests/SetType.pas').read_text()
        expected = Path('tests/SetType.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_pointer_ops(self):
        src = Path('tests/PointerOps.pas').read_text()
        expected = Path('tests/PointerOps.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_multi_base(self):
        src = Path('tests/MultiBase.pas').read_text()
        expected = Path('tests/MultiBase.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_event_operator(self):
        src = Path('tests/EventOperator.pas').read_text()
        expected = Path('tests/EventOperator.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ["// TODO: event OnSomething: EventHandler -> implement"])

    def test_field_initializer(self):
        src = Path('tests/FieldInit.pas').read_text()
        expected = Path('tests/FieldInit.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, ["// TODO: field Count: int -> declare a field"])

    def test_typed_using(self):
        src = Path('tests/TypedUsing.pas').read_text()
        expected = Path('tests/TypedUsing.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_typeof_and_new_array(self):
        src = Path('tests/TypeOfNew.pas').read_text()
        expected = Path('tests/TypeOfNew.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_alias_def(self):
        src = Path('tests/AliasDef.pas').read_text()
        expected = Path('tests/AliasDef.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_char_code(self):
        src = Path('tests/CharCode.pas').read_text()
        expected = Path('tests/CharCode.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_char_code_seq(self):
        src = Path('tests/CharCodeSeq.pas').read_text()
        expected = Path('tests/CharCodeSeq.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_var_stmt(self):
        src = Path('tests/VarStmt.pas').read_text()
        expected = Path('tests/VarStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])


    def test_typeof_postfix(self):
        src = Path('tests/TypeOfPostfix.pas').read_text()
        expected = Path('tests/TypeOfPostfix.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_const_param(self):
        src = Path('tests/ConstParam.pas').read_text()
        expected = Path('tests/ConstParam.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_is_operator(self):
        src = Path('tests/IsOp.pas').read_text()
        expected = Path('tests/IsOp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_as_cast(self):
        src = Path('tests/AsCast.pas').read_text()
        expected = Path('tests/AsCast.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_reserved_prop(self):
        src = Path('tests/ReservedProp.pas').read_text()
        expected = Path('tests/ReservedProp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_keyword_name(self):
        src = Path('tests/KeywordName.pas').read_text()
        expected = Path('tests/KeywordName.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_sealed_class(self):
        src = Path('tests/SealedClass.pas').read_text()
        expected = Path('tests/SealedClass.cs').read_text().strip()
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
