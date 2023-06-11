%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
#include "ya.tab.h"


%}

%%
if                                        {return IF;}
then                                      {return THEN;}
else                                      {return ELSE;}
while                                     {return WHILE;}
do                                        {return DO;}
begin                                     {return BEGIN_N;}
end                                       {return END;}
[a-zA-Z][a-zA-Z0-9]*                      {
yylval=strdup(yytext);
return IDN;}
0|([1-9]+[0-9]*)                          {
yylval=strdup(yytext);
return DEC;}
0[0-7]+                                   {
//char c[10];
//for(int i=0;i<strlen(yytext);i++)
//{
 //c[i]=yytext[i];
//}
//c[strlen(yytext)]="\0";
yylval=strdup(yytext);
return OCT;}  
0[0-7]*[8-9]+[0-7]*                       {return ILOCT;}
0[xX][0-9a-fA-F]+                         {
char c[10];
yylval=strdup(yytext);
return HEX;} 
0[xX][0-9a-fA-F]*[g-zG-Z]+[0-9a-fA-F]*    {return ILHEX;}
\+                                        {return ADD;}
\-                                        {return SUB;}
\*                                        {return MUL;}
\/                                        {return DIV;}
\>                                        {return GT;}
\<                                        {return LT;}
\=                                        {return EQ;}
">="                                      {return GE;}
"<="                                      {return LE;}
"<>"                                      {return NEQ;}
\(                                        {return SLP;}
\)                                        {return SRP;}
\;                                        {return SEMI;}
[ \t\n]                                   
%%
