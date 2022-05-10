
#include <stdio.h>
#include <stdint.h>
#include "hash.h"

typedef struct Nod {
	struct Nod *next;
	char *tok;
} Nod;

typedef struct Hashtable {
	Nod **buckets;
	unsigned int dimension;
} Hashtable;


void command_parser(Hashtable *hashT, char *buffer);

Hashtable *create_new_HashT(unsigned int dimension);

int add_in_Hash(Hashtable *hashT, char *token);

int remove_from_Hash(Hashtable *hashT, char *token);

int find_in_Hash(Hashtable *hashT, char *token, char *output_f);

int clear_Hash(Hashtable *hashT);

int print_Hash(Hashtable *hashT, char *output_f);

int print_Hash_bucket(Hashtable *hashT, unsigned int index, char *output_f);

int Halve_resize_Hash(Hashtable *hashT);

int Double_resize_Hash(Hashtable *hashT);
