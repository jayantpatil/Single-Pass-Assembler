%{

 #include "y.tab.h"
 #include "assem.h"
%}

letter[a-zA-Z]
digit[0-9]
%%
START         {return(STA);}
ORIGIN        {return(ORG);}
LTORG          {return(LTO);}

EQU          {return(EQU);}
END          {return(END);}

MOV          {yylval.ival=1;return(OP);}
ADD          {yylval.ival=2;return(OP);}
SUB          {yylval.ival=3;return(OP);}
AND          {yylval.ival=4;return(OP);}
OR          {yylval.ival=5;return(OP);}
NOT          {yylval.ival=6;return(NOT);}

MOVER        {yylval.ival=7;return(MOV);}
MOVEM         {yylval.ival=8;return(MOV);}
JMP           {yylval.ival=9;return(JMP);}
JMPC          {yylval.ival=10;return(JMPC);}
MULT          { yylval.ival=11;return(OP);}

DS            {yylval.ival=1;return(DS);}
DC          {yylval.ival=2;return(DC);}

AREG  	{yylval.ival=1; return(REG);}
BREG    	{yylval.ival=2; return(REG);}
CREG		{yylval.ival=3; return(REG);}
DREG		{yylval.ival=4; return(REG);}


LT              {yylval.ival=1; return(COND);}

GT              {yylval.ival=2; return(COND);}
GE              {yylval.ival=3; return(COND);}
LE               {yylval.ival=4; return(COND);}
EQ              {yylval.ival=5; return(COND);}
NE              {yylval.ival=6; return(COND);}

[a-zA-Z][a-zA-Z0-9]* 	{yylval.str=strdup(yytext); return(SYM);}
{digit}+ 	{yylval.ival=atoi(yytext); return(NUM);}

\n              return(yytext[0]);
[\t|" "]          ;



.             { return(yytext[0]);}


%%
