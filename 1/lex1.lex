%top{
#include<math.h>
#include<string.h>
}

%{
#define IDN 1
#define DEC 2
#define OCT 3
#define HEX 4
#define ADD 5
#define SUB 6
#define MUL 7
#define DIV 8
#define GT 9
#define LT 10
#define EQ 11
#define GE 12
#define LE 13
#define NEQ 14
#define SLP 15
#define SRP 16
#define SEMI 17
#define IF 18
#define THEN 19
#define ELSE 20
#define WHILE 21
#define DO 22
#define BEGIN1 23
#define END 24
#define ILOCT 25
#define ILHEX 26

int IDcount=0;//IDcount
char map[100][100];//符号表
int l_scope=0;//左括号数量
int r_scope=0;//右括号数量
int new_scope=1;//作用域标记符
%}
white [\t\n ]
digit [0-9]
digit_8 [0-7]
letter [A-Za-z]
letter_16 [A-Fa-f]
id ({letter})({letter}|{digit})*
decimal [0]|([1-9]{digit}*)
octnum [0]{digit_8}+
hexdec [0][xX]({letter_16}|{digit})+
iloctnum [0]({digit_8}*)[8|9|A-Za-z]({digit}|letter)*
ilhexdec [0][xX](({digit}|{letter_16})*)[g-zG-Z](({digit}|{letter})*)
%%
{white}+ ;
{decimal} {fprintf(yyout,"DEC %d %s\n",DEC,yytext);}
{octnum} {
	int len=strlen(yytext);
	int sum=0;
	int a=1;
	for(int i=0;i<len-1;i++){
	sum=atoi(&yytext[len-1-i])*a+sum;
	a=a*8;
	}
	fprintf(yyout,"OCT %d %d\n",OCT,sum);}
{hexdec} {
	int len=strlen(yytext);
	long sum=0;
	int a=1;
	for(int i=0;i<len-2;i++){
	int x;
	if(yytext[len-1-i]>='0'&&yytext[len-1-i]<='9')
	{	x=atoi(&yytext[len-1-i]);}
	else if(yytext[len-1-i]>='a'&&yytext[len-1-i]<='f')
	{	x=yytext[len-1-i]-'a'+10;}
	else
	{	x=yytext[len-1-i]-'A'+10;}
	sum=x*a+sum;
	a=a*16;
	}
	fprintf(yyout,"HEX %d %ld\n",HEX,sum);}
{iloctnum} {fprintf(yyout,"ILOCT %d %s\n",ILOCT,yytext);}
{ilhexdec} {fprintf(yyout,"ILHEX %d %s\n",ILHEX,yytext);}
"if" {fprintf(yyout,"IF %d %s\n",IF,yytext);}
"then" {fprintf(yyout,"THEN %d %s\n",THEN,yytext);}
"else" {fprintf(yyout,"ELSE %d %s\n",ELSE,yytext);}
"do" {fprintf(yyout,"DO	%d %s\n",DO,yytext);}
"while" {fprintf(yyout,"WHILE %d %s\n",WHILE,yytext);}
"begin" {fprintf(yyout,"BEGIN %d %s\n",BEGIN1,yytext);}
"end" {fprintf(yyout,"END %d %s\n",END,yytext);}
{id} {
        int flag = 0;
        int i = 0;
        for(i=IDcount-1;i>0;i--)
        {
           if(strcmp(yytext,map[i])==0)
           {
               flag=1;break;
           }
        }
        if(flag==1&&new_scope!=0)//匹配到已有字符但仍处在旧的作用域
        {
           fprintf(yyout,"ID %d %s\n",i+70,yytext);
        }
        else//没有匹配到已有字符或者来到了新的作用域
        {
             IDcount++;
             strcpy(map[IDcount-1],yytext);
             new_scope=1;//每次插入一个新字符后需要将作用域标记符重新置1
             fprintf(yyout,"IDN %d %s\n",IDcount-1+70,yytext);
        }
}

"(" {fprintf(yyout,"SLP %d %s\n",SLP,yytext);}
")" {fprintf(yyout,"SRP %d %s\n",SRP,yytext);}
"*" {fprintf(yyout,"MUL %d %s\n",MUL,yytext);}
"/" {fprintf(yyout,"DIV %d %s\n",DIV,yytext);}
"+" {fprintf(yyout,"ADD %d %s\n",ADD,yytext);}
"-" {fprintf(yyout,"SUB %d %s\n",SUB,yytext);}
">" {fprintf(yyout,"GT %d %s\n",GT,yytext);}
"<" {fprintf(yyout,"LT %d %s\n",LT,yytext);}
">=" {fprintf(yyout,"GE %d %s\n",GE,yytext);}
"<=" {fprintf(yyout,"LE %d %s\n",LE,yytext);}
"=" {fprintf(yyout,"EQ %d %s\n",EQ,yytext);}
"<>" {fprintf(yyout,"NEQ %d %s\n",NEQ,yytext);}
";" {fprintf(yyout,"SEMI %d %s\n",SEMI,yytext);}
%%
int main()
{
  memset(map, 0, sizeof(map));
  yyin=fopen("testin.c","r");
  yyout=fopen("testout.txt","w");
  fprintf(yyout,"token name value\n");
  yylex();
  return 0;
}
int yywrap()
{
return 1;
}
