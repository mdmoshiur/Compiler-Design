%{
    #include<stdio.h>
    #include <stdlib.h>
    void yyerror(char *s);
    int yylex();
%}

%union {
	int int_number;
	float float_number;
}


%token<int_number> INT_NUMBER
%token<float_number> FLOAT_NUMBER
%token ADD SUB MUL DIV EOL
%token LPAREN RPAREN QUIT GREATERTHAN LESSTHAN

%left ADD SUB
%left MUL DIV

%type<int_number> exp
%type<float_number> mixed_exp

%start cal

%%

cal:
    |cal line
;

line: EOL
    |mixed_exp EOL {printf("Result: %f\n",$1);}
    |exp EOL {printf("Result: %i\n", $1); }
    |QUIT EOL {printf("Finished\n"); exit(0);}
;

mixed_exp: FLOAT_NUMBER          {$$ = $1;}
    |mixed_exp ADD mixed_exp { $$ = $1 + $3; }
    |mixed_exp SUB mixed_exp { $$ = $1 - $3; }
    |mixed_exp MUL mixed_exp { $$ = $1 * $3; }
    |mixed_exp DIV mixed_exp { $$ = $1 / $3; }
    |LPAREN  mixed_exp RPAREN	 { $$ = $2; }
    |exp ADD mixed_exp { $$ = $1 + $3; }
    |exp SUB mixed_exp { $$ = $1 - $3; }
    |exp MUL mixed_exp { $$ = $1 * $3; }
    |exp DIV mixed_exp { $$ = $1 / $3; }
    |mixed_exp ADD exp { $$ = $1 + $3; }
    |mixed_exp SUB exp { $$ = $1 - $3; }
    |mixed_exp MUL exp { $$ = $1 * $3; }
    |mixed_exp DIV exp { $$ = $1 / $3; }
    |exp DIV exp           { $$ = $1 / (float)$3; }
;

exp: INT_NUMBER {$$ = $1;}
    |exp ADD exp { $$ = $1 + $3; }
    |exp SUB exp { $$ = $1 - $3; }
    |exp MUL exp { $$ = $1 * $3; }
    |exp GREATERTHAN exp 
    { 
        if($1>$3)
        {
            $$ = 1;
        } else
        {
            $$ = 0;
        }
    }
    |exp LESSTHAN exp
    {
        if($1 < $3)
        {
            $$ = 1;
        } else
        {
            $$ = 0;
        }
    }
    |LPAREN exp RPAREN { $$ = $2; }
;

%%
int main()
{
    //printf("> ");
    yyparse();
}
void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}