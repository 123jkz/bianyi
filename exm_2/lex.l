%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"


%}

%%
if                                        {return IF;}
then                                      {return THEN;}
else                                      {return ELSE;}
while                                     {return WHILE;}
do                                        {return DO;}
begin                                     {return BEGIN_N;}
end                                       {return END;}
[a-zA-Z][a-zA-Z0-9]*                      {return IDN;}
0|([1-9]+[0-9]*)                          {return DEC;}
0[0-7]+                                   {return OCT;}  
0[0-7]*[8-9]+[0-7]*                       {return ILOCT;}
0[xX][0-9a-fA-F]+                         {return HEX;} 
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
