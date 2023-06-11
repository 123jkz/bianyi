%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ya.tab.h"
//#include "lex.yy.c"

extern FILE *yyin, *yyout;
typedef char* ElemType; 
    typedef struct BiTNode{
        ElemType data;
        int type;
        struct BiTNode *C1, *C2, *C3,*C4,*C5,*C6;
    }BiTNode, *BiTree;
 
    typedef struct Node{
        BiTNode *data;
        struct Node *next;
    }Node, *LinkedList;
 
int yylex(void);
void yyerror(char*);
char* ecode(BiTree);
char* tcode(BiTree);
char* fcode(BiTree);
void scode(BiTree,int);
void ccode(BiTree,int,int);
//创建链表
LinkedList LinkedListInit()    
{    
     Node *L;    
     L = (Node *)malloc(sizeof(Node));
     L->next = NULL;
     return L;
}
 
//插入节点，头插法
LinkedList LinkedListInsert(LinkedList L,BiTNode *x)    
{    
     Node *pre;
     pre = L;
     Node *p;
     p = (Node *)malloc(sizeof(Node));    
     p->data = x;     
     p->next = pre->next;    
     pre->next = p;    
     return L;                               
}
 
//创建叶子
BiTree createLeaf(ElemType root)
{
 
     BiTree T8 = (BiTree)malloc(sizeof(BiTNode));
     if (T8 != NULL) {
               T8->data = root;
               T8->C1 = NULL;
               T8->C2 = NULL;
               T8->C3 = NULL;
               T8->C4 = NULL;
               T8->C5 = NULL;
               T8->C6 = NULL;
     }
     else exit(-1);
     return T8;
}
 
BiTree createTree(ElemType root, BiTree leaf1, BiTree leaf2, BiTree leaf3, BiTree leaf4, BiTree leaf5, BiTree leaf6)
{
 
     BiTree T8 = (BiTree)malloc(sizeof(BiTNode));
     if (T8 != NULL) {
               T8->data = root;
               T8->C1 = leaf1;
               T8->C2 = leaf2;
               T8->C3 = leaf3;
               T8->C4 = leaf4;
               T8->C5 = leaf5;
               T8->C6 = leaf6;
     }
     else exit(-1);
     return T8;
}
 int label=0;
    int temp=0;
//后序遍历
void TraverseBiTree(BiTree T8)
{
     if (T8 == NULL) return ;
     TraverseBiTree(T8->C1);
     TraverseBiTree(T8->C2);
     TraverseBiTree(T8->C3);
     TraverseBiTree(T8->C4);
     TraverseBiTree(T8->C5);
     TraverseBiTree(T8->C6);
     if(T8->data != " ") printf("%s ", T8->data);
}
void Index_print(BiTree T8,int l){
	if(T8!=NULL){
		if(T8->data!=" "){
		for(int i=1;i<l;i++)fprintf(yyout," ");
		fprintf(yyout,"%2d ",l);
		fprintf(yyout,"%s %d\n",T8->data,T8->type);
		Index_print(T8->C1,l+1);
		Index_print(T8->C2,l+1);
		Index_print(T8->C3,l+1);
		Index_print(T8->C4,l+1);
		Index_print(T8->C5,l+1);
		Index_print(T8->C6,l+1);
		}
	}
}
void scode(BiTree T8,int l){
printf("sok\n");
printf("1%s 2%s 3%s 4%s 5%s 6%s\n",T8->C1->data,T8->C2->data,T8->C3->data,T8->C4->data,T8->C5->data,T8->C6->data);
	if(T8->type==1){
		char* c=ecode(T8->C3);
		fprintf(yyout,"%s=%s\n",T8->C1->data,c);
	}
	else if(T8->type==2){
		int ctrue=label+1;
		int cfalse=l;
		label=label+1;
		ccode(T8->C2,cfalse,ctrue);
		//fprintf(yyout,"goto l%d\n",l);
		fprintf(yyout,"l%d:\n",ctrue);
		scode(T8->C4,l);
	}
	else if(T8->type==3){
		int ctrue=label+1;
		int cfalse=label+2;
		label=label+2;
		ccode(T8->C2,cfalse,ctrue);
		fprintf(yyout,"l%d:\n",ctrue);
		scode(T8->C4,l);
		fprintf(yyout,"goto l%d\n",l);
		fprintf(yyout,"l%d:\n",cfalse);
		scode(T8->C6,l);
	}
	else if(T8->type==4){
		int begin=label+1;
		int ctrue=label+2;
		int cfalse=l;
		label=label+2;
		fprintf(yyout,"l%d:\n",begin);
		ccode(T8->C2,cfalse,ctrue);
		fprintf(yyout,"l%d:\n",ctrue);
		scode(T8->C4,begin);
		fprintf(yyout,"goto l%d\n",begin);
	}
	//fprintf(yyout,"l%d\n",l);
	return;
}
void ccode(BiTree T8,int cf,int ct){
printf("cok\n");
printf("1%s 2%s 3%s 4%s 5%s 6%s\n",T8->C1->data,T8->C2->data,T8->C3->data,T8->C4->data,T8->C5->data,T8->C6->data);
	if(T8->type==1){
		char* c1=ecode(T8->C1);
		char* c2=ecode(T8->C3);
		fprintf(yyout,"if %s>%s goto l%d\n",c1,c2,ct);
		fprintf(yyout,"goto l%d\n",cf);
	}
	else if(T8->type==2){
		char* c1=ecode(T8->C1);
		char* c2=ecode(T8->C3);
		fprintf(yyout,"if %s<%s goto l%d\n",c1,c2,ct);
		fprintf(yyout,"goto l%d\n",cf);
	}
	else if(T8->type==3){
		char* c1=ecode(T8->C1);
		char* c2=ecode(T8->C3);
		fprintf(yyout,"if %s=%s goto l%d\n",c1,c2,ct);
		fprintf(yyout,"goto l%d\n",cf);
	}
	else if(T8->type==4){
		char* c1=ecode(T8->C1);
		char* c2=ecode(T8->C3);
		fprintf(yyout,"if %s>=%s goto l%d\n",c1,c2,ct);
		fprintf(yyout,"goto l%d\n",cf);
	}
	else if(T8->type==5){
		char* c1=ecode(T8->C1);
		char* c2=ecode(T8->C3);
		fprintf(yyout,"if %s<=%s goto l%d\n",c1,c2,ct);
		fprintf(yyout,"goto l%d\n",cf);
	}
	else if(T8->type==6){
		char* c1=ecode(T8->C1);
		char* c2=ecode(T8->C3);
		fprintf(yyout,"if %s<>%s goto l%d\n",c1,c2,ct);
		fprintf(yyout,"goto l%d\n",cf);
	}
	return;
}

char* ecode(BiTree T8){
printf("eok\n");
printf("1%s 2%s 3%s 4%s 5%s 6%s\n",T8->C1->data,T8->C2->data,T8->C3->data,T8->C4->data,T8->C5->data,T8->C6->data);
	if(T8->type==3){
		char* c=tcode(T8->C1);
		return c;
	}
	else if(T8->type==1){
		int a=temp+1;
		temp++;
		//char buff[10];
		//itoa(a,buff,10);
		char cn[]={'t','0'+a};
		char* c=cn;
		//char cn='0'+a;
		//c[1] = cn; 
		//c[sizeof(c)] = '\0' ;
		//c=strcat(c,buff);
		//c[1]=c[1]+a;
		char* c1=ecode(T8->C1);
		char* c2=tcode(T8->C3);
		fprintf(yyout,"%s=%s+%s\n",c,c1,c2);
		return c;
	}
	else if(T8->type==2){
		int a=temp+1;
		temp++;
		//char buff[10];
		//itoa(a,buff,10);
		char cn[]={'t','0'+a};
		char* c=cn;
		//c[1] = cn; 
		//c[sizeof(c)] = '\0' ;
		//c=strcat(c,buff);
		//c[1]=c[1]+a;
		char* c1=ecode(T8->C1);
		char* c2=tcode(T8->C3);
		fprintf(yyout,"%s=%s-%s\n",c,c1,c2);
		return c;
	}
}
char* tcode(BiTree T8){
printf("tok\n");
printf("1%s 2%s 3%s 4%s 5%s 6%s\n",T8->C1->data,T8->C2->data,T8->C3->data,T8->C4->data,T8->C5->data,T8->C6->data);
	if(T8->type==3){
		char* c=fcode(T8->C1);
		printf("tdone\n");
		return c;
	}
	else if(T8->type==1){
		int a=temp+1;
		temp++;
		//char buff[10];
		//itoa(a,buff,10);
		char cn[]={'t','0'+a};
		char* c=cn;
		//c[1] = cn; 
		//c[sizeof(c)] = '\0' ;
		//c=strcat(c,buff);
		//c[1]=c[1]+a;
		char* c1=tcode(T8->C1);
		char* c2=fcode(T8->C3);
		fprintf(yyout,"%s=%s*%s\n",c,c1,c2);
		return c;
	}
	else if(T8->type==2){
		int a=temp+1;
		temp++;
		//char buff[10];
		//itoa(a,buff,10);
		char cn[]={'t','0'+a};
		char* c=cn;
		//c[1] = cn; 
		//c[sizeof(c)] = '\0' ;
		//c=strcat(c,buff);
		//c[1]=c[1]+a;
		char* c1=tcode(T8->C1);
		char* c2=fcode(T8->C3);
		fprintf(yyout,"%s=%s/%s\n",c,c1,c2);
		return c;
	}
}

char* fcode(BiTree T8){
printf("fok\n");
printf("1%s 2%s 3%s 4%s 5%s 6%s\n",T8->C1->data,T8->C2->data,T8->C3->data,T8->C4->data,T8->C5->data,T8->C6->data);
	if(T8->type==1){
		char* c=ecode(T8->C2);
		//char c[]={'t',a+'0'}
		return c;
		//fprintf(yyout,"%s=t%d\n"T8->C1->data,a);
	}
	else{
		return T8->C1->data;
	}
}
    LinkedList list = NULL;
    LinkedList head = NULL;
    BiTree T, T1, T2, T3,T4,T5,T6;
%}

	%union {
		char* sval;
		int val;
		}
		 %type <sval>F
        %type <sval>T
        %type <sval>E
        %type <sval>C
	%token IF
	%token THEN
	%token ELSE
	%token WHILE
	%token DO
	%token BEGIN_N
	%token END
	%token ADD
	%token SUB
	%token MUL
	%token DIV
	%token GT
	%token LT
	%token EQ
	%token GE
	%token LE
	%token NEQ
	%token SLP
	%token SRP
	%token SEMI
    %token KEY
	%token SPACE_ENTER
	%token UNDEFINE
	%token <sval> DEC
	%token <sval> HEX
	%token <sval> OCT
	%token ILHEX
	%token ILOCT
	%token <sval>IDN
	%token END_OF_INPUT

%%
P: L   {printf("p_>l");
}
 | L P	{printf("p_>lp");}
 ;   

L: S SEMI{
	//printf("p->l\n");
	//printf("p_>l");
	head = list->next;
        T = head->data;
        //fprintf(yyout,"Traverse BiTree:\n");
        //TraverseBiTree(T);
        //fprintf(yyout,"0 L\n");
        //Index_print(T,1);
        //fprintf(yyout," 1 ;\n");
        int a=label;
        scode(T,label);
        label++;
        fprintf(yyout,"l%d:\n",a);
}
 ;

S: IDN EQ E{
	//printf("s->id eq e\n");
	head = list->next;
        T1 = createLeaf($1);
        T2 = createLeaf("=");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("S", T1, T2, T3,T4,T5,T6);
        T->type=1;
        list->next = head->next;
        LinkedListInsert(list, T);
}
 | IF C THEN S{
	//printf("s->if then\n");
	head = list->next;
        T1 = createLeaf("IF");
        T2 = head->next->data;
        T3 = createLeaf("THEN");
        T4 = head->data;
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("S", T1, T2, T3,T4,T5,T6);
        T->type=2;
        list->next = head->next->next;
        LinkedListInsert(list, T);
}
 | IF C THEN S ELSE S{
	//printf("s->if then else\n");
	head = list->next;
        T1 = createLeaf("IF");
        T2 = head->next->next->data;
        T3 = createLeaf("THEN");
        T4 = head->next->data;
        T5 = createLeaf("ELSE");
        T6 = head->data;
        T = createTree("S", T1, T2, T3,T4,T5,T6);
        T->type=3;
        list->next = head->next->next->next;
        LinkedListInsert(list, T);
}
 | WHILE C DO S{
	//printf("s->while do\n");
	head = list->next;
        T1 = createLeaf("WHILE");
        T2 = head->next->data;
        T3 = createLeaf("DO");
        T4 = head->data;
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("S", T1, T2, T3,T4,T5,T6);
        T->type=4;
        list->next = head->next->next;
        LinkedListInsert(list, T);
}
 ;

C: E GT E{
	//printf("c->e gt e\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf(">");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("C", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=1;
        LinkedListInsert(list, T);
}
 | E LT E{
	//printf("c->e lt e\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("<");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("C", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=2;
        LinkedListInsert(list, T);
}
 | E EQ E{
	//printf("c->e eq e\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("=");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("C", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=3;
        LinkedListInsert(list, T);
}
 | E GE E{
	//printf("c->e ge e\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf(">=");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("C", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=4;
        LinkedListInsert(list, T);
}
 | E LE E{
	//printf("c->e le e\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("<=");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("C", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=5;
        LinkedListInsert(list, T);
}
 | E NEQ E{
	//printf("c->e neq e\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("<>");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("C", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=6;
        LinkedListInsert(list, T);
}
 ;

E: E ADD T{
	//printf("e->e add t\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("+");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("E", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=1;
        LinkedListInsert(list, T);
}
 | E SUB T{
	//printf("e->e sub t\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("-");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("E", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=2;
        LinkedListInsert(list, T);
}
 | T{
	//printf("e->t\n");
	head = list->next;
        T1 = head->data;
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("E", T1, T2, T3,T4,T5,T6);
        list->next = head->next;
        T->type=3;
        LinkedListInsert(list, T);
}
 ;

T: T MUL F{
	//printf("t->t mul f\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("*");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("T", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=1;
        LinkedListInsert(list, T);
}
 | T DIV F{
	//printf("t->t div f\n");
	head = list->next;
        T1 = head->next->data;
        T2 = createLeaf("/");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("T", T1, T2, T3,T4,T5,T6);
        list->next = head->next->next;
        T->type=2;
        LinkedListInsert(list, T);
}
 | F{
	//printf("t->f\n");
	head = list->next;
        T1 = head->data;
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("T", T1, T2, T3,T4,T5,T6);
        list->next = head->next;
        T->type=3;
        LinkedListInsert(list, T);
}
 ;

F: SLP E SRP{
	//printf("f->slp e srp\n");
	head = list->next;
        T1 = createLeaf("(");
        T2 = head->data;
        T3 = createLeaf(")");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        list->next = head->next;
        T->type=1;
        LinkedListInsert(list, T);
}
 | IDN{
	//printf("f->id\n");
	head = list->next;
        T1 = createLeaf($1);
        //T1->C1=createLeaf($1);
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        T->type=2;
        LinkedListInsert(list, T);
}
 | OCT{
	//printf("f->oct\n");
	head = list->next;
        T1 = createLeaf($1);
        //T1->C1=createLeaf($1);
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        T->type=3;
        LinkedListInsert(list, T);
}
 | DEC{	
	//printf("f->dec\n");
	head = list->next;
        T1 = createLeaf($1);
        //T1->C1=createLeaf($1);
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        T->type=4;
        LinkedListInsert(list, T);
}
 | HEX{
	//printf("f->hex\n");
	head = list->next;
        T1 = createLeaf($1);
        //T1->C1=createLeaf($1);
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        T->type=5;
        LinkedListInsert(list, T);
}
 ;
%%

int main() {
    list = LinkedListInit();
  T = NULL, T1 = NULL, T2 = NULL, T3 = NULL,T4 = NULL, T5 = NULL,T6=NULL;
    yyin=fopen("testin.c","r");
    yyout=fopen("testout.txt","w");
    yyparse();
    return 0;
}
int yywrap(){
	return 1;
}
void yyerror(char* msg) {
    printf("Syntax error: %s\n", msg);
}

