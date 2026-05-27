%{
#include "parser.tab.h"
#include <stdio.h>
#include <string.h>

char last_token[256];  // add this
%}
%option yylineno
%%
(?i:SELECT)    { strncpy(last_token, yytext, 255); return SELECT; }
(?i:INSERT)    { strncpy(last_token, yytext, 255); return INSERT; }
(?i:UPDATE)    { strncpy(last_token, yytext, 255); return UPDATE; }
(?i:DELETE)    { strncpy(last_token, yytext, 255); return DELETE; }
(?i:CREATE)    { strncpy(last_token, yytext, 255); return CREATE; }
(?i:DROP)      { strncpy(last_token, yytext, 255); return DROP; }
(?i:ALTER)     { strncpy(last_token, yytext, 255); return ALTER; }
(?i:TABLE)     { strncpy(last_token, yytext, 255); return TABLE; }
(?i:DATABASE)  { strncpy(last_token, yytext, 255); return DATABASE; }
(?i:INDEX)     { strncpy(last_token, yytext, 255); return INDEX; }
(?i:INTO)      { strncpy(last_token, yytext, 255); return INTO; }
(?i:FROM)      { strncpy(last_token, yytext, 255); return FROM; }
(?i:WHERE)     { strncpy(last_token, yytext, 255); return WHERE; }
(?i:VALUES)    { strncpy(last_token, yytext, 255); return VALUES; }
(?i:SET)       { strncpy(last_token, yytext, 255); return SET; }
(?i:ADD)       { strncpy(last_token, yytext, 255); return ADD; }
[a-zA-Z_][a-zA-Z0-9_]* { strncpy(last_token, yytext, 255); return IDENTIFIER; }
[0-9]+                  { strncpy(last_token, yytext, 255); return NUMBER; }
"*"   { strncpy(last_token, yytext, 255); return STAR; }
";"   { strncpy(last_token, yytext, 255); return SEMICOLON; }
","   { strncpy(last_token, yytext, 255); return COMMA; }
"("   { strncpy(last_token, yytext, 255); return LPAREN; }
")"   { strncpy(last_token, yytext, 255); return RPAREN; }
"="   { strncpy(last_token, yytext, 255); return EQUALS; }
[ \t\r\n]+  { /* ignore whitespace */ }
.     { strncpy(last_token, yytext, 255); return yytext[0]; }
%%
int yywrap() { return 1; }
