import textwrap
# ─────────────────── Utility helpers ─────────────────────────
def indent(code: str, lvl: int = 1) -> str:
    return textwrap.indent(code, "    " * lvl, lambda _: True)

def map_type(pas_type: str) -> str:
    simple = pas_type.split('.')[-1]
    mapping = {
        "Integer": "int",
        "String": "string",
        "Boolean": "bool",
        "Object": "object",
    }
    return mapping.get(simple, pas_type)

def map_type_ext(typ: str) -> str:
    if typ.endswith('[]'):
        return map_type(typ[:-2]) + '[]'
    return map_type(typ)

def fix_keyword(tok):
    if tok.value.startswith('&'):
        tok.value = tok.value[1:]
    v = tok.value.lower()
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
    return tok
