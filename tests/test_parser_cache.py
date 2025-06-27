import importlib.util
import sys
from pathlib import Path

MODULE_PATH = Path(__file__).resolve().parents[1] / "pas2cs.py"


def load_module():
    root = MODULE_PATH.parent
    if str(root) not in sys.path:
        sys.path.insert(0, str(root))
    spec = importlib.util.spec_from_file_location("pas2cs_real", MODULE_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_parser_singleton_and_cache_file(tmp_path):
    mod = load_module()
    cache_file = Path(mod.__file__).with_suffix(".lark")
    if cache_file.exists():
        cache_file.unlink()
    p1 = mod._get_parser()
    p2 = mod._get_parser()
    assert p1 is p2
    assert cache_file.exists()
