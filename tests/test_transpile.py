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
        src = Path('tests/Comments.pas').read_text()
        expected = Path('tests/Comments.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_line_comment(self):
        src = Path('tests/LineComment.pas').read_text()
        expected = Path('tests/LineComment.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_if_comment(self):
        src = Path('tests/IfComment.pas').read_text()
        expected = Path('tests/IfComment.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_if_expr_comment(self):
        src = Path('tests/IfExprComment.pas').read_text()
        expected = Path('tests/IfExprComment.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_expr_comment(self):
        src = Path('tests/ExprComment.pas').read_text()
        expected = Path('tests/ExprComment.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_file_header(self):
        src = Path('tests/FileHeader.pas').read_text()
        expected = Path('tests/FileHeader.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_keyword_prefix(self):
        src = Path('tests/KeywordPrefix.pas').read_text()
        expected = Path('tests/KeywordPrefix.cs').read_text().strip()
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

    def test_interpolated_str(self):
        src = Path('tests/InterpolatedStr.pas').read_text()
        expected = Path('tests/InterpolatedStr.cs').read_text().strip()
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

    def test_class_alias(self):
        src = Path('tests/ClassAlias.pas').read_text()
        expected = Path('tests/ClassAlias.cs').read_text().strip()
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
        self.assertEqual(todos, [])

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
        self.assertEqual(todos, [])

    def test_indexed_property(self):
        src = Path('tests/IndexedProp.pas').read_text()
        expected = Path('tests/IndexedProp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_property_reintroduce(self):
        src = Path('tests/ReintroduceProp.pas').read_text()
        expected = Path('tests/ReintroduceProp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

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

    def test_empty_unit(self):
        src = Path('tests/EmptyUnit.pas').read_text()
        expected = Path('tests/EmptyUnit.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_uses_before_interface(self):
        src = Path('tests/UsesBeforeInterface.pas').read_text()
        expected = Path('tests/UsesBeforeInterface.cs').read_text().strip()
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

    def test_misc_ops(self):
        src = Path('tests/MiscOps.pas').read_text()
        expected = Path('tests/MiscOps.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])


    def test_method_attr(self):
        src = Path('tests/MethodAttr.pas').read_text()
        expected = Path('tests/MethodAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_overload_attr(self):
        src = Path('tests/OverloadAttr.pas').read_text()
        expected = Path('tests/OverloadAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_field_attr(self):
        src = Path('tests/FieldAttr.pas').read_text()
        expected = Path('tests/FieldAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_return_attr(self):
        src = Path('tests/ReturnAttr.pas').read_text()
        expected = Path('tests/ReturnAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_method_conv(self):
        src = Path('tests/MethodConv.pas').read_text()
        expected = Path('tests/MethodConv.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_case_statements(self):
        src = Path('tests/CaseStatements.pas').read_text()
        expected = Path('tests/CaseStatements.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_negative_case(self):
        src = Path('tests/NegativeCase.pas').read_text()
        expected = Path('tests/NegativeCase.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_case_comment(self):
        src = Path('tests/CaseComment.pas').read_text()
        expected = Path('tests/CaseComment.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_large_case_range(self):
        src = Path('tests/LargeCaseRange.pas').read_text()
        expected = Path('tests/LargeCaseRange.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_range_words(self):
        src = Path('tests/RangeWords.pas').read_text()
        expected = Path('tests/RangeWords.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_class_var(self):
        src = Path('tests/ClassVar.pas').read_text()
        expected = Path('tests/ClassVar.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_class_var_section(self):
        src = Path('tests/ClassVarSection.pas').read_text()
        expected = Path('tests/ClassVarSection.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

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

    def test_div_expr(self):
        src = Path('tests/DivExpr.pas').read_text()
        expected = Path('tests/DivExpr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_less_than_call(self):
        src = Path('tests/LessThanCall.pas').read_text()
        expected = Path('tests/LessThanCall.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_date_parse_compare(self):
        src = Path('tests/DateParseCompare.pas').read_text()
        expected = Path('tests/DateParseCompare.cs').read_text().strip()
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

    def test_try_blocks(self):
        src = Path('tests/TryBlocks.pas').read_text()
        expected = Path('tests/TryBlocks.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])


    def test_with_stmt(self):
        src = Path('tests/WithStmt.pas').read_text()
        expected = Path('tests/WithStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_enum_record(self):
        src = Path('tests/EnumRecord.pas').read_text()
        expected = Path('tests/EnumRecord.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_packed_record(self):
        src = Path('tests/PackedRecord.pas').read_text()
        expected = Path('tests/PackedRecord.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_set_type(self):
        src = Path('tests/SetType.pas').read_text()
        expected = Path('tests/SetType.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])
    def test_event_operator(self):
        src = Path('tests/EventOperator.pas').read_text()
        expected = Path('tests/EventOperator.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_event_raise(self):
        src = Path('tests/EventRaise.pas').read_text()
        expected = Path('tests/EventRaise.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_field_initializer(self):
        src = Path('tests/FieldInit.pas').read_text()
        expected = Path('tests/FieldInit.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

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

    def test_delegate_def(self):
        src = Path('tests/DelegateDef.pas').read_text()
        expected = Path('tests/DelegateDef.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_char_utils(self):
        src = Path('tests/CharUtils.pas').read_text()
        expected = Path('tests/CharUtils.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_var_examples(self):
        src = Path('tests/VarExamples.pas').read_text()
        expected = Path('tests/VarExamples.cs').read_text().strip()
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

    def test_type_casting(self):
        src = Path('tests/TypeCasting.pas').read_text()
        expected = Path('tests/TypeCasting.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_is_not_type(self):
        src = Path('tests/IsNotType.pas').read_text()
        expected = Path('tests/IsNotType.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_typeof_expr(self):
        src = Path('tests/TypeOfExpr.pas').read_text()
        expected = Path('tests/TypeOfExpr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_reserved_prop(self):
        src = Path('tests/ReservedProp.pas').read_text()
        expected = Path('tests/ReservedProp.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_reserved_member_access(self):
        src = Path('tests/ReservedMemberAccess.pas').read_text()
        expected = Path('tests/ReservedMemberAccess.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_keyword_name(self):
        src = Path('tests/KeywordName.pas').read_text()
        expected = Path('tests/KeywordName.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_cs_keyword_var(self):
        src = Path('tests/CsKeywordVar.pas').read_text()
        expected = Path('tests/CsKeywordVar.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_pas_keyword_var(self):
        src = Path('tests/PasKeywordVar.pas').read_text()
        expected = Path('tests/PasKeywordVar.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_sealed_class(self):
        src = Path('tests/SealedClass.pas').read_text()
        expected = Path('tests/SealedClass.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_partial_sealed_class(self):
        src = Path('tests/PartialSealed.pas').read_text()
        expected = Path('tests/PartialSealed.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_new_stmt(self):
        src = Path('tests/NewStmt.pas').read_text()
        expected = Path('tests/NewStmt.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_lambda(self):
        src = Path('tests/Lambda.pas').read_text()
        expected = Path('tests/Lambda.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_anon_proc(self):
        src = Path('tests/AnonProc.pas').read_text()
        expected = Path('tests/AnonProc.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_array_cast(self):
        src = Path('tests/ArrayCast.pas').read_text()
        expected = Path('tests/ArrayCast.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_nullable(self):
        src = Path('tests/Nullable.pas').read_text()
        expected = Path('tests/Nullable.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])




    def test_if_statements(self):
        src = Path('tests/IfStatements.pas').read_text()
        expected = Path('tests/IfStatements.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_hour_check(self):
        src = Path('tests/HourCheck.pas').read_text()
        expected = Path('tests/HourCheck.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_multi_type_sections(self):
        src = Path('tests/MultiTypeSections.pas').read_text()
        expected = Path('tests/MultiTypeSections.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_number_literals(self):
        src = Path('tests/NumberLiterals.pas').read_text()
        expected = Path('tests/NumberLiterals.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_bug_fixes(self):
        src = Path('tests/BugFixes.pas').read_text()
        expected = Path('tests/BugFixes.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_error_reporting(self):
        src = Path('tests/BadSyntax.pas').read_text()
        with self.assertRaises(SyntaxError) as cm:
            transpile(src)
        self.assertIn('Parse error', str(cm.exception))

    def test_error_line_numbers(self):
        src = Path('tests/BadSyntax.pas').read_text()
        with self.assertRaises(SyntaxError) as cm:
            transpile(src)
        self.assertIn('line 15', str(cm.exception))

    def test_semicolon_cases(self):
        src = Path('tests/SemicolonCases.pas').read_text()
        expected = Path('tests/SemicolonCases.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_extra_semi(self):
        src = Path('tests/ExtraSemi.pas').read_text()
        expected = Path('tests/ExtraSemi.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])


    def test_local_const(self):
        src = Path('tests/LocalConst.pas').read_text()
        expected = Path('tests/LocalConst.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_unit_module(self):
        src = Path('tests/UnitModule.pas').read_text()
        expected = Path('tests/UnitModule.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_ternary_if(self):
        src = Path('tests/TernaryIf.pas').read_text()
        expected = Path('tests/TernaryIf.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_program_module(self):
        src = Path('tests/ProgramModule.pas').read_text()
        expected = Path('tests/ProgramModule.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_shift_ops(self):
        src = Path('tests/ShiftOps.pas').read_text()
        expected = Path('tests/ShiftOps.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_array_indexof(self):
        src = Path('tests/ArrayIndexOf.pas').read_text()
        expected = Path('tests/ArrayIndexOf.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_program_types(self):
        src = Path('tests/ProgramTypes.pas').read_text()
        expected = Path('tests/ProgramTypes.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_program_cases(self):
        src = Path('tests/ProgramCases.pas').read_text()
        expected = Path('tests/ProgramCases.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_program_globals(self):
        src = Path('tests/ProgramGlobals.pas').read_text()
        expected = Path('tests/ProgramGlobals.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_extra_keywords(self):
        src = Path('tests/ExtraKeywords.pas').read_text()
        expected = Path('tests/ExtraKeywords.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_accented_name(self):
        src = Path('tests/AccentedName.pas').read_text()
        expected = Path('tests/AccentedName.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_string_literal_call(self):
        src = Path('tests/StringLiteralCall.pas').read_text()
        expected = Path('tests/StringLiteralCall.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_implements_attr(self):
        src = Path('tests/ImplementsAttr.pas').read_text()
        expected = Path('tests/ImplementsAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_assembly_attr(self):
        src = Path('tests/AssemblyAttr.pas').read_text()
        expected = Path('tests/AssemblyAttr.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_assembly_protected(self):
        src = Path('tests/AssemblyProtected.pas').read_text()
        expected = Path('tests/AssemblyProtected.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_example_issue(self):
        src = Path("tests/ExampleIssue.pas").read_text()
        expected = Path("tests/ExampleIssue.cs").read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_var_section_comment(self):
        src = Path('tests/VarSectionComment.pas').read_text()
        expected = Path('tests/VarSectionComment.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])



    def test_safe_print_cp1252(self):
        import io, sys
        from utils import safe_print

        buf = io.BytesIO()
        writer = io.TextIOWrapper(buf, encoding="cp1252", errors="strict")
        original = sys.stdout
        sys.stdout = writer
        try:
            safe_print("\u0151")
            writer.flush()
        finally:
            sys.stdout = original
        out = buf.getvalue()
        self.assertTrue(out.endswith(b"\n"))

if __name__ == '__main__':
    unittest.main()
