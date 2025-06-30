# ────────────────────────── Grammar ──────────────────────────
GRAMMAR = r"""
?start:   assembly_attr* (namespace | unit_decl | program_decl | library_decl) uses_clause? (interface_section | pre_class_decl*)? class_section* ("implementation" uses_clause? class_impl*)? (main_block "." | initialization_section? ("end"i ("." | ";"))?)
main_block: "begin" stmt* "end"i
interface_section: "interface" uses_clause? assembly_attr* pre_class_decl*
uses_clause:   "uses" dotted_name ("," dotted_name)* ";"       -> uses

assembly_attr: "[" CNAME ":" dotted_name ("(" arg_list? ")")? "]" ";"?

attribute: "[" dotted_name ("(" arg_list? ")")? "]"
attributes: attribute+

name_part: CNAME
         | ARRAY
         | RECORD
         | INTERFACE
         | ENUM
         | EVENT
         | OPERATOR
         | TUPLE
         | RESULT

dotted_name: name_part ("." name_part)* -> dotted
namespace:   "namespace" dotted_name ";"                       -> namespace
unit_decl:   "unit" dotted_name ";"                             -> namespace
program_decl: "program"i dotted_name ";"              -> namespace
library_decl: "library" dotted_name ";"                          -> namespace
initialization_section: "initialization" stmt* finalization_section?
finalization_section: "finalization" stmt*

class_section: "type" type_def+                                -> class_section
type_def:     attributes? class_def
            | attributes? record_def
            | attributes? interface_def
            | attributes? enum_def
            | alias_def

class_def:   CNAME generic_params? "=" ("public"i)? "static"? "partial"? ("sealed"i | "final"i)? "abstract"? "class"i ("sealed"i | "final"i)? CNAME* ("(" type_name ("," type_name)* ")")? class_signature "end"i ";" -> class_def
record_def:  CNAME generic_params? "=" ("public"i)? "packed"i? "record"i ("(" type_name ")")? class_signature "end"i ";" -> record_def
interface_def: CNAME generic_params? "=" ("public"i)? "interface"i ("(" type_name ("," type_name)* ")")? class_signature "end"i ";" -> interface_def
enum_def:    CNAME "=" ("public"i)? ("enum"i | "flags"i)? "(" enum_items ")" ("of" type_name)? ";" -> enum_def
alias_def:   access_modifier? CNAME generic_params? "=" type_spec ";"     -> alias_def
enum_items:  enum_item ("," enum_item)* -> enum_items
enum_item:   CNAME ("=" NUMBER)?                               -> enum_item

class_signature: member_decl* -> class_sign
member_decl: attributes? method_decl_rule
           | attributes? access_modifier? (CLASSVAR | VAR) attributes? name_list ":" type_spec (":=" expr)? ";"      -> field_decl
           | access_modifier? name_list ":" type_spec (":=" expr)? ";"      -> field_decl

           | attributes? access_modifier? "class"? "property"i property_sig ";"      -> property_decl
           | attributes? access_modifier? "event"i CNAME ":" type_spec event_end  -> event_decl
           | attributes? access_modifier? "class"? "const"i const_decl+            -> const_block
           | access_modifier                                   -> section

method_decl_rule: access_modifier? class_modifier? method_kind method_sig ";" (method_attr ";"?)* -> method_decl

class_modifier: "class"
method_attr: "override" | "static" | "abstract" | "virtual" | "reintroduce"i | "overload"i
           | "inline"i | "cdecl"i | "stdcall"i | "safecall"i | "varargs"i
           | "external"i | "forward"i | "platform"i | "deprecated"i | "message"i
           | "implements" dotted_name
method_kind: METHOD | PROCEDURE | FUNCTION | CONSTRUCTOR | DESTRUCTOR | OPERATOR
access_modifier: "strict"i? ("public"i
  | "protected"i
  | "private"i
  | "published"i
  | ASSEMBLY
  | ASSEMBLY ANDKW "protected"i
  | "protected"i ANDKW ASSEMBLY)

method_sig:    method_name param_block? return_block?            -> m_sig
             | param_block? return_block?                        -> m_sig_no_name
method_name: CNAME ("." CNAME)+ GENERIC_ARGS?        -> dotted_method
           | CNAME GENERIC_ARGS?                       -> simple_method
param_block: "(" param_list? ")"                     -> params
return_block: ":" type_spec                           -> rettype
param_list:  param (";" param)*
param:       (VAR|OUT|CONST)? name_list ":" type_spec ((OP_REL["="] | ":=") expr)? -> param
            | (VAR|OUT|CONST) name_list ((OP_REL["="] | ":=") expr)? -> param_untyped
name_list:   CNAME ("," CNAME)* -> names

type_spec: type_name "?"?                              -> type_spec

?type_name:  pointer_type
           | set_type
           | range_type
           | tuple_type
           | array_type
           | generic_type
           | nullable_type
           | dotted_name
ARRAY_RANGE: /\[(?![^\]]*:=)(?:[^\[\]]|\[[^\]]*\])*\]/
array_type:  "array"i ARRAY_RANGE? "of"i type_name

pointer_type: CARET type_name
set_type: "set"i "of"i type_name

range_type: NUMBER DOTDOT NUMBER

tuple_type: "tuple"i "of" "(" type_name ("," type_name)* ")"

generic_type: dotted_name GENERIC_ARGS
nullable_type: NULLABLE type_name
generic_params: "<" CNAME ("," CNAME)* ">"

property_sig: CNAME property_index? ":" type_spec (READ CNAME)? (WRITE CNAME?)? -> property_sig
event_opt: access_modifier? RAISE -> event_raise
         | method_attr -> event_attr
event_end: ";" -> event_simple
         | event_opt (";" event_opt)* ";" -> event_full
property_index: "[" param_list? "]"
const_decl: CNAME (":" type_spec)? OP_REL expr ";"
const_block: "const" const_decl+

pre_class_decl: const_block
              | var_section
              | method_decl_rule

class_impl:  attributes? class_modifier? method_kind method_impl
method_impl: attributes? impl_head ";" method_decls? block               -> m_impl
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
           

assign_stmt: (var_ref | call_lhs) ":=" expr ";"?                     -> assign
op_assign_stmt: (var_ref | call_lhs) ADD_ASSIGN expr ";"?              -> op_assign
              | (var_ref | call_lhs) SUB_ASSIGN expr ";"?              -> op_assign
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
empty_stmt: ";"                                      -> empty
if_stmt:     "if"i expr THEN (stmt | empty_stmt)? (ELSE stmt)?        -> if_stmt
for_stmt:    "for"i CNAME (":" type_spec)? ":=" expr (TO | DOWNTO) expr (STEP expr)? ("do"i)? stmt  -> for_stmt
           | "for"i "each"i? CNAME (":" type_spec)? IN expr (INDEX CNAME)? ("do"i)? stmt      -> for_each_stmt
loop_stmt:   LOOP stmt                                       -> loop_stmt
while_stmt:  "while"i expr "do"i stmt                    -> while_stmt

try_stmt:    TRY stmt* except_clause? finally_clause? "end"i ";"? -> try_stmt
except_clause: EXCEPT ";"? (on_handler | stmt)*                       -> except_clause
finally_clause: FINALLY stmt+
on_handler: ON CNAME ":" type_name DO stmt -> on_handler
          | ON CNAME ":" type_name DO ";" -> on_handler_empty

case_stmt:   "case" expr "of" case_branch+ case_else? "end"i ";"? -> case_stmt
case_else:   ELSE stmt+                           -> case_else
           | ELSE ";"?                          -> case_else_empty
case_branch: case_label ("," case_label)* ":" stmt ";"?
signed_number: OP_SUM? NUMBER          -> signed_number
case_label: signed_number DOTDOT signed_number        -> label_range
          | signed_number
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
           | expr SHL expr                          -> binop
           | expr SHR expr                          -> binop
           | expr OP_SUM ELSE expr                   -> short_or
           | expr OP_MUL THEN expr                   -> short_and
           | "if"i expr THEN expr ELSE expr       -> if_expr
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
           | "if"i expr THEN expr ELSE expr         -> if_expr
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
literal_string: STRING -> string
              | SQ_STRING -> string

call_expr:   var_ref "(" arg_list? ")" call_postfix* -> call
           | generic_call_base ("(" arg_list? ")")? call_postfix* -> call
           | new_expr "." name_term GENERIC_ARGS? call_args? call_postfix* -> call
           | array_of_expr prop_call call_postfix* -> call
           | "(" expr ")" "." name_term GENERIC_ARGS? call_args? call_postfix* -> call
           | literal_string "." name_term GENERIC_ARGS? call_args? call_postfix* -> call
           | "inherited"i name_term GENERIC_ARGS? call_args? call_postfix* -> inherited_call_expr
           | typeof_expr call_postfix+                     -> call

call_lhs:   var_ref "(" arg_list? ")" call_postfix+                 -> call
           | generic_call_base ("(" arg_list? ")")? call_postfix+    -> call
           | new_expr "." name_term GENERIC_ARGS? call_args? call_postfix+ -> call
           | array_of_expr prop_call call_postfix+ -> call
           | "(" expr ")" "." name_term GENERIC_ARGS? call_args? call_postfix+ -> call
           | literal_string "." name_term GENERIC_ARGS? call_args? call_postfix+ -> call
           | typeof_expr call_postfix+                                 -> call
arg_list:    arg ("," arg)*
arg:         OUT expr                                -> out_arg
           | VAR expr                                -> var_arg
           | CONST expr                              -> const_arg
           | CNAME ":=" expr                         -> named_arg
           | expr

new_stmt:    new_expr ";"?
var_ref:     name_base (ARRAY_RANGE | "." name_term)* -> var
           | "(" expr ")" ARRAY_RANGE -> paren_index

var_section: ("var"i | "threadvar"i) (var_decl | var_decl_infer)+
var_decl:    name_list ":" type_spec (":=" expr)? ";"       -> var_decl
var_decl_infer: name_list ":=" expr ";"                 -> var_decl_infer

LT:           "<"
GT:           ">"
GENERIC_ARGS: /<[A-Za-z_][^<>]*(?:<[^<>]*>[^<>]*)*>/
ASSEMBLY.3:  "assembly"i
ANDKW.3:     "and"i
OP_SUM:       "+" | "-" | "or" | "xor"i
OP_MUL:       "*" | "/" | "and" | "mod"i | "div"i
OP_REL:       "=" | "<>" | "<=" | ">="
SHL:          "shl"i
SHR:          "shr"i
ADD_ASSIGN.2:  "+="
SUB_ASSIGN.2:  "-="

NOT:         "not"i
METHOD:      "method"i
PROCEDURE:   "procedure"i
FUNCTION:    "function"i
CONSTRUCTOR: "constructor"i
DESTRUCTOR:  "destructor"i
VAR:         "var"i
CLASSVAR.2:  /class\s+var/i
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
PROGRAM:     "program"i
INITIALIZATION: "initialization"i
FINALIZATION: "finalization"i
AUTORELEASEPOOL: "autoreleasepool"i
RECORD:      "record"i
INTERFACE:   "interface"i
ENUM:        "enum"i
FLAGS:       "flags"i
EVENT:       "event"i
OPERATOR:    "operator"i
PACKED:      "packed"i
TUPLE:       "tuple"i
ARRAY:       "array"i
TYPEOF:      "typeof"i
SEALED:      "sealed"i
FINAL:       "final"i
INLINE:      "inline"i
NULLABLE:    "nullable"i
CDECL:       "cdecl"i
STDCALL:     "stdcall"i
SAFECALL:    "safecall"i
VARARGS:     "varargs"i
EXTERNAL:    "external"i
FORWARD:     "forward"i
THREADVAR:   "threadvar"i
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
COMMENT_STAR: /\/\*[\s\S]*?\*\//
%ignore WS
%ignore COMMENT_BRACE
%ignore LINE_COMMENT
%ignore COMMENT_PAREN
%ignore COMMENT_STAR
"""