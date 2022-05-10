#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

//Aici se pastreaza terminii primiti ca input 
typedef struct termeni {
	int *type;	//tip termen
	char **termen;	//vector de termeni
	int n;		//Nr total de termeni
	int nr;		

} termeni;

//Pentru codificare caractere 
typedef struct aparitii_caractere {
	char c;
	int nr;	//Numarul de aparitii ale caracterului c
} aparitii_caractere;

//Pentru task 3, impartirea mesajului codificat in n mesaje 
typedef struct mesaje3 {
	char* mesaj;
	double complexitate;
}mesaje3;

void read_and_count(termeni*, int *, int *, int *, int *);
void codificare(char **, termeni *, int);
char* codificare_caracter(char*, char*);
char* codificare_numar(char*, char*);
char* codificare_cuvant(char*, char*);
int get_nr_aparitii(char *, aparitii_caractere*);
char get_max(aparitii_caractere *, int);
char get_min(aparitii_caractere *, int);
double max_number(char **, int);
double min_number(char **, int);
int greatest_divisor(int);
mesaje3* impartire_mesaj(char*, int);
mesaje3* complexitate(mesaje3 *, int);
mesaje3* sortare(mesaje3 *, int);
char* reasamblare(mesaje3 *, int, char*);




