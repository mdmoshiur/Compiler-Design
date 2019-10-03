%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.c"
	#include "codeGen.h"
	#include "semantic.h"
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
	int int_val;
	list_t* id;
}

%token <id> ID
%token <int_val> ICONST

%token <int_val> DHORI AKTA INTEGER SOMAN JOG BIYOG GUN VAG  PRINTKORI JODI K_AK_BARAI JOTOKHON  COMMA  SESH AR BOROBASOMAN  SOMANNA SHOTOBASOMAN SURU 

%left JOG BIYOG
%left GUN VAG
%left BOROBASOMAN SHOTOBASOMAN SOMANNA
%right SOMAN
%left SURU SESH
%left COMMA

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);} ;

code: statements;

declaration:  DHORI IDS AKTA INTEGER
;

IDS: ID 
	{
	insert($1->st_name, strlen($1->st_name), INT_TYPE);
	}
	| IDS COMMA IDS
;


statements: statements statement |  ;

statement: declaration 
		  | loop
		  | assign_st
		  | print_st
		  | if_st
		  | inc_st
		  ;


loop: JOTOKHON {gen_code(LABEL, 1);} exp AR { gen_code(JMP_FALSE, 2); } SURU statements {gen_code(GOTO, 1);} SESH { gen_code(LABEL,2);}

if_st: JODI exp AR {gen_code(JMP_FALSE, 3);} SURU statements SESH {gen_code(LABEL, 3);}
;

inc_st: ID K_AK_BARAI
	{
		int address = id_check($1->st_name);
			  
			  if(address!=-1)
			  {
			    gen_code(LD_VAR,address);
            	gen_code(LD_INT, 1);
            	gen_code(ADD,-1);
            	gen_code(STORE,address);
			  }
			  else
			  	exit(1);
	}
;

print_st: PRINTKORI ID
		  {
			  int address = id_check($2->st_name);
			  
			  if(address!=-1)
			  {
				  gen_code(WRITE_INT, address);
				  gen_code(PNEW, -1);
			  }
			  else
			  	exit(1);
		  } 
;

assign_st: ID SOMAN exp
		  {
			  int address = id_check($1->st_name);
			  
			  if(address!=-1)
				  gen_code(STORE, address);
			  else 
			  	exit(1);
		  }
;

exp: ID  
	{
		int address = id_check($1->st_name);
			  
			  if(address!=-1)
				  gen_code(LD_VAR, address);
			  else 
			  	exit(1);
	}
	| ICONST { gen_code(LD_INT, $1); }	
	| exp JOG exp	{ gen_code(ADD, -1);}	  
	| exp BIYOG exp  { gen_code(SUB, -1); }
	| exp GUN exp  { gen_code(MUL, -1); }
	| exp VAG exp  { gen_code(DIV, -1); }
	| exp BOROBASOMAN exp { gen_code(GTE, -1); }
	| exp SHOTOBASOMAN exp { gen_code(LTE, -1); }
	| exp SOMANNA exp { gen_code(NEQ, -1); }
	;

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
	
	printf("Parsing finished!\n");	

	printf("\n\n================STACK MACHINE INSTRUCTIONS================\n");
	print_code();

	printf("\n\n================MIPS assembly================\n");
	print_assembly();

	return flag;
}
