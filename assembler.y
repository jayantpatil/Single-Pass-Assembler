%{
#include<stdio.h>
#include"assem.h"
#define LIT 0
#define SYMB 1
extern FILE * yyin;
int yylex();
int lc=0;
int nlit=0;
int symp=0;
int litp=0;
int tiip=0;
int iip;
int pooltab[30];
int poolp=0;
int i;
int j;

%}

%union{
int ival;
char * str;;
}

%token <ival>   COND  REG OP NOT MOV JMP JMPC DC DS NUM 
%token STA LTO ORG END EQU
%token <str>   SYM
%%

final : start '\n'  prog  end { 
                      
                         YYACCEPT;
                        }
      ;

prog  : prog stat  '\n'
      | stat  '\n'    
       
      ;

stat : label op
     |op
     |ad
     |dd 
     |'\n'
     ;

ad : ltorg        { for(i=pooltab[poolp] ;i<litp;++i)
                    {  
                        lit[i].loc=lc;
                    
                        insert(0,0,0,lit[i].no);
                          ++lc;
                    }
                    poolp++;
                    pooltab[poolp]=litp;
                  }   
     

        |equ    
  |org
	;

dd	:ds |dc
	;

op	: OP REG ',' REG  {insert(1,$1,$2,$4);
                            ++lc;
                          }  
	

        | MOV  REG ',' '=' NUM  {  
                                  if($1==7)
                                  {
                                  lit[litp].no=$5;
                                  litp++;
                                  tii[tiip].loc=lc;
                                  tii[tiip].index=litp-1;
                                  tii[tiip].lit_sym=LIT;
                                  tiip++;
                                  insert(1,$1,$2,-1);
                                  lc++;
                                  }

				  else {
                                   printf("\nERROR>>Illegal use of instruction");
                               
				   return 1;
                                  }
                                }
                              
                            
         |NOT REG          { insert(1,$1,0,$2);
                            ++lc;
                          }

	|MOV REG ',' SYM  {   i=check($4);
                               
                             if(i==-1)
                               {
                                      sym[symp].name=strdup($4);
                                      sym[symp].loc=-1;
                                      symp++;
				      tii[tiip].loc=lc;
				      tii[tiip].index=symp-1;
 				      tii[tiip].lit_sym=SYMB;
                         	      tiip++;	
                                      insert(1,$1,$2,-1);
                         	      ++lc;
                          
                             }
                               else
				{
                                     insert(1,$1,$2,sym[i].loc);
					lc++;
                                }

			  }

                         


        

	|JMP SYM          {    
                                i= check($2);
                               if(i==-1)
                               {
                                      sym[symp].name=strdup($2);
                                      sym[symp].loc=-1;
                                      symp++;
				      tii[tiip].loc=lc;
				      tii[tiip].index=symp-1;
 				      tii[tiip].lit_sym=SYMB;
                         	      tiip++;	
                                      insert(1,$1,0,-1);
                         	      ++lc;
                          
                             }
                               else
				{
                                     insert(1,$1,0,sym[i].loc);
					lc++;
                                }


                            }
                            



	|JMPC COND ','  SYM  
                              {  i= check($4);
                               
                               if(i==-1)
                               {
                                      sym[symp].name=strdup($4);
                                      sym[symp].loc=-1;
                                      symp++;
				      tii[tiip].loc=lc;
				      tii[tiip].index=symp-1;
 				      tii[tiip].lit_sym=SYMB;
                         	      tiip++;	
                                      insert(1,$1,$2,-1);
                         	      ++lc;

				}
                               else
				{
                                     insert(1,$1,$2,sym[i].loc);
					lc++;
                                }


                            }
           

	;                        

label	: SYM ':'     {
			 i=check($1);
			 
                         if(i==-1)
                         {
                             sym[symp].name=strdup($1);
			     sym[symp].size=1;
			     sym[symp].loc=lc;
			     symp++;
                             					
                           
                         } 
	
			else
                        {
                          sym[i].size=1;
			  sym[i].loc=lc;
                        }

		      }
     ;

ltorg	: LTO        
  	;

end	: END      {  
                    for(i=pooltab[poolp] ;i<litp;++i)
                    {   
                        lit[i].loc=lc;
			 insert(0,0,0,lit[i].no);
                                          
			 ++lc;
                        }
                    poolp++;
                    pooltab[poolp]=litp;
	
                    }
         ;

start	: STA NUM  { lc=$2;}
	;

org	: ORG NUM   { lc=$2;}
	;

equ	: SYM EQU SYM { i=check($3);
			sym[symp].name=strdup($1);
			sym[symp].loc=sym[i].loc;
			sym[symp].size=sym[i].loc;

			symp++;
			}

	| SYM EQU NUM  {  sym[symp].name=strdup($1);
			  sym[symp].loc=$3;
		          sym[symp].size=1;
                          symp++;
			}


	;

ds	: SYM DS NUM    {

                             i=check($1);
			     if(i==-1)
			     {   sym[symp].name=strdup($1);
                                 sym[symp].loc=lc;
                                 sym[symp].size=$3;
                                 symp++; 
				for(j=0;j<$3;++j)
				 { 
  					insert(0,0,0,0);
                                        lc++;
				 }

                             }

				else
				{  
                                   if(sym[i].loc!=-1)
                                   {
 					printf("\nError...Redeclaration of variable \" %s \" \n",$1 );
					return -1;
				   }
                                   sym[i].loc=lc;
				   sym[i].size=$3;

				   for(j=0;j<$3;++j)
				   {
  					insert(0,0,0,0);
					lc++;
				   }


                                 }

			}
                                  	
	;

dc	: SYM DC NUM    {
                                i=check($1);
				if(i==-1)
				{

				   sym[symp].name=strdup($1);
				   sym[symp].loc=lc;
				   sym[symp].size=1;
				   symp++;

				   insert(0,1,0,$3);
				   

				   lc++;
                                }


                                else
				{

					if(sym[i].loc!=-1)
					{
						printf("\nError...Redeclaration of variable \" %s \" \n ",$1 );
						return -1;
                                        }

                                
				  sym[i].loc=lc;
				  sym[i].size=1;
				  insert(0,1,0,$3);
				  lc++;

				}


		       }
;
	

   
%%

void yyerror(char *s)
{

printf("\nThe instruction supposed to be at location %d is not recognized...Will not assemble further",lc);
exit(0);
} 


void insert(int type,int code,int op1,int op2)
{
inst[iip].loc=lc;
inst[iip].type=type;
inst[iip].code=code;
inst[iip].op1=op1;
inst[iip].op2=op2;
iip++;


}


int check(char * str)
{

int i;
for(i=0;i<symp;++i)
{

if(strcmp(str,sym[i].name)==0)
return i;

}




return -1;
}


int main(int argc,char * argv[])
{
int loc,value,i,j,f;
pooltab[0]=0;
 
printf("File %s  is being processed\n",argv[1]);
FILE * f1 = fopen(argv[1],"r");


if(argv[1]!=NULL)
{
yyin=f1;

do
{

i=yyparse();
}while(!feof(f1));

}

else
i=yyparse();

if(i!=-1)
{
for(i=0;i<tiip;++i)
{

loc=tii[i].loc;

for(j=0;j<iip;++j)
{

  if(inst[j].loc==loc)
  {
      if(tii[i].lit_sym==LIT)
 	{
		inst[j].op2=lit[tii[i].index].loc;

        }

        else
	{
           inst[j].op2=sym[tii[i].index].loc;
        }

      break;
  }


}
  
}


f=0;
for(i=0;i<symp;++i)
{

if(sym[i].loc==-1)
{
   printf("The symbol %s has not been declared\n",sym[i].name);
   f=1;
}

}

if(f==1)
exit(0);

 printf("\nProgram assembled successfully");

printf("\n\nLOCATION    TYPE    OPCODE    OPERAND1    OPERAND2\n"); 
for(i=0;i<iip;++i)
printf(" %7d %7d %9d %10d %10d \n",inst[i].loc,inst[i].type,inst[i].code,inst[i].op1,inst[i].op2);
}
return 0;
}      
