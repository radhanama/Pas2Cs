import unittest
from pathlib import Path
from pas2cs import transpile

class NewFeatureTests(unittest.TestCase):
    def check_pair(self, name: str):
        src = Path(f'tests/{name}.pas').read_text()
        expected = Path(f'tests/{name}.cs').read_text().strip()
        result, todos = transpile(src)
        self.assertEqual(result.strip(), expected)
        self.assertEqual(todos, [])

    def test_var_infer(self):
        self.check_pair('VarInfer')

    def test_not_in_expr(self):
        self.check_pair('NotInExpr')

    def test_as_cast_call(self):
        self.check_pair('AsCastCall')

    def test_inherited_call(self):
        self.check_pair('InheritedCall')
