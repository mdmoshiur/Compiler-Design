%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
	#include "parser.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
print     [ -~]

ID        {alpha}+{alnum}*
ICONST    "0"|[0-9]{digit}*

%%

"//".*        	 	{ printf("Comment at line %d\n", lineno); } 

"dhori"     	    { return DHORI; }
"akta"       	    { return AKTA; }
"integer"      		{ return INTEGER; }
"soman"     		{ return SOMAN; }
"jog"   			{ return JOG; }
"biyog"				{ return BIYOG; }
"gun"   			{ return GUN; }
"vag"   			{ return VAG; }
"print kori"     	{ return PRINTKORI; }
"jodi"  			{ return JODI; } 
"borobasoman" 		{ return BOROBASOMAN; }
"chotobasoman"		{ return SHOTOBASOMAN; }
"somanna"			{ return SOMANNA; }
"ar"  				{ return AR; }
"suru" 				{ return SURU; }
"sesh" 				{ return SESH; }
"jotokhon porjonto" { return JOTOKHON; }
"k_ak_barai"        { return K_AK_BARAI; }
","  				{return COMMA; }

{ID}    {
		yylval.id = (list_t*)malloc(sizeof(list_t));
        strcpy(yylval.id->st_name, yytext);
        return ID;
        }
{ICONST}    { yylval.int_val   = atoi(yytext); return ICONST; }

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }

%%
