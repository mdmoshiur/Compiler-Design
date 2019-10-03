%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;
	char* str_val;
	list_t* symtab_item;
}

%token<int_val> CHAR INT FLOAT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN
%token<int_val> ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP RELOP
%token<int_val> LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER
%token <symtab_item> ID
%token <int_val> 	 ICONST
%token <double_val>  FCONST
%token <char_val> 	 CCONST
%token <str_val>     STRING

%left LPAREN RPAREN LBRACK RBRACK
%right NOTOP INCR REFER
%left MULOP DIVOP
%left ADDOP
%left RELOP
%left EQUOP
%left OROP
%left ANDOP
%right ASSIGN
%left COMMA

%type <int_val> constant names type expression declaration

%start program

%%

program: statements;

statements: statements statement | ;

statement: declarations 
    | assign_st 
    | inc_st
;

assign_st: ID ASSIGN expression SEMI 
    {
        list_t *ptr = search($1->st_name);
        if(ptr!=NULL)
        {
            int type = ptr->st_type;
            if(type == UNDEF)
            {
                printf("Variable is used before declaration\n");
            } else if( type == $3)
            {
                printf("No problem valid exp.\n");
            } else
            {
                fprintf(stderr,"Type mismatch\n");
                exit(1);
            }
        }
    }
;

inc_st: ID INCR SEMI
    {
        list_t *ptr = search($1->st_name);
        if(ptr!=NULL)
        {
            int type = ptr->st_type;
            if(type == UNDEF)
            {
                printf("Variable is used before declaration\n");
            } else if( type == INT_TYPE)
            {
                printf("No problem\n");
            } else
            {
                fprintf(stderr,"Only INT type is allowed for increment decrement\n");
                exit(1);
            }
        }
    }
    | INCR ID SEMI
    {
        list_t *ptr = search($2->st_name);
        if(ptr!=NULL)
        {
            int type = ptr->st_type;
            if(type == UNDEF)
            {
                printf("Variable is used before declaration\n");
            } else if( type == INT_TYPE)
            {
                printf("No problem\n");
            } else
            {
                fprintf(stderr,"Only INT type is allowed for increment decrement\n");
                exit(1);
            }
        }
    }
;

declarations: declarations declaration | ;

declaration: type ID names SEMI
{
    //printf("type: %d, names: %d\n",$1, $3);
    //search for ID
    list_t *ptr = search($2->st_name);
    if(ptr != NULL)
    {
        if(ptr->st_type != UNDEF)
        {
        
            fprintf(stderr, "Multiple declaration of %s is found at line no %d\n", ptr->st_name,lineno);
		    exit(1);
        }
    }
    ptr->st_type = $1;
    
    if( $1 == $3 || $3 == 0)
    {
        printf("No problem\n");
    } else
    {
        fprintf(stderr, "Type conflict between %d and %d using op type \n", $1, $3);
		exit(1);
    }
}

;

names: ASSIGN expression 
    {
        $$ = $2;
    }
    | //epsilon
    {
        $$ = 0;
    }
;

type: INT { $$ = INT_TYPE; }
    |CHAR { $$ = CHAR_TYPE; }
    |FLOAT { $$ = REAL_TYPE; }
    |DOUBLE { $$ = REAL_TYPE; }
    |VOID
;

constant: ICONST { $$ = INT_TYPE; }
    |FCONST { $$ = REAL_TYPE; }
    |CCONST { $$ = CHAR_TYPE; }
;

expression:
    expression ADDOP expression
    {
        if($1 == $3 && $1 != CHAR_TYPE)
        {
            //printf("No problem to add\n");
            $$ = $1;
        } else
        {
            $$ = -1;
            //printf("cann't perform add type mismatched!\n");
        }
    } 
    |expression MULOP expression
    |expression DIVOP expression 
    |ID INCR 
    |INCR ID 
    |expression OROP expression 
    |expression ANDOP expression 
    |NOTOP expression 
    |expression EQUOP expression 
    |expression RELOP expression 
    |LPAREN expression RPAREN 
    |sign constant { $$=$2;} 
	|ID { $$ = $1->st_type; }
;

sign: ADDOP | /* empty */ ;

%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[])
{
	int flag;
	flag = yyparse();
	
	printf("Parsing finished!");
	
	// symbol table data
	yyout = fopen("symtab_data.out", "w");
	symtab_data(yyout);
	fclose(yyout);
	
	return flag;
}