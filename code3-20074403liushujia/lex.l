%{
	#include "headfile.h"
	#include "gram.tab.h"
	
	
%}

	
%option noyywrap
%%
if                                        {return IF;}
then                                      {return THEN;}
else                                      {return ELSE;}
while                                     {return WHILE;}
do                                        {return DO;}
begin                                     {return BEGIN_N;}
end                                       {return END;}
[a-zA-Z][a-zA-Z0-9]*                      { filllexeme(&yylval, yytext); return( ID ); }
0|([1-9]+[0-9]*)                         { filllexeme(&yylval, yytext); return( DEC ); }
0[0-7]+                                   { filllexeme(&yylval, yytext); return( OCT ); }
0[0-7]*[8-9]+[0-7]*                       { filllexeme(&yylval, yytext); return( ILOCT ); }
0[xX][0-9a-fA-F]+                        { filllexeme(&yylval, yytext); return( HEX ); }
0[xX][0-9a-fA-F]*[g-zG-Z]+[0-9a-fA-F]*    { filllexeme(&yylval, yytext); return( ILHEX ); }
\+                                        {return ADD;}
\-                                        {return SUB;}
\*                                        {return MUL;}
\/                                        {return DIV;}
">"                                        {filloperator(&yylval, yytext); return( GT); }
\<                                        {filloperator(&yylval, yytext); return( LT); }
\=                                       {filloperator(&yylval, yytext); return( EQ); }
">="                                     {filloperator(&yylval, yytext); return( GE); }
"<="                                     {filloperator(&yylval, yytext); return( LE); }
"<>"                                    {filloperator(&yylval, yytext); return( NEQ); }
"("                                        {return SLP;}
")"                                       {return SRP;}
\;                                        {return SEMI;}
[ \t\n]         

%%