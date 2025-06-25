# ────────────────────────── Grammar ──────────────────────────
GRAMMAR = r"""
?start:   (namespace | unit_decl) interface_section? class_section+ ("implementation" uses_clause? class_impl*)? ("end"i ("." | ";"))?

interface_section: "interface" uses_clause? pre_class_decl*
uses_clause:   "uses" dotted_name ("," dotted_name)* ";"       -> uses

attribute: "[" dotted_name ("(" arg_list? ")")? "]"
attributes: attribute+

dotted_name: CNAME ("." CNAME)* -> dotted

namespace:   "namespace" dotted_name ";"                       -> namespace
unit_decl:   "unit" dotted_name ";"                             -> namespace
class_section: "type" type_def+                                -> class_section
type_def:     attributes? class_def
            | attributes? record_def
            | attributes? interface_def
            | attributes? enum_def
            | alias_def

class_def:   CNAME generic_params? "=" ("public"i)? "static"? "partial"? "abstract"? "class"i CNAME* ("(" type_name ("," type_name)* ")")? class_signature "end"i ";" -> class_def
record_def:  CNAME generic_params? "=" ("public"i)? "record"i ("(" type_name ")")? class_signature "end"i ";" -> record_def
interface_def: CNAME generic_params? "=" ("public"i)? "interface"i ("(" type_name ("," type_name)* ")")? class_signature "end"i ";" -> interface_def
enum_def:    CNAME "=" ("public"i)? ("enum"i | "flags"i)? "(" enum_items ")" ("of" type_name)? ";" -> enum_def
alias_def:   access_modifier? CNAME generic_params? "=" type_spec ";"     -> alias_def
enum_items:  enum_item ("," enum_item)* -> enum_items
enum_item:   CNAME ("=" NUMBER)?                               -> enum_item

class_signature: member_decl* -> class_sign
member_decl: attributes? method_decl_rule
           | attributes? access_modifier? class_modifier? VAR? name_list ":" type_spec (":=" expr)? ";"      -> field_decl
           | attributes? access_modifier? "class"? "property"i property_sig ";"      -> property_decl
           | attributes? access_modifier? "event"i CNAME ":" type_spec ";"  -> event_decl
           | attributes? access_modifier? "class"? "const"i const_decl+            -> const_block
           | access_modifier                                   -> section

method_decl_rule: access_modifier? class_modifier? method_kind method_sig ";" (method_attr ";"?)* -> method_decl

class_modifier: "class"
method_attr: "override" | "static" | "abstract" | "virtual" | "reintroduce"i | "overload"i
method_kind: METHOD | PROCEDURE | FUNCTION | CONSTRUCTOR | DESTRUCTOR | OPERATOR
access_modifier: "public"i | "protected"i | "private"i

method_sig:    method_name param_block? return_block?            -> m_sig
             | param_block? return_block?                        -> m_sig_no_name
method_name: CNAME ("." CNAME)+ GENERIC_ARGS?        -> dotted_method
           | CNAME GENERIC_ARGS?                       -> simple_method
param_block: "(" param_list? ")"                     -> params
return_block: ":" type_spec                           -> rettype
param_list:  param (";" param)*
param:       (VAR|OUT|CONST)? name_list ":" type_spec (":=" expr)? -> param
name_list:   CNAME ("," CNAME)* -> names

type_spec: type_name "?"?                              -> type_spec

?type_name:  pointer_type
           | set_type
           | range_type
           | tuple_type
           | array_type
           | generic_type
           | dotted_name
ARRAY_RANGE: /\[(?:[^\[\]]|\[[^\]]*\])*\]/
array_type:  "array"i ARRAY_RANGE? "of"i type_name

pointer_type: CARET type_name
set_type: "set"i "of"i type_name
range_type: NUMBER DOTDOT NUMBER

tuple_type: "tuple"i "of" "(" type_name ("," type_name)* ")"

generic_type: dotted_name GENERIC_ARGS
generic_params: "<" CNAME ("," CNAME)* ">"

property_sig: CNAME property_index? ":" type_spec (READ CNAME)? (WRITE CNAME?)? -> property_sig
property_index: "[" param_list? "]"
const_decl: CNAME (":" type_spec)? OP_REL expr ";"
const_block: "const" const_decl+

pre_class_decl: const_block
              | var_section
              | method_decl_rule

class_impl:  class_modifier? method_kind method_impl
method_impl: impl_head ";" method_decls? block               -> m_impl
method_decls: (var_section | const_block)+
impl_head:   method_name param_block? return_block?

block:       "begin" ";"? stmt* "end"i ";"?

?stmt:       assign_stmt
           | op_assign_stmt
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
           | var_stmt
           | loop_stmt
           | using_stmt
           | locking_stmt
           | with_stmt
           | yield_stmt
           | call_stmt
           | new_stmt
           | block
           

assign_stmt: var_ref ":=" expr ";"?                     -> assign
op_assign_stmt: var_ref ADD_ASSIGN expr ";"?              -> op_assign
              | var_ref SUB_ASSIGN expr ";"?              -> op_assign
return_stmt: RESULT ":=" expr ";"?                      -> result_ret
           | EXIT expr? ";"?                            -> exit_ret
raise_stmt: RAISE expr? ";"?                           -> raise_stmt
repeat_stmt: "repeat"i stmt* "until"i expr ";"?         -> repeat_stmt
break_stmt: BREAK ";"?                                  -> break_stmt
continue_stmt: CONTINUE ";"?                            -> continue_stmt
var_stmt:    "var"i (var_decl | var_decl_infer)          -> var_stmt
using_stmt: USING CNAME (":" type_spec)? ":=" expr DO stmt       -> using_var
          | USING expr DO stmt                        -> using_expr
          | USING AUTORELEASEPOOL DO stmt             -> using_pool
locking_stmt: LOCKING expr DO stmt                      -> locking_stmt
with_stmt: WITH expr DO stmt                           -> with_stmt
yield_stmt: YIELD expr ";"?                           -> yield_stmt
if_stmt:     "if" expr "then" stmt? ("else" stmt)?        -> if_stmt
for_stmt:    "for"i CNAME (":" type_spec)? ":=" expr (TO | DOWNTO) expr (STEP expr)? ("do"i)? stmt  -> for_stmt
           | "for"i "each"i? CNAME (":" type_spec)? IN expr (INDEX CNAME)? ("do"i)? stmt      -> for_each_stmt
loop_stmt:   LOOP stmt                                       -> loop_stmt
while_stmt:  "while"i expr "do"i stmt                    -> while_stmt

try_stmt:    TRY stmt* except_clause? finally_clause? "end"i ";"? -> try_stmt
except_clause: "except" (on_handler | stmt)*
finally_clause: "finally" stmt+
on_handler: ON CNAME ":" type_name DO stmt -> on_handler

case_stmt:   "case" expr "of" case_branch+ ("else" stmt+)? "end"i ";"? -> case_stmt
case_branch: case_label ("," case_label)* ":" stmt ";"?
case_label: NUMBER DOTDOT NUMBER        -> label_range
          | NUMBER
          | SQ_STRING
          | STRING
          | dotted_name
          | NIL

call_stmt:   var_ref ("(" arg_list? ")")? call_postfix* ";"?   -> call_stmt
           | generic_call_base ("(" arg_list? ")")? call_postfix* ";"? -> call_stmt
           | new_expr "." name_term ("(" arg_list? ")")? call_postfix* ";"?    -> call_stmt
           | "(" expr ")" "." name_term ("(" arg_list? ")")? call_postfix* ";"? -> call_stmt
inherited_stmt: "inherited"i (name_term ("(" arg_list? ")" call_postfix*)?)? ";"? -> inherited

?expr:       lambda_expr
           | NOT expr                                -> not_expr
           | "-" expr                                -> neg
           | "+" expr                                -> pos
           | AT var_ref                              -> addr_of
           | expr OP_SUM   expr                      -> binop
           | expr OP_MUL   expr                      -> binop
           | expr OP_SUM ELSE expr                   -> short_or
           | expr OP_MUL THEN expr                   -> short_and
           | expr (OP_REL|LT|GT) expr                -> binop
           | expr IN set_lit                         -> in_expr
           | expr NOT IN set_lit                     -> not_in_expr
           | expr IS NOT type_spec                   -> is_not_inst
           | expr IS type_spec                       -> is_inst
           | expr AS type_spec                       -> as_cast
           | "(" expr ")"
           | NUMBER                                  -> number
           | HEX_NUMBER                              -> hex_number
           | BINARY_NUMBER                           -> binary_number
           | STRING                                  -> string
           | SQ_STRING                               -> string
           | TRUE                                    -> true
           | FALSE                                   -> false
           | NIL                                     -> null
           | typeof_expr
           | var_ref
           | call_expr
           | set_lit
           | array_of_expr
           | new_expr
           | anon_proc_expr
           | CHAR_CODE                               -> char_code
           | expr CARET                              -> deref

lambda_expr: lambda_sig ("=>" ( block | expr ) | "->" ( block | expr )) -> lambda_expr
lambda_sig: "(" param_list? ")"

anon_proc_expr: (PROCEDURE | FUNCTION) param_block? return_block? ";"? block -> anon_proc

set_lit: "[" (expr ("," expr)*)? "]"

new_expr: "new" type_spec "(" arg_list? ")"         -> new_obj
        | "new" type_spec ARRAY_RANGE               -> new_array
        | "new" type_spec                           -> new_obj_noargs

array_of_expr: "array"i "of"i type_name "(" arg_list? ")" -> array_of_expr
typeof_expr: TYPEOF "(" expr ")"                        -> typeof_expr

generic_call_base: dotted_name GENERIC_ARGS

?name_base:  dotted_name
?name_term:  dotted_name

?call_postfix: prop_call | index_postfix
call_args: "(" arg_list? ")"                         -> call_args
prop_call: "." name_term GENERIC_ARGS? call_args?     -> prop_call
index_postfix: ARRAY_RANGE                           -> index_postfix

call_expr:   var_ref "(" arg_list? ")" call_postfix* -> call
           | generic_call_base ("(" arg_list? ")")? call_postfix* -> call
           | new_expr "." name_term GENERIC_ARGS? call_args? call_postfix* -> call
           | "(" expr ")" "." name_term GENERIC_ARGS? call_args? call_postfix* -> call
           | "inherited"i name_term GENERIC_ARGS? call_args? call_postfix* -> inherited_call_expr
           | typeof_expr call_postfix+                     -> call
arg_list:    arg ("," arg)*
arg:         OUT expr                                -> out_arg
           | VAR expr                                -> var_arg
           | CONST expr                              -> const_arg
           | CNAME ":=" expr                         -> named_arg
           | expr

new_stmt:    new_expr ";"?
var_ref:     name_base (ARRAY_RANGE | "." name_term)* -> var
           | "(" expr ")" ARRAY_RANGE -> paren_index

var_section: "var"i (var_decl | var_decl_infer)+
var_decl:    name_list ":" type_spec (":=" expr)? ";"       -> var_decl
var_decl_infer: name_list ":=" expr ";"                 -> var_decl_infer

LT:           "<"
GT:           ">"
GENERIC_ARGS: /<(?![=>])(?:(?:[^<>'()\n]|<[^<>'()\n]*>)+)>/
OP_SUM.2:       "+" | "-" | "or" | "xor"i
OP_MUL.2:       "*" | "/" | "and" | "mod"i | "div"i | "shl"i | "shr"i
OP_REL:       "=" | "<>" | "<=" | ">="
ADD_ASSIGN.2:  "+="
SUB_ASSIGN.2:  "-="

NOT:         "not"i
METHOD:      "method"i
PROCEDURE:   "procedure"i
FUNCTION:    "function"i
CONSTRUCTOR: "constructor"i
DESTRUCTOR:  "destructor"i
VAR:         "var"i
OUT:         "out"i
CONST:       "const"i
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
THEN:        "then"i
ELSE:        "else"i

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
READ:        "read"i
WRITE:       "write"i
USING:       "using"i
LOCKING:     "locking"i
YIELD:       "yield"i
INDEX:       "index"i
IS:          "is"i
AS:          "as"i
AUTORELEASEPOOL: "autoreleasepool"i
RECORD:      "record"i
INTERFACE:   "interface"i
ENUM:        "enum"i
FLAGS:       "flags"i
EVENT:       "event"i
OPERATOR:    "operator"i
TUPLE:       "tuple"i
TYPEOF:      "typeof"i
AT:          "@"
CARET:       "^"
DOTDOT:      ".."

CHAR_CODE:   "#" NUMBER ("#" NUMBER)*

HEX_NUMBER: /\$[0-9A-Fa-f]+/
BINARY_NUMBER: /%[01]+/

%import common.CNAME -> BASE_CNAME
%import common.WS

NUMBER: /[0-9]+([_,][0-9]+)*(\.[0-9]+([_,][0-9]+)*)?/
STRING: /"[^"\n]*"/

CNAME: /&?[A-Za-z_][A-Za-z_0-9]*\??/
COMMENT_BRACE: /\{(?s:.*?)\}/
LINE_COMMENT: /\/\/[^\n]*/
COMMENT_PAREN: /\(\*[\s\S]*?\*\)/
%ignore WS
%ignore COMMENT_BRACE
%ignore LINE_COMMENT
%ignore COMMENT_PAREN
"""
# Avoid treating comparison operators like "<=" as generic arguments in GENERIC_ARGS
