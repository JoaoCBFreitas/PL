%code{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yyerror(char *s){ 
        fprintf(stderr,"Erro:%s\n",s);
    }
    char* myStrCat(char *i, char *m, char *f);
    int yylex();
}

%union{
   char *s;
}
%token NOME NUM ID CASA REL LIXO
%type <s> pessoa nome relacao arv pessoas identificacao casamento
%type <s> NOME NUM ID CASA REL LIXO


%%
arv:pessoas                                                          {char* ini="digraph{\nrankdir=UD\n";char* fin="}\n";char* meio=$1;char* res=myStrCat(ini,meio,fin);printf("%s",res);}
   ;    
pessoas: pessoa pessoas                                              {char* n=myStrCat($1,"",$2);$$=n;}
       | %empty                                                      {char* n="\n";$$=n;}
       ;
pessoa: identificacao nome                                           {$$=myStrCat($1,"->",myStrCat(myStrCat("\"",$2,"\""),";","\n"));}
      | identificacao relacao identificacao                          {if($2=="F"){$$=myStrCat($1,"->",myStrCat($3,";","\n"));}else{$$=myStrCat($3,"->",myStrCat($1,";","\n"));}}
      | casamento identificacao identificacao                        {$$=myStrCat(myStrCat($2,"->",myStrCat($1,";","")),"\n",myStrCat($3,"->",myStrCat($1,";","\n")));}
      | casamento relacao identificacao                              {$$=myStrCat($1,"->",myStrCat($3,";","\n"));}
      | identificacao LIXO                                           {$$="";}
      | casamento LIXO                                               {$$="";}
      ;

identificacao: ID        {$$=$1;}
             ;
casamento: CASA          {$$=$1;}
         ;
nome: LIXO NOME          {$$=$2;}
    ;
relacao: LIXO REL        {$$=$2;}
       ;
%%

#include "lex.yy.c"
char* myStrCat(char *i, char *m, char *f){
      char* s = malloc( sizeof(char)*(strlen(i)+strlen(m)+strlen(f)+1));
      strcat(s,i); strcat(s,m); strcat(s,f);
	return s;
}
int main(){
   yyparse();
   return 0;
}