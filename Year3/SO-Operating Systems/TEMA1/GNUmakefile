# Tema 1 SO - Makefile
# Digori Gheorghe 331CC
CC = gcc
CFLAGS = -Wall -g
LDFLAGS = -L.
EXEC = tema1

build: functions.c tema1.c
	$(CC) $(CFLAGS) -fPIC -c -o $(EXEC).o $(EXEC).c
	$(CC) $(CFLAGS) -fPIC -c -o functions.o functions.c
	$(CC) $(CFLAGS) $(EXEC).o functions.o -o $(EXEC) -lhash -L.

clean:
	rm -f *.o *~ $(Output)
