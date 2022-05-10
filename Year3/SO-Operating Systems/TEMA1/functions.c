
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "debug.h"
#include "hash.h"
#include "utils.h"
#include "functions.h"

//Allocate and create hashtable
Hashtable *create_new_HashT(unsigned int dimension)
{
	Hashtable *hashT;
	unsigned int i = 0;
	//memory allocation for hashmap
	hashT = malloc(sizeof(Hashtable));
	die_error(dimension < 1, "hash_size is not valid");
	/* memory allocation for buckets */
	hashT->buckets = calloc(dimension, sizeof(Nod *));
	/* Allocated initial nodes */
	while (i < dimension) {
		hashT->buckets[i] = NULL;
		i++;
	}

	hashT->dimension = dimension;

	return hashT;
}

//Add item in hashtable
int add_in_Hash(Hashtable *hashT, char *token)
{
	Nod *new_node, *node;
	Nod *temp_node = NULL;
	int nod_position = hash(token, hashT->dimension);
	char *data;
	//allocate data
	data = malloc(strlen(token) + 1);
	strcpy(data, token);
	/* get node from bucket */
	node = hashT->buckets[nod_position];
	new_node = malloc(sizeof(Nod));
	new_node->next = NULL;
	new_node->tok = data;

	//check if the node is firs element add to the end
	if (node == NULL) {
		hashT->buckets[nod_position] = new_node;
		return 0;
	}
	/* Check for duplicates */
	for (; node != NULL;) {
		if (strcmp(token, node->tok) == 0) {
			/* token already exists */
			return 0;
		}
		temp_node = node;
		node = node->next;
	}


	/* add new_node to the list end */
	if (temp_node == NULL)
		hashT->buckets[nod_position] = new_node;
	else
		temp_node->next = new_node;
	return 0;
}
//Remove item from hastable
int remove_from_Hash(Hashtable *hashT, char *token)
{
	/* Compute Index */
	unsigned int position = hash(token, hashT->dimension);
	Nod *aux_node = NULL;
	Nod *nod = hashT->buckets[position];
	/* chech the if we have elements in the bucket */
	if (nod == NULL)
		return -1;
	/* Search for token to remove */
	while (nod != NULL) {
		while (strcmp(nod->tok, token) == 0) {
			free(nod->tok);
			if (aux_node == NULL)
				hashT->buckets[position] = nod->next;
			else
				aux_node->next = nod->next;
			free(nod);
			return 1;
		}
		aux_node = nod;
		nod = nod->next;
	}
	/* token was not found */
	return 0;
}
void delete(Nod *node)
{
	Nod *aux_node = NULL;
	//delete the node
	while (node != NULL) {
		aux_node = node;
		node = node->next;
		aux_node->next = NULL;
		free(aux_node->tok);
		free(aux_node);
	}

}
//Clear hashtable
int clear_Hash(Hashtable *hashT)
{
	int i;
	Nod *node;
	int hash_size = hashT->dimension;
	//iterate throw all the buckets
	for (i = 0; i < hash_size; i++) {
		node = hashT->buckets[i];
		/* Free each bucket */
		delete(node);
		hashT->buckets[i] = NULL;
	}
	return 0;
}

//Find the intem in hashtable if the item exist
//print true/false in file or stdout(is no file)
int find_in_Hash(Hashtable *hashT, char *token, char *out)
{
	FILE *file;
	unsigned int position = hash(token, hashT->dimension);
	Nod *node = hashT->buckets[position];
	int gasit = 0;
	//search token from the list
	while (node != NULL) {
		if (strcmp(node->tok, token) == 0)
			gasit = 1;
		node = node->next;
	}
	/* Check if NO file was supplied */
	if (out != NULL) {
		file = fopen(out, "a");
		die_error(file < 0, "Can't open the file");
		if (gasit)
			fprintf(file, "True\n");
		else
			fprintf(file, "False\n");
		fclose(file);
	} else {
		if (gasit)
			printf("True\n");
		else
			printf("False\n");
	}
	return 1;
}

//print bucket at STDIN or in file
int print_Hash_bucket(Hashtable *hash, unsigned int position, char *out)
{

	Nod *nod;
	FILE *file;

	/* Open file for writing */
	if (out != NULL)
		file = fopen(out, "a");
	nod = hash->buckets[position];
	while (nod != NULL) {
		if (out != NULL)
			fprintf(file, "%s ", nod->tok);
		else
			printf("%s ", nod->tok);
		nod = nod->next;
	}
	//Print bucket and close the file
	if (out == NULL)
		printf("\n");
	else {
		fprintf(file, "\n");
		fclose(file);
	}
	return 0;
}

// Prints whole hashtable at STDOUT or in FILE
int print_Hash(Hashtable *hash, char *out)
{
	Nod *node;
	FILE *file;
	int i;
	int hash_size = hash->dimension;
	/* Open file for writing */
	if (out != NULL)
		file = fopen(out, "a");
	for (i = 0; i < hash_size; i++) {
		node = hash->buckets[i];
		/* Skip empty buckets */
		if (node == NULL)
			continue;
		for (; node != NULL;) {
			if (out != NULL)
				fprintf(file, "%s ", node->tok);
			else
				printf("%s ", node->tok);
			node = node->next;
		}

		//print \n and close the file
		if (out != NULL)
			fprintf(file, "\n");
		else
			printf("\n");
	}
	//close the file if is still opened
	if (out != NULL)
		fclose(file);

	return 1;
}
//Resize hashtable to double size
int Double_resize_Hash(Hashtable *hash)
{
	Hashtable *double_hash;
	int i = 0;
	Nod *nod;
	int s;
	int hash_size = hash->dimension;
	int double_size = hash->dimension * 2;

	double_hash = create_new_HashT(double_size);
	die_error(double_hash == NULL, "Can not allocate");

	/* Iterate trough old hash and add at new hash */
	while (i < hash_size) {
		nod = hash->buckets[i];
		while (nod != NULL) {
			s = add_in_Hash(double_hash, nod->tok);
			nod = nod->next;
			die_error(s < 0, "error in adding a node");
		}
		i++;
	}
	s = clear_Hash(hash);
	//free old hash
	free(hash->buckets);
	//replace new pointers
	hash->buckets = double_hash->buckets;
	hash->dimension = double_hash->dimension;
	die_error(s < 0, "Error in clear_Hash");
	return 0;
}

//Create table with half size and add data from the initial table
int Halve_resize_Hash(Hashtable *hash)
{
	Hashtable *halve_hash;
	unsigned int i = 0;
	unsigned int s;
	int hash_size = hash->dimension;
	int halve_size = hash->dimension/2;
	Nod *nod;
	//create new hashtable with dimension/2
	halve_hash = create_new_HashT(halve_size);
	die_error(halve_hash == NULL, "Can not allocate");
	/* Iterate trough old hash and add at new hash */
	while (i < hash_size) {
		nod = hash->buckets[i];
		while (nod != NULL) {
			s = add_in_Hash(halve_hash, nod->tok);
			nod = nod->next;
			die_error(s < 0, "Error in add_in_Hash");

		}
		i++;
	}
	s = clear_Hash(hash);
	//free old hash
	free(hash->buckets);

	//replace new pointers
	hash->dimension = halve_hash->dimension;
	hash->buckets = halve_hash->buckets;
	die_error(s < 0, "Error in clear_Hash");
	return 0;
}


