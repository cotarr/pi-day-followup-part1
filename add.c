// compile to run
// gcc -g -o add add.c

// compile to assembly language
// gcc -S -o add.s add.c

// assemble to object module with listing
// as -g -o add.o add.s -a=add.lst

#include <stdio.h>

int main() {

  int x;
  int y;
  int z;

  x = 3;
  y = 4;
  z = x + y;

  printf("%d\n",z);

  return 0;
}
