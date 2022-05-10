# Tema 1 SO - Makefile
# Digori Gheorghe 331CC
CC = cl
EXEC = tema1
CFLAGS = /W3 /nologo /D_CRT_SECURE_NO_DEPRECATE/DWIN
build:  $(EXEC).obj  functions.obj
	link /nologo /out:$(EXEC).exe $(EXEC).obj functions.obj hash.lib
tema1.obj:
	$(CC) $(CFLAGS) /Fo$(EXEC).obj /c $(EXEC).c
functii.obj:
	$(CC) $(CFLAGS) /Fofunctions.obj /c functions.c
clean:
	del *.obj *.exe
