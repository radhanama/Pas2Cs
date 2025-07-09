import unittest
from pathlib import Path

class RunConversionScriptTest(unittest.TestCase):
    def test_starts_omnisharp(self):
        content = Path('run_conversion.sh').read_text()
        self.assertIn('omnisharp -s', content)
        self.assertIn('curl -s http://localhost:2000/checkreadiness', content)

if __name__ == '__main__':
    unittest.main()
