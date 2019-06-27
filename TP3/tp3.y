%code{
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      int yyerror(char *s){ 
            fprintf(stderr,"Erro:%s\n",s);
      }
      char* myStrCat(char *i, char *m, char *f);
      char* criaAut(int aut);
      char* idGiv(char* s,char* id);
      char* arranja(char* s);
      char* casamento(char *res);
      int yylex();
      int aut=1;
}
%union{
   char *s;
}
%token NOME NUM DATA TIPO ANEXO ID CFALC FALC NASC CNASC CASA REL
%type <s> pessoa anexo anexos nome eventos evento relacao parentesco identificacao extra extras Z
%type <s> NOME NUM DATA TIPO ID ANEXO CFALC FALC NASC CNASC CASA REL


%%
Z: pessoa   {char* r=casamento(arranja($1));printf("%s\n",r);}
 ;
pessoa: nome eventos identificacao                    {char* id=myStrCat("#I",$3," ");char* res=myStrCat(id,$1,"\n");
                                                      char* even=myStrCat(id,idGiv($2,id),"\n");char* r=myStrCat("",res,even);$$=r;}  
      | extras                                        {$$=$1;}
      ;

identificacao: ID                                     {$$=$1;}             
             ;

extras: extra '\n' extras                             {$$=myStrCat("",$1,$3);}
      | %empty                                        {$$=myStrCat("","","");}
      ;

extra: pessoa                                         {}
     | parentesco                                     {$$=$1;}
     | eventos                                        {$$=$1;}
     | anexos                                         {$$=$1;}
     ;

nome: NOME NOME                                       {char* nome=myStrCat("nome ",$1,$2);$$=nome;}
    | NOME '%' NUM                                    {char* nome=myStrCat("nome ",$1,myStrCat("%",$3,""));$$=nome;}
    | NOME                                            {char* nome=myStrCat("nome ",$1,"");$$=nome;}
    ;
eventos: evento eventos                               {$$=myStrCat($1,"\n",$2);}
       | evento                                       {$$=myStrCat($1,"","\n");}
       ;

evento: NASC DATA                                     {char* d=myStrCat("data-nascimento ",$2,"");$$=d;}
      | FALC DATA                                     {char* d=myStrCat("data-falecimento ",$2,"");$$=d;}
      | CFALC DATA                                    {char* d=myStrCat("data-falecimento cerca ",$2,"");$$=d;}
      | CNASC DATA                                    {char* d=myStrCat("data-nascimento cerca ",$2,"");$$=d;}
      | CASA DATA identificacao                       {char* d=myStrCat(myStrCat(myStrCat("#F",$3," "),"= ",""),"\n",myStrCat(myStrCat("#F",$3," "),myStrCat("","data-casamento ",$2),""));$$=d;}
      | "ev("DATA':'TIPO')'                           {char* d=myStrCat($4," ",$2);$$=d;}
      ;

parentesco: relacao nome                                            {char* r=myStrCat($1,"",(myStrCat(criaAut(aut),"\n","")));char* n=myStrCat(criaAut(aut)," ",myStrCat($2,"","\n"));aut++;char* res=myStrCat(r,n,"");$$=res;}                       
          | relacao nome eventos                                    {char* r=myStrCat($1,"",(myStrCat(criaAut(aut),"\n","")));char* n=myStrCat(criaAut(aut)," ",myStrCat($2,"","\n"));char* d=myStrCat(criaAut(aut)," ",myStrCat("",idGiv($3,criaAut(aut)),"\n"));aut++;char* res=myStrCat(r,n,d);$$=res;}
          | relacao identificacao                                   {char* r=myStrCat($1,"#I",myStrCat($2,"","\n"));$$=r;}
          | relacao nome eventos identificacao '{' extras '}'       {char* id=myStrCat("#I",$4," ");char* n=myStrCat(id,$2,"\n");char* e=myStrCat(id,idGiv($3,id),"\n");char* a=idGiv(myStrCat(id,$6,""),id);char* r=myStrCat($1,id,"\n");char* res=myStrCat(n,e,myStrCat(r,a,"\n"));$$=res;}
          ;

relacao: REL                                            {char* rel=myStrCat("tem-como-",$1,"");$$=rel;}
       ;
anexos: anexo anexos                                    {$$=myStrCat($1,$2,"");}
      | anexo                                           {$$=$1;}
      ;
anexo: ANEXO                                            {char* anex=myStrCat($1,"","\n");$$=anex;}
     ;
%%

#include "lex.yy.c"
char* myStrCat(char *i, char *m, char *f){
      char* s = malloc( sizeof(char)*(strlen(i)+strlen(m)+strlen(f)+1));
      strcat(s,i); strcat(s,m); strcat(s,f);
	return s;
}
char* criaAut(int aut){
      char id[100];
      char* a="#aut";
      char* s=malloc(sizeof(char)*(strlen(a)+10));
      sprintf(id,"%d",aut);
      s=myStrCat(a,id,"");
      return s;
}
char* idGiv(char* s,char* id){
      int j=0;
      char* res=malloc(sizeof(char)*(strlen(s)+strlen(id)+4));
      for(int i=0;i<strlen(s)-1;i++){
            if(s[i]!='\n'){
                  res[j]=s[i];
                  j++;
            }else{
                  strcat(res,myStrCat("\n",id," "));
                  j+=strlen(id)+1;
            }
      }
      return res;
}
char* arranja(char* s){
      char* res=malloc(sizeof(char)*(strlen(s)*2));
      int j=0,i=0;
      char cas[10];
      char id1[10];
      char id2[10];
      char temp[10];
      for(i=0;i<strlen(s)-1;i++){
            res[j]=s[i];
            j++;
            if(s[i]=='#' && id1[0]=='#' && s[i+1]=='I'){
                  temp[0]=s[i];
                  temp[1]=s[i+1];
                  temp[2]=s[i+2];
                  temp[3]=' ';
                  temp[4]='\0';
                  if(strcmp(temp,id2) && strcmp(temp,id1)) strcpy(id2,temp);               
            }            
            if(s[i]=='#' && s[i+1]=='I'){
                  temp[0]=s[i];
                  temp[1]=s[i+1];
                  temp[2]=s[i+2];
                  temp[3]=' ';
                  temp[4]='\0';
                  if(strcmp(temp,id2) && strcmp(temp,id1)) strcpy(id1,temp);                
            }
            if(s[i]=='#' && s[i+1]=='F'){
                  temp[0]=s[i];
                  temp[1]=s[i+1];
                  temp[2]=s[i+2];
                  temp[3]=' ';
                  temp[4]='\0';
                  if(strcmp(temp,cas)) strcpy(cas,temp);             
            }
            if(s[i]=='\n' && s[i+1]!='#' && cas[0]!='#'){
                  strcat(res,id1);
                  j+=strlen(id1);
            }
            if(s[i]=='\n' && s[i+1]!='#' && cas[0]=='#'){
                  strcat(res,cas);
                  j+=strlen(cas);
            }
      }
      res[j]='\0';
      return res;
}
char* casamento(char *res){
      int i,j=0,flag=0;
      char id1[10];
      char id2[10];
      char* rel;
      char temp[10]; 
      char* resposta=malloc(sizeof(char)*(strlen(res)*2));    
      for(i=0;i<strlen(res)-1 && flag>=0;i++){
            if(res[i]=='#' && res[i+1]=='I' && flag==0){
                  temp[0]=res[i];
                  temp[1]=res[i+1];
                  temp[2]=res[i+2];
                  temp[3]=' ';
                  temp[4]='\0';
                  if(strcmp(temp,id2) && strcmp(temp,id1)) strcpy(id1,temp);                 
            }
            if(res[i]=='#' && res[i+1]=='F'){
                  flag=1;
            }
            if(res[i]=='#' && res[i+1]=='I' && flag==1){
                  temp[0]=res[i];
                  temp[1]=res[i+1];
                  temp[2]=res[i+2];
                  temp[3]=' ';
                  temp[4]='\0';
                  if(strcmp(temp,id2) && strcmp(temp,id1)) strcpy(id2,temp);                 
                  flag=-1;
                  rel=myStrCat(" ",id1,id2);
            }          
      }
      j=0;
      for(i=0;i<strlen(res)-1;i++){
            resposta[j]=res[i];
            j++;  
            if(res[i]=='='){
                  strcat(resposta,rel);
                  j+=strlen(rel);
            }
      }
      resposta[j]='\0';
      return resposta;
}
int main(){
   yyparse();
   return 0;
}