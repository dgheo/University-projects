
#include <stdio.h>
#include <string.h>
#include "debug.h"
#include "utils.h"
#include "functions.h"
#include <ctype.h>
#include "hash.h"
#define BUFFERSIZE 20000

char Buff[BUFFERSIZE];
Hashtable *hashT;


int isNumeric(const char *s)
{
	char *p;
	//check is string is a number or not
	if (s == NULL || *s == '\0' || isspace(*s))
		return 0;
	strtod(s, &p);
	return *p == '\0';
}


int main(int argc, char *argv[])
{
	FILE *file;
	int i;
	int result;
	//die if it is a bad imput comand
	die_error(argc <= 1, "Bad input");
	/* allocate hashtable */
	hashT = create_new_HashT(atoi(argv[1]));
	die_error(hashT == NULL, "Can't allocate");
	//parce comands from files
	if (argc >= 3) {
		i = 2;
		while (i < argc) {
			/* Open file */
			file = fopen(argv[i], "r");
			die_error(file == NULL, "Can't open the file");

			/* Read Command */
			while (fgets(Buff, BUFFERSIZE, file) != NULL) {
				/* Parse Command */
				command_parser(hashT, Buff);
				dprintf("%s\n", Buff);

			}
			/* Close file */
			i++;
			fclose(file);
		}
	/* parse comands from STDIN */
	} else {
		while (fgets(Buff, BUFFERSIZE, stdin) != NULL) {
			/* Parse Command */
			command_parser(hashT, Buff);
		}
	}

	/* memory free */
	result = clear_Hash(hashT);
	die_error(result < 0, "Table can not be cleared");
	free(hashT->buckets);
	free(hashT);
	return 0;
}
void command_parser(Hashtable *hashT, char *buffer)
{
	char *temp = NULL;
	int result;
	int i;
	char *command;
	char *took;
	char *received = buffer;
	//check if we received a command to use
	if (strcmp(received, "\n") == 0)
		return;
	command = strtok(received, "\n ");
	/* Parse remove command*/
	if (strcmp(command, "remove") == 0) {
		took = NULL;
		took = strtok(NULL, "\n ");
		result = remove_from_Hash(hashT, took);
	}
	/* Parse add command*/
	else if (strcmp(command, "add") == 0) {
		command = strtok(NULL, "\n ");
		die_error(command == NULL, "Need more arguments");
		result = add_in_Hash(hashT, command);
		die_error(result < 0, "ADD Error");
	}

	/* parse find command*/
	else if (!strcmp(command, "find")) {
		command = strtok(NULL, "\n ");
		temp = strtok(NULL, "\n ");
		result = find_in_Hash(hashT, command, temp);
		die_error(result < 0, "FIND Error");
	}
    /* Parse print command*/
	else if (strcmp(command, "print") == 0) {
		//get file name
		temp = strtok(NULL, "\n ");
		result = print_Hash(hashT, temp);
		die_error(result < 0, "PRINT Error");
	}
	/* parse clear command */
	else if (strcmp(command, "clear") == 0) {
		result = clear_Hash(hashT);
		die_error(result < 0, "CLEAR ERROR");
	}

	/* parse print_bucket command */
	else if (strcmp(command, "print_bucket") == 0) {
		/* Get Index and File */
		command = strtok(NULL, "\n ");
		die_error((command == NULL || isNumeric(command) == 0), "Null");
		i = atoi(command);
		temp = strtok(NULL, "\n ");
		result = print_Hash_bucket(hashT, i, temp);
		die_error(result < 0, "print_bucket error");
	}

	/* Parse resize command*/
	else if (strcmp(command, "resize") == 0) {
		char *token;
		//read next comand and apeal resize function
		token = strtok(NULL, "\n ");
		if (strcmp(token, "halve") == 0) {
			result = Halve_resize_Hash(hashT);
			die_error(result < 0, "halve_resize error");
		} else if (strcmp(token, "double") == 0) {
			result = Double_resize_Hash(hashT);
			die_error(result < 0, "double_resize error");
		}
	} else
		die_error(1, "Invalid command");
}
