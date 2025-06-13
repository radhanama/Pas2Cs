# ────────────────────────── Grammar ──────────────────────────
GRAMMAR = r"""
?start:      namespace interface_section? class_section ("implementation" class_impl*)? ("end" ".")?

interface_section: "interface" uses_clause?
uses_clause:   "uses" dotted_name ("," dotted_name)* ";"         -> uses

namespace:   "namespace" dotted_name ";"                          -> namespace
dotted_name: CNAME ("." CNAME)*                                    -> dotted
class_section: "type" class_def+                                  -> class_section
class_def:   CNAME "=" "public" "static"? "partial"? "abstract"? "class" ("(" type_name ")")? class_signature "end" ";" -> class_def

class_signature: member_decl*                                     -> class_sign
member_decl: access_modifier                                      -> section
           | access_modifier? "class"? method_kind method_sig ";" method_attr* ";"? -> method_decl
           | access_modifier? "class"? name_list ":" type_name ";"         -> field_decl
           | access_modifier? "class"? "property" property_sig ";"          -> property_decl
           | access_modifier? "class"? "const" const_decl+                  -> const_block
method_attr: "override" | "static" | "abstract" | "virtual"
method_kind: METHOD | PROCEDURE | FUNCTION | CONSTRUCTOR | DESTRUCTOR
access_modifier: "public" | "protected" | "private"

method_sig:   method_name param_block? return_block?              -> m_sig
             | param_block? return_block?                        -> m_sig_no_name
method_name: CNAME ("." CNAME)+           -> dotted_method
           | CNAME                         -> simple_method
param_block: "(" param_list? ")"           -> params
return_block: ":" type_name                -> rettype
param_list:  param (";" param)*
param:       ("var"|"out")? name_list ":" type_name (":=" expr)? -> param
name_list:   CNAME ("," CNAME)*                                 -> names
?type_name:  array_type | generic_type | dotted_name
ARRAY_RANGE: "[" /[^\]]*/ "]"
array_type:  "array"i ARRAY_RANGE? "of"i type_name

generic_type: dotted_name LT type_name ("," type_name)* GT

property_sig: CNAME ":" type_name ("read" CNAME)? ("write" CNAME?)?
const_decl: CNAME (":" type_name)? OP_REL expr ";"

class_impl:  "class" method_kind method_impl
            | method_kind method_impl
method_impl: impl_head ";" var_section? block                     -> m_impl
impl_head:   method_name param_block? return_block?

block:       "begin" stmt* "end" ";"?

?stmt:       assign_stmt
           | return_stmt
           | if_stmt
           | for_stmt
           | while_stmt
           | try_stmt
           | inherited_stmt
           | call_stmt
           | block
           |                         -> empty

assign_stmt: var_ref ":=" expr ";"?                              -> assign
return_stmt: RESULT ":=" expr ";"?                             -> result_ret
            | EXIT expr? ";"?                                  -> exit_ret
if_stmt:     "if" expr "then" stmt ("else" stmt)?                 -> if_stmt
for_stmt:    "for"i CNAME ":=" expr "to"i expr ("do"i)? stmt          -> for_stmt
while_stmt:  "while"i expr "do"i stmt        -> while_stmt
try_stmt:    "try" stmt* ("except" stmt*)? ("finally" stmt*)? "end" ";"?

call_stmt:   var_ref ("(" arg_list? ")")? ("." name_term ("(" arg_list? ")")?)* ";"?     -> call_stmt

inherited_stmt: "inherited" ";"?                          -> inherited

?expr:       NOT expr                    -> not_expr
           | "-" expr                   -> neg
           | "+" expr                   -> pos
           | expr OP_SUM   expr          -> binop
           | expr OP_MUL   expr          -> binop
           | expr (OP_REL|LT|GT) expr    -> binop
           | expr IN set_lit             -> in_expr
           | "(" expr ")"
           | NUMBER                       -> number
           | STRING                       -> string
           | SQ_STRING                    -> string
           | TRUE                         -> true
           | FALSE                        -> false
           | NIL                          -> null
           | var_ref
           | call_expr
           | set_lit
           | "new" type_name "(" ")"   -> new_expr
           | "new" type_name             -> new_expr

set_lit: "[" (expr ("," expr)*)? "]"

?name_term:  generic_type | dotted_name

call_expr:   var_ref "(" arg_list? ")" ("." name_term ("(" arg_list? ")")?)*     -> call
arg_list:    expr ("," expr)*

var_ref:     name_term (ARRAY_RANGE | "." name_term)*   -> var

var_section: "var" var_decl+
var_decl:    name_list ":" type_name (":=" expr)? ";"        -> var_decl

LT:          "<"
GT:          ">"
OP_SUM:      "+" | "-" | "or"
OP_MUL:      "*" | "/" | "and"
OP_REL:      "=" | "<>" | "<=" | ">="

NOT:         "not"i

METHOD:      "method"i
PROCEDURE:   "procedure"i
FUNCTION:    "function"i
CONSTRUCTOR: "constructor"i
DESTRUCTOR:  "destructor"i
VAR:         "var"i
OUT:         "out"i
FOR:         "for"i
TO:          "to"i
IN:          "in"i
WHILE:       "while"i
DO:          "do"i
TRY:         "try"i
EXCEPT:      "except"i
FINALLY:     "finally"i
ON:          "on"i

TRUE:        "true"i
FALSE:       "false"i
NIL:         "nil"i
SQ_STRING:   /'(?:[^'\n]|'')*'/
RESULT:      "result"i
EXIT:        "exit"i

%import common.CNAME
%import common.NUMBER
%import common.ESCAPED_STRING -> STRING
%import common.WS
COMMENT_BRACE: /\{[^}]*\}/
LINE_COMMENT: /\/\/[^\n]*/
COMMENT_PAREN: /\(\*[^*]*\*\)/
%ignore WS
%ignore COMMENT_BRACE
%ignore LINE_COMMENT
%ignore COMMENT_PAREN
"""
