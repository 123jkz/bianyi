#ifndef CP_H
#define CP_H

#include <stdio.h>
#include <string.h>
#include <malloc.h>

typedef struct listele//链表节点
{
    int instrno;//指令号
    struct listele *next;
}listele;

    listele* new_listele(int no)//新建链表节点
    {
        listele* p = (listele*)malloc(sizeof(listele));
        p->instrno = no;
        p->next = NULL;
        return p;
    }



typedef struct instrlist//跳转指令链表
{
    listele *first,*last;
}instrlist;

    instrlist* new_instrlist(int instrno)//将首尾节点初始化为同一个节点
    {
        instrlist* p = (instrlist*)malloc(sizeof(instrlist));
        p->first = p->last = new_listele(instrno);
        return p;
    }

    instrlist* merge(instrlist *list1, instrlist *list2)//合并2个指令链表
    {
        instrlist *p;
        if (list1 == NULL) p = list2;//list1空，返回list2
        else
        {
            if (list2!=NULL)
            {
                if (list1->last == NULL)//list1 last is NULL->list 1 is a empty list
                {
                    list1->first = list2->first;//copy list2 to list1
                    list1->last =list2->last;
                }else list1->last->next = list2->first;//link list2 to the last of list1
                list2->first = list2->last = NULL;
                free(list2);
            }
            p = list1;//list2空，返回list1
        }
        return p;
    }

typedef struct node
{
     instrlist *truelist, *falselist, *nextlist;//真时跳转,假时跳转,顺序执行的下一条
    char addr[256];//存储变量名，操作符，指令编号等
    char lexeme[256];//存储词元
    char oper[3];//存储操作符
    int instr;//存储指令编号
}node;

    int filloperator(node *dst, char *src)
    {
        strcpy(dst->oper, src);
        return 0;
    }    
    int filllexeme(node *dst, char *yytext)
    {
        strcpy(dst->lexeme, yytext);
        return 0;
    }
    int copyaddr(node *dst, char *src)
    {
        strcpy(dst->addr, src);
        return 0;
    }
    int new_temp(node *dst, int index)
    {
        sprintf(dst->addr, "t%d", index);
        return 0;
    }
    int copyaddr_fromnode(node *dst, node src)
    {
        strcpy(dst->addr, src.addr);
        return 0;
    }

typedef struct codelist
{
      int linecnt, capacity;
    int temp_index;//表示临时变量索引的整数
    char **code;//用于存储一系列的代码行
}codelist;

      codelist* newcodelist()//新建codelist
    {
        codelist* p = (codelist*)malloc(sizeof(codelist));
        p->linecnt = 0;
        p->capacity = 1024;
        p->temp_index = 0;
        p->code = (char**)malloc(sizeof(char*)*1024);
        return p;
    }

    int get_temp_index(codelist* dst)//生成临时变量的名称或标识符
    {
        return dst->temp_index++;
    }

    int nextinstr(codelist *dst) { return dst->linecnt; }
    
      int Gen(codelist *dst, char *str)//向 codelist 结构体中添加生成的中间代码
    {

        if (dst->linecnt >= dst->capacity)//容量不够：扩容
        {
            dst->capacity += 1024;
            dst->code = (char**)realloc(dst->code, sizeof(char*)*dst->capacity);
            if (dst->code == NULL)
            {
                printf("short of memeory\n");
                return 0;
            }
        }
        dst->code[dst->linecnt] = (char*)malloc(strlen(str)+20);     //申请一个内存空间存放中间字符串

              strcpy(dst->code[dst->linecnt], str);                    //字符串复制

              dst->linecnt++;                                  //行号加1

        return 0;
    }

    char tmp[1024];

    int gen_goto_blank(codelist *dst)//生成临时goto
    {
        sprintf(tmp, "goto");
        Gen(dst, tmp);
        return 0;
    }

    int gen_goto(codelist *dst, int instrno)//生成确定goto
    {
        sprintf(tmp, "goto %d", instrno);
        Gen(dst, tmp);
        return 0;
    }

    int gen_if(codelist *dst, node left, char* op, node right)//生成 E relop E类型语句
    {
        sprintf(tmp, "if %s %s %s goto", left.addr, op, right.addr);
        Gen(dst, tmp);
        return 0;
    }

    int gen_1addr(codelist *dst, node left, char* op)//生成1地址代码语句
    {
        sprintf(tmp, "%s %s", left.addr, op);
        Gen(dst, tmp);
        return 0;
    }

    int gen_2addr(codelist *dst, node left, char* op, node right)//生成2地址代码语句
    {
        sprintf(tmp, "%s = %s %s", left.addr, op, right.addr);
        Gen(dst, tmp);
        return 0;
    }

    int gen_3addr(codelist *dst, node left, node op1, char* op, node op2)//生成3地址代码语句
    {
        sprintf(tmp, "%s = %s %s %s", left.addr, op1.addr, op, op2.addr);
        Gen(dst, tmp);
        return 0;
    }

    int gen_assignment(codelist *dst, node left, node right)//生成赋值语句
    {
        gen_2addr(dst, left, "", right);
        return 0;
    }

    int backpatch(codelist *dst, instrlist *list, int instrno)//将指令序列中的某些位置标记为特定的指令号。
    {
        if (list!=NULL)
        {
            listele *p=list->first;
            char tmp[20];
        
            sprintf(tmp, " %d", instrno);
            while (p!=NULL)//找到所有要回填的
            {
                if (p->instrno<dst->linecnt)
                    strcat(dst->code[p->instrno], tmp);
                p=p->next;
            }
        }
        return 0;
    }

    int print(codelist* dst)
    {
        int i;
        
        for (i=0; i < dst->linecnt; i++)
            printf("%5d:  %s\n", i, dst->code[i]);
        return 0;
    }

#endif