%option noyywrap

%{
    #include "cal.tab.h"
%}

%%

[ \t] {}
[0-9]+ {yylval.int_number = atoi(yytext); return INT_NUMBER;}
[0-9]+\.[0-9]+ {yylval.float_number = atoi(yytext); return FLOAT_NUMBER;}
\n {return EOL; }
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"(" { return LPAREN; }
")" { return RPAREN; }
"<" { return LESSTHAN;}
">" { return GREATERTHAN;}
"quit" {return QUIT;}
%%