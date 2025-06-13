%namespace Pas2CsCS
%visibility public
%option noparser
%option unicode
%option out:PascalScanner.cs
%{
public enum Tokens
{
    EOF = 0,
    NAMESPACE, INTERFACE, IMPLEMENTATION, TYPE, CLASS, PUBLIC,
    STATIC, PARTIAL, END, BEGIN, PROCEDURE, FUNCTION, METHOD,
    IF, THEN, ELSE, FOR, TO, DO, RESULT, EXIT,
    TRUE, FALSE, NIL,
    NE, LE, GE, AND, OR, NOT,
    SQ_STRING, STRING, NUMBER, ID, UNKNOWN,
    maxParseToken = 255
}
%}
%%
\{[^}]*\}                       /* skip Pascal comments */
\/\/[^\n]*                        /* skip line comments */
\(\*[^*]*\*\)                    /* skip block comments */
[ \t\r\n]+                        /* skip whitespace */

"namespace"                      return (int)Tokens.NAMESPACE;
"interface"                      return (int)Tokens.INTERFACE;
"implementation"                 return (int)Tokens.IMPLEMENTATION;
"type"                            return (int)Tokens.TYPE;
"class"                           return (int)Tokens.CLASS;
"public"                          return (int)Tokens.PUBLIC;
"static"                          return (int)Tokens.STATIC;
"partial"                         return (int)Tokens.PARTIAL;
"end"                             return (int)Tokens.END;
"begin"                           return (int)Tokens.BEGIN;
"procedure"                       return (int)Tokens.PROCEDURE;
"function"                        return (int)Tokens.FUNCTION;
"method"                          return (int)Tokens.METHOD;
"if"                              return (int)Tokens.IF;
"then"                            return (int)Tokens.THEN;
"else"                            return (int)Tokens.ELSE;
"for"                             return (int)Tokens.FOR;
"to"                              return (int)Tokens.TO;
"do"                              return (int)Tokens.DO;
"result"                          return (int)Tokens.RESULT;
"exit"                            return (int)Tokens.EXIT;
"true"                            return (int)Tokens.TRUE;
"false"                           return (int)Tokens.FALSE;
"nil"                             return (int)Tokens.NIL;
"("                               return '(';
")"                               return ')';
";"                               return ';';
":"                               return ':';
","                               return ',';
"."                               return '.';
"="                               return '=';
"<>"                              return (int)Tokens.NE;
"<="                              return (int)Tokens.LE;
">="                              return (int)Tokens.GE;
"<"                               return '<';
">"                               return '>';
"+"                               return '+';
"-"                               return '-';
"*"                               return '*';
"/"                               return '/';
"and"                             return (int)Tokens.AND;
"or"                              return (int)Tokens.OR;
"not"                             return (int)Tokens.NOT;
"["                               return '[';
"]"                               return ']';
\'([^'\n]|'')*\'                return (int)Tokens.SQ_STRING;
\"([^\"\n]|\\\")*\"          return (int)Tokens.STRING;
[0-9]+                          return (int)Tokens.NUMBER;
[A-Za-z_][A-Za-z0-9_]*          { return (int)Tokens.ID; }
.                               { return (int)Tokens.UNKNOWN; }
%%
