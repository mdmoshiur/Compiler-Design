
main:lexer.l parser.y
	bison -d parser.y  
	flex lexer.l  
	gcc parser.tab.c lex.yy.c  
	rm lex.yy.c parser.tab.c
	./a <full_example.c> output.txt

