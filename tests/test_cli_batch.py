import subprocess
import sys
from pathlib import Path
import tempfile
import unittest

class CLIBatchTests(unittest.TestCase):
    def test_multiple_files(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmp = Path(tmpdir)
            src1 = tmp / "MathUtils.pas"
            src2 = tmp / "Example.pas"
            src1.write_text(Path('tests/MathUtils.pas').read_text())
            src2.write_text(Path('tests/Example.pas').read_text())

            subprocess.run([sys.executable, 'pas2cs.py', str(src1), str(src2)], check=True)

            out1 = (tmp / 'MathUtils.cs').read_text().strip()
            out2 = (tmp / 'Example.cs').read_text().strip()

            self.assertEqual(out1, Path('tests/MathUtils.cs').read_text().strip())
            self.assertEqual(out2, Path('tests/Example.cs').read_text().strip())

if __name__ == '__main__':
    unittest.main()
