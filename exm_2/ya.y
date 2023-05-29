%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "lex.yy.c"
int yylex(void);
void yyerror(char*);
typedef char* ElemType; 
    typedef struct BiTNode{
        ElemType data;
        struct BiTNode *C1, *C2, *C3,*C4,*C5,*C6;
    }BiTNode, *BiTree;
 
    typedef struct Node{
        BiTNode *data;
        struct Node *next;
    }Node, *LinkedList;
 
    
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
		fprintf(yyout,"%s\n",T8->data);
		Index_print(T8->C1,l+1);
		Index_print(T8->C2,l+1);
		Index_print(T8->C3,l+1);
		Index_print(T8->C4,l+1);
		Index_print(T8->C5,l+1);
		Index_print(T8->C6,l+1);
		}
	}
}
    LinkedList list = NULL;
    LinkedList head = NULL;
    BiTree T, T1, T2, T3,T4,T5,T6;
%}

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
	%token DEC
	%token HEX
	%token OCT
	%token ILHEX
	%token ILOCT
	%token IDN
	%token END_OF_INPUT

%%
P: L   {printf("p_>l");}
 | L P	{printf("p_>lp");}
 ;   

L: S SEMI{
	//printf("p->l\n");
	head = list->next;
        T = head->data;
        fprintf(yyout,"Traverse BiTree:\n");
        //TraverseBiTree(T); 
        fprintf(yyout,"0 L\n");
        Index_print(T,1);
        fprintf(yyout," 1 SEMI\n");
}
 ;

S: IDN EQ E{
	//printf("s->id eq e\n");
	head = list->next;
        T1 = createLeaf("IDN");
        T2 = createLeaf("=");
        T3 = head->data;
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("S", T1, T2, T3,T4,T5,T6);
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
        LinkedListInsert(list, T);
}
 | IDN{
	//printf("f->id\n");
	head = list->next;
        T1 = createLeaf("IDN");
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        LinkedListInsert(list, T);
}
 | OCT{
	//printf("f->oct\n");
	head = list->next;
        T1 = createLeaf("OCT");
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        LinkedListInsert(list, T);
}
 | DEC{	
	//printf("f->dec\n");
	head = list->next;
        T1 = createLeaf("DEC");
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
        LinkedListInsert(list, T);
}
 | HEX{
	//printf("f->hex\n");
	head = list->next;
        T1 = createLeaf("HEX");
        T2 = createLeaf(" ");
        T3 = createLeaf(" ");
        T4 = createLeaf(" ");
        T5 = createLeaf(" ");
        T6 = createLeaf(" ");
        T = createTree("F", T1, T2, T3,T4,T5,T6);
        //list->next = head->next;
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

