
all: memdump memwrite memfill

clean:
	rm memdump memwrite memfill

memdump : memwrite.c
	gcc -o memdump memdump.c

memwrite: memwrite.c
	gcc -o memwrite memwrite.c

memfill: memfill.c
	gcc -o memfill memfill.c

	
