import unittest
from pathlib import Path
from pas2cs import transpile

class NewFeatureTests(unittest.TestCase):
    def check_pair(self, name: str, allow_todos: bool = False):
        src = Path(f'tests/{name}.pas').read_text()
        expected = Path(f'tests/{name}.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        if not allow_todos:
            self.assertEqual(todos, [])

    def test_var_examples(self):
        self.check_pair('VarExamples')

    def test_type_casting(self):
        self.check_pair('TypeCasting')

    def test_inherited_call(self):
        self.check_pair('InheritedCall')

    def test_inherited_ctor_call(self):
        self.check_pair('InheritedCtorCall')

    def test_property_assign(self):
        self.check_pair('PropertyAssign', allow_todos=True)

    def test_op_assign(self):
        self.check_pair('OpAssign')

    def test_out_arg(self):
        self.check_pair('OutArg')

    def test_var_call_arg(self):
        self.check_pair('VarCallArg', allow_todos=True)

    def test_if_or(self):
        self.check_pair('IfOr', allow_todos=True)

    def test_teste_pas_parses(self):
        """Parsing should succeed for the large external example."""
        src = Path('teste.pas').read_text()
        result, todos = transpile(src)
        self.assertTrue(result.strip())

