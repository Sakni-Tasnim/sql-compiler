%{
#include <stdio.h>
#include <stdlib.h>
extern int yylineno;
extern char last_token[256];
extern int yylex();
void yyerror(const char *s);
%}

%define parse.error detailed

%token SELECT INSERT UPDATE DELETE CREATE DROP ALTER TABLE DATABASE INDEX
%token INTO FROM WHERE VALUES ADD SET IDENTIFIER NUMBER STAR SEMICOLON
%token COMMA LPAREN RPAREN EQUALS

%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    select_stmt SEMICOLON { printf("Line %d: Valid SELECT\n", yylineno); }
    | insert_stmt SEMICOLON { printf("Line %d: Valid INSERT\n", yylineno); }
    | create_stmt SEMICOLON { printf("Line %d: Valid CREATE\n", yylineno); }
    | drop_stmt SEMICOLON { printf("Line %d: Valid DROP\n", yylineno); }
    | alter_stmt SEMICOLON { printf("Line %d: Valid ALTER\n", yylineno); }
    | update_stmt SEMICOLON { printf("Line %d: Valid UPDATE\n", yylineno); }
    | delete_stmt SEMICOLON { printf("Line %d: Valid DELETE\n", yylineno); }
    | error SEMICOLON { yyerrok; }
    ;

/* DDL */
create_stmt:
    CREATE TABLE IDENTIFIER LPAREN column_list RPAREN
    | CREATE DATABASE IDENTIFIER
    ;

drop_stmt:
    DROP TABLE IDENTIFIER
    | DROP DATABASE IDENTIFIER
    ;

alter_stmt:
    ALTER TABLE IDENTIFIER ADD IDENTIFIER IDENTIFIER
    ;

/* DML */
select_stmt:
    SELECT STAR FROM table_list
    | SELECT column_list FROM table_list
    ;

insert_stmt:
    INSERT INTO IDENTIFIER VALUES LPAREN value_list RPAREN
    ;

update_stmt:
    UPDATE IDENTIFIER SET IDENTIFIER EQUALS IDENTIFIER WHERE IDENTIFIER EQUALS IDENTIFIER
    ;

delete_stmt:
    DELETE FROM IDENTIFIER WHERE IDENTIFIER EQUALS IDENTIFIER
    ;

column_list:
    IDENTIFIER
    | column_list COMMA IDENTIFIER
    ;

table_list:
    IDENTIFIER
    | table_list COMMA IDENTIFIER
    ;

value_list:
    IDENTIFIER
    | NUMBER
    | value_list COMMA IDENTIFIER
    | value_list COMMA NUMBER
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Line %d | Error: %s | (At token: '%s')\n", yylineno, s, last_token);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Could not open file");
            return 1;
        }
        extern FILE *yyin;
        yyin = file;
    }
    yyparse();
    return 0;
}
