add: add.o
	ld -o add add.o

add.o: add.s
	as -g -o add.o add.s -a=add.lst
