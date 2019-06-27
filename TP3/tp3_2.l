%{
   #include <stdlib.h>
   #include "y.tab.h"
   char *s;
%}
%option noyywrap

%%
^\#F[0-9]                                       {yylval.s=strdup(yytext+1);return CASA;}                                  
([A-Z][a-z]+[ ]?([a-z]+[ ])?)+(%[0-9]+)?        {yylval.s=strdup(yytext);return NOME;}  
-[A-Z]+                                         {yylval.s=strdup(yytext+1);return REL;}
\#aut[0-9]+                                     {yylval.s=strdup(yytext+1);return ID;} 
\#I[0-9]+                                       {yylval.s=strdup(yytext+1);return ID;}
nome                                            {yylval.s=strdup(yytext);return LIXO;}
tem-como                                        {yylval.s=strdup(yytext);return LIXO;}
data-.*[ ][0-9]{4}                              {yylval.s=strdup(yytext);return LIXO;}
[A-Z]{4}[ ].+\..+                               {yylval.s=strdup(yytext);return LIXO;}
[\%]                                            {return yytext[0];}
[ \n\t\r\.]                                     {}
.                                               {yyerror("Carater inválido");}
%%