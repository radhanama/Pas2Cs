import importlib.util
import sys
from pathlib import Path

# Load the actual pas2cs module from the repository root when tests are run
root_dir = Path(__file__).resolve().parent.parent
if str(root_dir) not in sys.path:
    sys.path.insert(0, str(root_dir))
_pkg_path = root_dir / 'pas2cs.py'
_spec = importlib.util.spec_from_file_location('pas2cs_real', _pkg_path)
_module = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_module)

# Re-export the public API used by tests
transpile = _module.transpile
