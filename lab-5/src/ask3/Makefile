CC = gcc
CFLAGS = -Wall -g
OBJ = string_manipulation.o strcmp.o strcpy.o strcat.o strlen.o

all: string_manipulation.out

string_manipulation.o: string_manipulation.c
	$(CC) -c -o $@ $^ $(CFLAGS)

%.o: %.s
	$(CC) -c -o $@ $< $(CFLAGS)

string_manipulation.out: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm -f *.o *.out