struct instr
{

 int loc;
 int type;
 int code;
 int op1;
 int op2;

}inst[100];

struct symb
{
 
  char *  name;
  int size;
  int loc;
}sym[200];

struct littab
{
int no;

int loc;

}lit[100];


struct tiic
{
 
 int loc;
 int index;
 int lit_sym;

}tii[100];
