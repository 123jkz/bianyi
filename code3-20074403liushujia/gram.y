%{
    #include "headfile.h"
    #define YYSTYPE node
    #include "gram.tab.h"
    #include "lex.yy.c"
    int yyerror();
    int yyerror(char* msg);
    extern int yylex();
    
    codelist* list;
 
%}


	%token IF THEN ELSE WHILE DO BEGIN_N END
	%token ID DEC OCT ILOCT HEX ILHEX 
	%token ADD SUB MUL DIV
	%token GT LT EQ GE LE NEQ SLP SRP SEMI

%left ADD SUB
%left MUL DIV

%%

P: L   { $$.nextlist = $1.nextlist; }
				  
 | L M P	    { backpatch(list, $1.nextlist, $2.instr);
                  $$.nextlist = $3.nextlist; }
 ;   

L: S SEMI  { }
 ;

S: ID EQ E	   { copyaddr(&$1, $1.lexeme);
				 gen_assignment(list, $1, $3); }

 | IF C THEN M S	{
					backpatch(list,$2.truelist,$4.instr);
					$$.nextlist = merge($2.falselist, $5.nextlist); 
					}

 | IF C THEN M S ELSE N M S   { backpatch(list, $2.truelist, $4.instr);
                                  backpatch(list, $2.falselist, $8.instr);
                                  $5.nextlist = merge($5.nextlist, $7.nextlist);
                                  $$.nextlist = merge($5.nextlist, $9.nextlist); }
 
 
 | WHILE M C DO M S		{ backpatch(list, $6.nextlist, $2.instr);
                          backpatch(list, $3.truelist, $5.instr);
                          $$.nextlist = $3.falselist;
                          gen_goto(list, $2.instr); }
						  					  						
 ;


C: E GT E		 { $$.truelist = new_instrlist(nextinstr(list));
                   $$.falselist = new_instrlist(nextinstr(list)+1);
                   gen_if(list, $1, $2.oper, $3);
                   gen_goto_blank(list); }

 | E LT E		{ $$.truelist = new_instrlist(nextinstr(list));
                   $$.falselist = new_instrlist(nextinstr(list)+1);
                   gen_if(list, $1, $2.oper, $3);
                   gen_goto_blank(list); }
				  
 | E EQ E		{ $$.truelist = new_instrlist(nextinstr(list));
                   $$.falselist = new_instrlist(nextinstr(list)+1);
                   gen_if(list, $1, $2.oper, $3);
                   gen_goto_blank(list); }
				  
 | E GE E	 	{ $$.truelist = new_instrlist(nextinstr(list));
                   $$.falselist = new_instrlist(nextinstr(list)+1);
                   gen_if(list, $1, $2.oper, $3);
                   gen_goto_blank(list); }
			
				 
 | E NEQ E		{ $$.truelist = new_instrlist(nextinstr(list));
                   $$.falselist = new_instrlist(nextinstr(list)+1);
                   gen_if(list, $1, $2.oper, $3);
                   gen_goto_blank(list); }
;

				  
E: E ADD T		 { new_temp(&$$, get_temp_index(list)); 
				   gen_3addr(list, $$, $1, "+", $3); }
				 
 | E SUB T		{ new_temp(&$$, get_temp_index(list)); 
				   gen_3addr(list, $$, $1, "-", $3); }
 
 
 | T			{ copyaddr_fromnode(&$$, $1); }
;
T: T MUL F		{ new_temp(&$$, get_temp_index(list)); 
				   gen_3addr(list, $$, $1, "*", $3); }	
				
 | T DIV F		{ new_temp(&$$, get_temp_index(list)); 
				   gen_3addr(list, $$, $1, "/", $3); }
				 
 | F			{ copyaddr_fromnode(&$$, $1); }
 ;

F: SLP E SRP	 { $$.truelist = $2.truelist; 
                  $$.falselist = $2.falselist; }
				 
 | ID			{ copyaddr(&$$, $1.lexeme); }
				 
 | OCT			{ copyaddr(&$$, $1.lexeme); }
				 
 | DEC			{ copyaddr(&$$, $1.lexeme); }
 
 | HEX			{ copyaddr(&$$, $1.lexeme); }
 
 ;
 
M:         { $$.instr = nextinstr(list); }
    ;

N:            { $$.nextlist = new_instrlist(nextinstr(list));
                  gen_goto_blank(list); }
    ;

%%

int yyerror(char* msg)
{
    printf("\nERROR with message: %s\n", msg);
    return 0;
}


int main() {
 list = newcodelist();
//申请一个内存空间给list 
// int linecnt, capacity;
// int temp_index;
// char **code;
    freopen("test.in", "rt+", stdin);
    freopen("test.out", "wt+", stdout);
//打开文件
    yyparse();
    print(list);
    fclose(stdin);
//关闭文件
    fclose(stdout);
//关闭文件
    return 0;
	
}


