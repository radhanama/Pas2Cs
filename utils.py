import textwrap
import sys
import locale
import unicodedata
import re
# ─────────────────── Utility helpers ─────────────────────────
def indent(code: str, lvl: int = 1) -> str:
    return textwrap.indent(code, "    " * lvl, lambda _: True)

def remove_accents(text: str) -> str:
    """Return `text` with any diacritical marks stripped."""
    nfkd = unicodedata.normalize('NFD', text)
    return ''.join(ch for ch in nfkd if not unicodedata.combining(ch))

def remove_accents_code(text: str) -> str:
    """Strip accents from `text` but keep contents of single-quoted strings."""
    result = []
    i = 0
    in_str = False
    while i < len(text):
        ch = text[i]
        if in_str:
            result.append(ch)
            if ch == "'":
                if i + 1 < len(text) and text[i + 1] == "'":
                    result.append(text[i + 1])
                    i += 1
                else:
                    in_str = False
            i += 1
            continue
        else:
            if ch == "'":
                in_str = True
                result.append(ch)
            else:
                result.append(remove_accents(ch))
            i += 1
    return ''.join(result)

def map_type(pas_type: str) -> str:
    """Map basic Pascal type names to their C# equivalents."""
    simple = pas_type.split('.')[-1]
    mapping = {
        "integer": "int",
        "longint": "int",
        "longword": "uint",
        "smallint": "short",
        "shortint": "sbyte",
        "word": "ushort",
        "byte": "byte",
        "single": "float",
        "double": "double",
        "real": "double",
        "extended": "double",
        "currency": "decimal",
        "comp": "decimal",
        "char": "char",
        "widechar": "char",
        "ansistring": "string",
        "widestring": "string",
        "variant": "object",
        "olevariant": "object",
        "string": "string",
        "type": "System.Type",
        "stringbuilder": "StringBuilder",
        "dataset": "DataSet",
        "datatable": "DataTable",
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

# Mapping of Pascal keywords to their lexer token types. Used by `fix_keyword`
# for efficient keyword detection.
KEYWORD_MAP = {
    "and": "OP_MUL",
    "or": "OP_SUM",
    "not": "NOT",
    "mod": "OP_MUL",
    "div": "OP_MUL",
    "while": "WHILE",
    "do": "DO",
    "for": "FOR",
    "to": "TO",
    "const": "CONST",
    "try": "TRY",
    "except": "EXCEPT",
    "finally": "FINALLY",
    "on": "ON",
    "end": "END",
    "begin": "BEGIN",
    "break": "BREAK",
    "continue": "CONTINUE",
    "each": "EACH",
    "step": "STEP",
    "loop": "LOOP",
    "shl": "OP_MUL",
    "shr": "OP_MUL",
    "xor": "OP_SUM",
    "with": "WITH",
    "using": "USING",
    "locking": "LOCKING",
    "yield": "YIELD",
    "autoreleasepool": "AUTORELEASEPOOL",
    "record": "RECORD",
    "interface": "INTERFACE",
    "enum": "ENUM",
    "flags": "FLAGS",
    "event": "EVENT",
    "operator": "OPERATOR",
    "delegate": "DELEGATE",
    "packed": "PACKED",
    "tuple": "TUPLE",
    "typeof": "TYPEOF",
    "sealed": "SEALED",
    "final": "FINAL",
    "inline": "INLINE",
    "cdecl": "CDECL",
    "stdcall": "STDCALL",
    "safecall": "SAFECALL",
    "varargs": "VARARGS",
    "external": "EXTERNAL",
    "forward": "FORWARD",
    "threadvar": "THREADVAR",
    "is": "IS",
    "as": "AS",
    "case": "CASE",
    "program": "PROGRAM",
    "initialization": "INITIALIZATION",
    "finalization": "FINALIZATION",
    "inherited": "INHERITED",
}

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

    if tok.value.lower() in ('enum', 'interface'):
        pos = tok.end_pos
        while pos < len(_SRC_TEXT) and _SRC_TEXT[pos].isspace():
            pos += 1
        if pos < len(_SRC_TEXT) and _SRC_TEXT[pos] == ':':
            tok.type = 'CNAME'
            _LAST_POS = tok.end_pos
            return tok

    token_type = KEYWORD_MAP.get(v)
    if token_type:
        tok.type = token_type

    _LAST_POS = tok.end_pos
    return tok

# C# reserved keywords that cannot be used as identifiers
CS_KEYWORDS = {
    "abstract", "as", "base", "bool", "break", "byte", "case", "catch",
    "char", "checked", "class", "const", "continue", "decimal", "default",
    "delegate", "do", "double", "else", "enum", "event", "explicit",
    "extern", "false", "finally", "fixed", "float", "for", "foreach", "goto",
    "if", "implicit", "in", "int", "interface", "internal", "is", "lock",
    "long", "namespace", "new", "null", "object", "operator", "out",
    "override", "params", "private", "protected", "public", "readonly",
    "ref", "return", "sbyte", "sealed", "short", "sizeof", "stackalloc",
    "static", "string", "struct", "switch", "this", "throw", "true", "try",
    "typeof", "uint", "ulong", "unchecked", "unsafe", "ushort", "using",
    "virtual", "void", "volatile", "while"
}

def escape_cs_keyword(name: str) -> str:
    """Prefix `name` with '@' if it is a reserved C# keyword."""
    return f"@{name}" if name in CS_KEYWORDS else name


def safe_print(text: str) -> None:
    """Print `text` without raising encoding errors."""
    enc = sys.stdout.encoding or locale.getpreferredencoding(False)
    sys.stdout.buffer.write(text.encode(enc, errors="replace"))
    sys.stdout.buffer.write(b"\n")


REGION_START_RE = re.compile(r"{\s*region\s+(.*?)\s*}", re.IGNORECASE)
REGION_END_RE = re.compile(r"{\s*endregion\s*}", re.IGNORECASE)


def pascal_comments_to_csharp(source: str) -> str:
    """Return Pascal comments in `source` converted to C# syntax."""
    parts: list[str] = []
    i = 0
    n = len(source)
    while i < n:
        ch = source[i]
        if ch == "'":
            i += 1
            while i < n:
                if source[i] == "'":
                    if i + 1 < n and source[i + 1] == "'":
                        i += 2
                    else:
                        i += 1
                        break
                else:
                    i += 1
        elif ch == '/' and i + 1 < n and source[i + 1] == '/':
            start = i
            i += 2
            while i < n and source[i] != '\n':
                i += 1
            parts.append(source[start:i].strip())
        elif ch == '{' and not (i + 1 < n and source[i + 1] == '$'):
            start = i
            i += 1
            while i < n and source[i] != '}':
                i += 1
            i += 1
            text = source[start:i]
            if REGION_START_RE.fullmatch(text):
                parts.append('#region ' + text[1:-1].strip().split(None, 1)[1])
            elif REGION_END_RE.fullmatch(text):
                parts.append('#endregion')
            else:
                parts.append('/* ' + text[1:-1].strip() + ' */')
        elif ch == '(' and i + 1 < n and source[i + 1] == '*':
            start = i
            i += 2
            while i + 1 < n and not (source[i] == '*' and source[i + 1] == ')'):
                i += 1
            i += 2
            parts.append('/* ' + source[start + 2 : i - 2].strip() + ' */')
        elif ch == '/' and i + 1 < n and source[i + 1] == '*':
            start = i
            i += 2
            while i + 1 < n and not (source[i] == '*' and source[i + 1] == '/'):
                i += 1
            i += 2
            parts.append('/* ' + source[start + 2 : i - 2].strip() + ' */')
        else:
            i += 1

    return "\n".join(parts)
