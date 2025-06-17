# ────────────────────────── Grammar ──────────────────────────
GRAMMAR = r"""
?start:      namespace interface_section? class_section ("implementation" class_impl*)? ("end" ".")?

interface_section: "interface" uses_clause? pre_class_decl*
uses_clause:   "uses" dotted_name ("," dotted_name)* ";"         -> uses

attribute: "[" dotted_name ("(" arg_list? ")")? "]"
attributes: attribute+

namespace:   "namespace" dotted_name ";"                          -> namespace
dotted_name: CNAME ("." CNAME)*                                    -> dotted
class_section: "type" type_def+                                   -> class_section
type_def:    attributes? class_def
           | attributes? record_def
           | attributes? interface_def
           | attributes? enum_def

class_def:   CNAME "=" "public"i "static"? "partial"? "abstract"? "class"i ("(" type_name ")")? class_signature "end"i ";" -> class_def
record_def:  CNAME "=" "public"i "record"i ("(" type_name ")")? class_signature "end"i ";" -> record_def
interface_def: CNAME "=" "public"i "interface"i ("(" type_name ("," type_name)* ")")? class_signature "end"i ";" -> interface_def
enum_def:    CNAME "=" "public"i ("enum"i | "flags"i) "(" enum_items ")" ("of" type_name)? ";" -> enum_def
enum_items:  enum_item ("," enum_item)*                       -> enum_items
enum_item:   CNAME ("=" NUMBER)?                              -> enum_item

class_signature: member_decl*                                     -> class_sign
member_decl: attributes? method_decl_rule
           | attributes? access_modifier? "class"? "var"i? name_list ":" type_name ";"         -> field_decl
           | attributes? access_modifier? "class"? "property"i property_sig ";"          -> property_decl
           | attributes? access_modifier? "event"i CNAME ":" type_name ";"   -> event_decl
           | attributes? access_modifier? "class"? "const"i const_decl+                  -> const_block
           | access_modifier                                      -> section

method_decl_rule: access_modifier? class_modifier? method_kind method_sig ";" method_attr* ";"? -> method_decl

class_modifier: "class"
method_attr: "override" | "static" | "abstract" | "virtual"
method_kind: METHOD | PROCEDURE | FUNCTION | CONSTRUCTOR | DESTRUCTOR | OPERATOR
access_modifier: "public"i | "protected"i | "private"i

method_sig:   method_name param_block? return_block?              -> m_sig
             | param_block? return_block?                        -> m_sig_no_name
method_name: CNAME ("." CNAME)+           -> dotted_method
           | CNAME                         -> simple_method
param_block: "(" param_list? ")"           -> params
return_block: ":" type_name                -> rettype
param_list:  param (";" param)*
param:       ("var"|"out")? name_list ":" type_name (":=" expr)? -> param
name_list:   CNAME ("," CNAME)*                                 -> names
?type_name:  pointer_type
           | set_type
           | range_type
           | tuple_type
           | array_type
           | generic_type
           | dotted_name
ARRAY_RANGE: "[" /[^\]]*/ "]"
array_type:  "array"i ARRAY_RANGE? "of"i type_name

pointer_type: CARET type_name
set_type: "set"i "of"i type_name
range_type: NUMBER DOTDOT NUMBER

tuple_type: "tuple"i "of" "(" type_name ("," type_name)* ")"

generic_type: dotted_name GENERIC_ARGS

property_sig: CNAME property_index? ":" type_name ("read" CNAME)? ("write" CNAME?)?
property_index: "[" param_list? "]"
const_decl: CNAME (":" type_name)? OP_REL expr ";"
const_block: "const" const_decl+

pre_class_decl: const_block
              | var_section
              | method_decl_rule

class_impl:  class_modifier? method_kind method_impl
method_impl: impl_head ";" var_section? block                     -> m_impl
impl_head:   method_name param_block? return_block?

block:       "begin" stmt* "end" ";"?

?stmt:       assign_stmt
           | return_stmt
           | if_stmt
           | for_stmt
           | while_stmt
           | try_stmt
           | case_stmt
           | inherited_stmt
           | raise_stmt
           | repeat_stmt
           | break_stmt
           | continue_stmt
           | loop_stmt
           | using_stmt
           | locking_stmt
           | with_stmt
           | yield_stmt
           | call_stmt
           | except_on_stmt
            | block
            |                         -> empty

assign_stmt: var_ref ":=" expr ";"?                              -> assign
return_stmt: RESULT ":=" expr ";"?                             -> result_ret
            | EXIT expr? ";"?                                  -> exit_ret
raise_stmt: RAISE expr? ";"?                                 -> raise_stmt
repeat_stmt: "repeat"i stmt* "until"i expr ";"?               -> repeat_stmt
break_stmt: BREAK ";"?                                     -> break_stmt
continue_stmt: CONTINUE ";"?                                -> continue_stmt
using_stmt: USING CNAME ":=" expr DO stmt                  -> using_var
           | USING expr DO stmt                           -> using_expr
           | USING AUTORELEASEPOOL DO stmt                -> using_pool
locking_stmt: LOCKING expr DO stmt                        -> locking_stmt
with_stmt: WITH expr DO stmt                              -> with_stmt
yield_stmt: YIELD expr ";"?                               -> yield_stmt
if_stmt:     "if" expr "then" stmt ("else" stmt)?                 -> if_stmt
for_stmt:    "for"i CNAME ":=" expr (TO | DOWNTO) expr (STEP expr)? ("do"i)? stmt  -> for_stmt
           | "for"i "each"i? CNAME IN expr ("do"i)? stmt        -> for_each_stmt
loop_stmt:   LOOP stmt                                                -> loop_stmt
while_stmt:  "while"i expr "do"i stmt        -> while_stmt
try_stmt:    "try" stmt* ("except" stmt*)? ("finally" stmt*)? "end" ";"?

case_stmt:   "case" expr "of" case_branch+ "end" ";"?
case_branch: case_label ("," case_label)* ":" stmt
case_label: NUMBER | SQ_STRING | STRING | CNAME

call_stmt:   var_ref ("(" arg_list? ")")? call_postfix* ";"?     -> call_stmt
           | generic_call_base ("(" arg_list? ")")? call_postfix* ";"? -> call_stmt
           | new_expr "." name_term ("(" arg_list? ")")? call_postfix* ";"?     -> call_stmt

inherited_stmt: "inherited" ";"?                          -> inherited

?expr:       NOT expr                    -> not_expr
           | "-" expr                   -> neg
           | "+" expr                   -> pos
           | AT var_ref                 -> addr_of
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
           | new_expr
           | expr CARET                  -> deref

set_lit: "[" (expr ("," expr)*)? "]"

new_expr: "new" type_name ("(" arg_list? ")")?

generic_call_base: dotted_name GENERIC_ARGS

?name_base:  dotted_name
?name_term:  dotted_name

?call_postfix: prop_call | index_postfix
call_args: "(" arg_list? ")"          -> call_args
prop_call: "." name_term call_args?    -> prop_call
index_postfix: ARRAY_RANGE                       -> index_postfix

except_on_stmt: ON CNAME ":" type_name DO stmt

call_expr:   var_ref "(" arg_list? ")" call_postfix*     -> call
           | generic_call_base ("(" arg_list? ")")? call_postfix*     -> call
           | new_expr "." name_term ("(" arg_list? ")")? call_postfix*     -> call
arg_list:    expr ("," expr)*

var_ref:     name_base (ARRAY_RANGE | "." name_term)*   -> var

var_section: "var"i var_decl+
var_decl:    name_list ":" type_name (":=" expr)? ";"        -> var_decl

LT:          "<"
GT:          ">"
GENERIC_ARGS: /<\s*[A-Za-z0-9][^>]*>/
OP_SUM:      "+" | "-" | "or"
OP_MUL:      "*" | "/" | "and" | "mod"i
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
DOWNTO:      "downto"i
IN:          "in"i
WHILE:       "while"i
DO:          "do"i
TRY:         "try"i
EXCEPT:      "except"i
FINALLY:     "finally"i
ON:          "on"i
CASE:        "case"i
OF:          "of"i

TRUE:        "true"i
FALSE:       "false"i
NIL:         "nil"i
SQ_STRING:   /'(?:[^'\n]|'')*'/
RESULT:      "result"i
EXIT:        "exit"i
RAISE:       "raise"i
BREAK:       "break"i
CONTINUE:    "continue"i
EACH:        "each"i
STEP:        "step"i
LOOP:        "loop"i
WITH:        "with"i
USING:       "using"i
LOCKING:     "locking"i
YIELD:       "yield"i
AUTORELEASEPOOL: "autoreleasepool"i
RECORD:      "record"i
INTERFACE:   "interface"i
ENUM:        "enum"i
FLAGS:       "flags"i
EVENT:       "event"i
OPERATOR:    "operator"i
TUPLE:       "tuple"i
AT:          "@"
CARET:       "^"
DOTDOT:      ".."

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
