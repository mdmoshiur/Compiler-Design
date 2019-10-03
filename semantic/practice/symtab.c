#include <stdio.h>
#include <stdlib.h>
#include<string.h>
#include "symtab.h"

static list_t* head = NULL;

void insert(char *name, int len, int type, int lineno)
{
   // printf("insert is called\n");
    //list_t* l = (list_t*)malloc(sizeof(list_t));
    list_t* l = search(name);

	if (l == NULL)
    {
        //printf("after search not founded\n");
		l = (list_t*) malloc(sizeof(list_t));
		strncpy(l->st_name, name,len);  
        l->st_name[len]='\0';
		l->st_type = type;

        //printf("ID name: %s ID type: %d\n", l->st_name, l->st_type);

        l->next = head;
        head = l;

		l->lines = (RefList*) malloc(sizeof(RefList));
		l->lines->lineno = lineno;
		l->lines->next = NULL;
		
		printf("Inserted %s for the first time with linenumber %d!\n", name, lineno);
	}
	else
    {
		RefList *t = l->lines;
		while (t->next != NULL) t = t->next;
			
		t->next = (RefList*) malloc(sizeof(RefList));
		t->next->lineno = lineno;
		t->next->next = NULL;
		printf("Found %s again at line %d!\n", name, lineno);	
	}
}

list_t* search(char *name) 
{ 
    //printf("I am searching %s now\n" ,name);
    list_t *current = head;  // Initialize current 
    while (current != NULL) 
    { 
        if (strcmp(name,current->st_name) != 0)
        {
            //printf("Increament current: current:id name:- %s and search for:- %s\n",current->st_name, name);
            current = current->next; 
        }
        else
        {
            //printf("Founded\n");
            // printf("%s %d\n", current->st_name, current->st_type);

            // RefList *currentLine = current->lines;

            // while(currentLine!=NULL)
            // {
            //     printf(" %d \n", currentLine->lineno);

            //     currentLine = currentLine->next;
            // }

            break;
        }
        
    } 
    return current; 
} 

//for printing symbol table
char type_name[20];
void printType(int a)
{
    if(a==0)
        strcpy(type_name,"UNDEF");
    else if(a==1)
        strcpy(type_name,"INT_TYPE");
    else if(a==2)
        strcpy(type_name,"REAL_TYPE");
    else if(a==3)
        strcpy(type_name,"CHAR_TYPE");
}

void symtab_data(FILE * of)
{  
  int i;
  fprintf(of,"------------ ------  -----------\n");
  fprintf(of,"Name         Type    Line Numbers\n");
  fprintf(of,"------------ ------  ------------\n");
  
  list_t *current = head;
  while (current != NULL)
  {
      printType(current->st_type);
      fprintf(of,"%s\t %s\t",current->st_name, type_name);
      RefList *t = current->lines;
		while (t->next != NULL) 
        {
            fprintf(of,"\t%d",t->lineno);
            t = t->next;
        }
     fprintf(of, "\n");
        
      current = current->next;
  }
  
}
