import textwrap
# ─────────────────── Utility helpers ─────────────────────────
def indent(code: str, lvl: int = 1) -> str:
    return textwrap.indent(code, "    " * lvl, lambda _: True)

def map_type(pas_type: str) -> str:
    """Map basic Pascal type names to their C# equivalents."""
    simple = pas_type.split('.')[-1]
    mapping = {
        "integer": "int",
        "string": "string",
        "boolean": "bool",
        "object": "object",
    }
    return mapping.get(simple.lower(), pas_type)

def map_type_ext(typ: str) -> str:
    nullable = typ.endswith('?')
    if nullable:
        typ = typ[:-1]
    if typ.endswith('[]'):
        mapped = map_type(typ[:-2]) + '[]'
    else:
        mapped = map_type(typ)
    return mapped + ('?' if nullable else '')

_SRC_TEXT = ""
_LAST_POS = 0

def set_source(text: str) -> None:
    """Store source text so fix_keyword can check surrounding characters."""
    global _SRC_TEXT, _LAST_POS
    _SRC_TEXT = text
    _LAST_POS = 0

def _after_dot(start: int) -> bool:
    if start <= 0:
        return False
    return _SRC_TEXT[start - 1] == '.'

def _followed_by_member(end: int) -> bool:
    if end >= len(_SRC_TEXT):
        return False
    ch = _SRC_TEXT[end]
    return ch == '.' or ch == '<'

def fix_keyword(tok):
    global _LAST_POS
    if tok.value.startswith('&'):
        tok.value = tok.value[1:]
        tok.type = 'CNAME'
        _LAST_POS = tok.end_pos
        return tok

    v = tok.value.lower()
    if _after_dot(tok.start_pos) or _followed_by_member(tok.end_pos):
        tok.type = 'CNAME'
        _LAST_POS = tok.end_pos
        return tok

    if v == "and":
        tok.type = "OP_MUL"
    elif v == "or":
        tok.type = "OP_SUM"
    elif v == "not":
        tok.type = "NOT"
    elif v == "mod":
        tok.type = "OP_MUL"
    elif v == "while":
        tok.type = "WHILE"
    elif v == "do":
        tok.type = "DO"
    elif v == "for":
        tok.type = "FOR"
    elif v == "to":
        tok.type = "TO"
    elif v == "const":
        tok.type = "CONST"
    elif v == "try":
        tok.type = "TRY"
    elif v == "except":
        tok.type = "EXCEPT"
    elif v == "finally":
        tok.type = "FINALLY"
    elif v == "on":
        tok.type = "ON"
    elif v == "end":
        tok.type = "END"
    elif v == "begin":
        tok.type = "BEGIN"
    elif v == "break":
        tok.type = "BREAK"
    elif v == "continue":
        tok.type = "CONTINUE"
    elif v == "each":
        tok.type = "EACH"
    elif v == "step":
        tok.type = "STEP"
    elif v == "loop":
        tok.type = "LOOP"
    elif v == "with":
        tok.type = "WITH"
    elif v == "using":
        tok.type = "USING"
    elif v == "locking":
        tok.type = "LOCKING"
    elif v == "yield":
        tok.type = "YIELD"
    elif v == "autoreleasepool":
        tok.type = "AUTORELEASEPOOL"
    elif v == "record":
        tok.type = "RECORD"
    elif v == "interface":
        tok.type = "INTERFACE"
    elif v == "enum":
        tok.type = "ENUM"
    elif v == "flags":
        tok.type = "FLAGS"
    elif v == "event":
        tok.type = "EVENT"
    elif v == "operator":
        tok.type = "OPERATOR"
    elif v == "tuple":
        tok.type = "TUPLE"
    elif v == "typeof":
        tok.type = "TYPEOF"
    elif v == "is":
        tok.type = "IS"
    elif v == "as":
        tok.type = "AS"

    _LAST_POS = tok.end_pos
    return tok
