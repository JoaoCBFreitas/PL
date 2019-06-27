%{
   #include <stdlib.h>
   #include "y.tab.h"
   char *s;
%}
%option noyywrap

%%
[0-9]{4}                                        {yylval.s=strdup(yytext);return DATA;}
\*                                              {yylval.s=strdup(yytext);return NASC;}  
\*(?i:c)                                        {yylval.s=strdup(yytext);return CNASC;}  
\+                                              {yylval.s=strdup(yytext);return FALC;}    
\+(?i:c)                                        {yylval.s=strdup(yytext);return CFALC;} 
^(?i:cc)[ ]?                                    {yylval.s=strdup(yytext);return CASA;}
\:[A-Za-z]+                                     {yylval.s=strdup(yytext);return TIPO;}                                   
([A-Z][a-z]+[ ]?([a-z]+[ ])?(\/)?)+(%[0-9]+)?   {yylval.s=strdup(yytext);return NOME;}
[A-Z]{4}[ ].*$                                  {yylval.s=strdup(yytext);return ANEXO;}
^[A-Z]{1,2}[ ]                                  {yylval.s=strdup(yytext);return REL;}
\[[0-9]+\]                                      {yytext[yyleng-1]='\0';yylval.s=strdup(yytext+1);return ID;}
[\:\[\]\(\)\/\%\{\}\n]                          {return yytext[0];}
[ \t\r]                                         {}
.                                               {yyerror("Carater inválido");}
%%
