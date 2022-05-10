#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

//linia adn-ului implementata ca o
//lista dublu inlantuita
typedef struct nod {
	char name;
	struct nod * next;
	struct nod * prev;
	char snod;
}Nod;

//stiva in care pastrez comenzile
typedef struct stack {
	char *command;
	int nr_of_arguments;
	int linie;
	int bucla;
	int index;
	char nume;
	char snod;
	stack *next;
} stack;

//adn-ul cu liniile
typedef struct adn {
	Nod *linie1;
	Nod *linie2;
}adn;

//folosita pt undo
//pastreaza valorile si indicii
//nodului modificat
typedef struct modify {
	int bucla;
	int index;
	char snod;
	char nume;
	Nod *linie;
} modify;

//afiseaza comenzile din stiva
void printstack(stack *&s, char *file)
{
	stack *aux;
	aux = s;
	FILE *f = fopen(file, "a");
	if (aux == NULL) {
		fclose(f);
		return;
	}
	else {
		while (aux != NULL) {
			if (aux->next != NULL)
				fprintf(f, "%s ", aux->command);
			else
				fprintf(f, "%s\n", aux->command);
			aux = aux->next;
		}
	}
	fclose(f);
}

//pune o comanda cu argumentele ei in stiva
void push(stack *&s, char *command, int linie, int bucla, int index, char nume, char snod, int nr_of_arguments)
{
	stack *nou = (stack*)malloc(sizeof(stack));
	nou->command = (char*)malloc((strlen(command) + 1)*sizeof(char));
	strcpy(nou->command, command);
	nou->nr_of_arguments = nr_of_arguments;
	if (nr_of_arguments != 0) {
		//nou->arguments = (int*)malloc(nr_of_arguments*sizeof(int));
		//for (i = 0; i < nr_of_arguments; i++) {
			nou->linie = linie;
			nou->bucla = bucla;
			nou->index = index;
			nou->nume = nume;
			nou->snod = snod;
		//}
	}
	if (s == NULL) {
		nou->next = NULL;
		s = nou;
	}
	else {
		nou->next = s;
		s = nou;
	}
}

//scoate primul element sin stiva
void pop(stack *&s)
{
	if (s == NULL)
		return;
	stack *temp = s;
	s = s->next;
	free(temp->command);
	free(temp);
}

//initializeaza lista
void init(Nod *&list) {
	list = NULL;
}

//verifica daca e goala
bool isEmpty(Nod *&list) {
	return (list == NULL);
}

//insereaza element in lista
modify* insert(Nod *&list, int bucla, int index, char nume, char snod){
	Nod *aux;
	int prev_count;
	Nod *nou = (Nod*)malloc(sizeof(Nod));
	nou->name = nume;
	nou->snod = snod;
	modify *m = (modify*)malloc(sizeof(modify));
	//daca lista e nula
	if(list == NULL){
		nou->next = NULL;
		nou->prev = NULL;
		list = nou;
		//pastram valorile in m
		//pentru apelul functiei undo
		m->nume = list->name;
		m->snod = list->snod;
		m->bucla = 0;
		m->index = 1;
		return m;
	//daca e vorba de primul element
	} else if (index == 1 && bucla == 0) {
		nou->next = list;
		list->prev = nou;
		nou->prev = NULL;
		list = nou;
		m->nume = list->name;
		m->snod = list->snod;
		m->bucla = 0;
		m->index = 1;
		return m;
	}else {
		//initial pornim de la bucla 0 cu indexul 1
		int count = 1;
		aux = list;
		int count_bucla = 0;
		//cat timp nu am ajuns la capatul listei
		while (aux != NULL){
			//verificam daca nodul este snod pentru
			if (aux->snod == 'T') {
				prev_count = count;
				//count devine 0 si incrementam numarul de bucle
				count = 0;
				++count_bucla;
			}
			//daca am gasit bucla
			if (count_bucla == bucla) {
				if (count == index) {
					Nod *temp;
					//inseram elementul
					temp = aux->prev;
					nou->next = aux;
					aux->prev = nou;
					nou->prev = temp;
					temp->next = nou;
					m->nume = list->name;
					m->snod = list->snod;
					//daca nodul de inserat este snod
					//incrementam nr de bucle si m->index devine 0
					//pentru a putea in caz ca facem undo sa stergem elementul
					//de la pozita corespunzatoare
					if (snod == 'T') {
						m->bucla = count_bucla + 1;
						m->index = 0;
					} else {
						m->bucla = bucla;
						m->index = index;
					}
					return m;
				//daca trebuie adaugat la sfarsit
				} else if (count + 1 == index && aux->next == NULL){
					nou->next = NULL;
					nou->prev = aux;
					aux->next = nou;
					m->nume = list->name;
					m->snod = list->snod;
					if (snod == 'T') {
						m->bucla = count_bucla + 1;
						m->index = 0;
					} else {
						m->bucla = bucla;
						m->index = index;
					}
					return m;
				}
			//daca trebuie agaugat in bucla noua
			} else if (count_bucla + 1 == bucla && aux->next == NULL && index == 0) {
				nou->next = NULL;
				nou->prev = aux;
				aux->next = nou;
				m->nume = list->name;
				m->snod = list->snod;
				if (snod == 'T') {
					m->bucla = count_bucla + 1;
					m->index = 0;
				} else {
					m->bucla = bucla;
					m->index = index;
				}
				return m;
			}
			++count;
			aux = aux->next;
		}
	}
	return m;
}

//sterge un element din lista
modify *del(Nod *&list, int bucla, int index)
{
	Nod *aux;
	int prev_count = 0;
	modify *m = (modify*)malloc(sizeof(modify));
	if (isEmpty(list))
		return NULL;
	//daca e primul element si singurul
	if(bucla == 0 && index == 1 && list->next == NULL){
		list = NULL;
		//daca e primul element
	} else if (bucla == 0 && index == 1) {
		m->nume = list->name;
		m->snod = list->snod;
		m->bucla = 0;
		m->index = 1;
		list = list->next;
		list->prev = NULL;
	} else {
		int count = 1;
		int count_bucla = 0;
		aux = list;
		while (aux != NULL) {
			if (aux->snod == 'T') {
				++count_bucla;
				prev_count = count;
				count = 0;
			}
			//am gasit bucla
			if (count_bucla == bucla) {
				//am gasit indexul
				if (count == index) {
					if (aux->next != NULL) {
						m->nume = aux->name;
						m->snod = aux->snod;
						if (aux->snod == 'T') {
							m->bucla = count_bucla - 1;
							m->index = prev_count;
						} else {
							m->bucla = bucla;
							m->index = index;
						}
						Nod *temp = aux->next;
						aux->prev->next = temp;
						temp->prev = aux->prev;
						break;
					} else {
						//daca e ultimul element
						m->nume = aux->name;
						m->snod = aux->snod;
						if (aux->snod == 'T') {
							m->bucla = count_bucla - 1;
							m->index = prev_count;
						} else {
							m->bucla = bucla;
							m->index = index;
						}
						Nod *temp = aux->next;
						aux->next = NULL;
						free(temp);
						break;
					}
				}
			}
			aux = aux->next;
			++count;	
		}
	}
	return m;
}

//afisare lista
void pl(Nod *&list, char *filename)
{
	FILE *f = fopen(filename, "a");
	Nod *aux = list;
	while (aux != NULL) {
		if (aux->next != NULL) {
			if (aux->snod == 'F')
				fprintf(f, "%c ", aux->name);
			else
				fprintf(f, "%c* ", aux->name);
		} else {
			if (aux->snod == 'F')
				fprintf(f, "%c\n", aux->name);
			else
				fprintf(f, "%c*\n", aux->name);
		}
		aux = aux->next;
	}
	free(aux);
	fclose(f);
}

//afisare lista in ordine inversa
void pr(Nod *&list, char *filename)
{
	FILE *f = fopen(filename, "a");
	Nod *aux = list;
	while (aux->next != NULL)
		aux = aux->next;
	while (aux != NULL) {
		if (aux->prev != NULL) {
			if (aux->snod == 'F')
				fprintf(f, "%c ", aux->name);
			else
				fprintf(f, "%c* ", aux->name);
		} else {
			if (aux->snod == 'F')
				fprintf(f, "%c\n", aux->name);
			else
				fprintf(f, "%c*\n", aux->name);
		}
		aux = aux->prev;
	}
	free(aux);
	fclose(f);
}

//editeaza un element
modify *edit_element(Nod *&list, int bucla, int index, char nume, int snod)
{
	Nod *aux = list;
	int count = 1, prev_count = 1;
	int count_bucla = 0;
	modify *m = (modify*)malloc(sizeof(modify));
	while (aux != NULL) {
		if (count_bucla == bucla) {
			if (count == index) {
				m->nume = aux->name;
				m->snod = aux->snod;
				//daca schimbam valoarea snodului la una diferita
				//se va modifica si bucla si indexul
				//valorile originale trebuie pastrate pentru undo in
				//structura modify m
				if (aux->snod == 'T' && snod == 'F') {
					m->bucla = count_bucla - 1;
					m->index = prev_count;
				} else if (aux->snod == 'F' && snod == 'T') {
					m->bucla = count_bucla + 1;
					m->index = 0;
				}else {
					m->bucla = bucla;
					m->index = index;
				}
				aux->name = nume;
				aux->snod = snod;
				break;
			}
			++count;
			aux = aux->next;
		} else {
			aux = aux->next;
			//daca e snod
			if (aux->snod == 'T') {
				++count_bucla;
				prev_count = count;
				count = 0;
			}
		}
	}
	return m;
}

//inverseaza o lista
void reverse_sequence(Nod *&list)
{
	Nod *temp = NULL;
	Nod *current = list;
	while (current != NULL) {
		temp = current->prev;
		current->prev = current->next;
		current->next = temp;
		current = current->prev;
	}
	if (temp != NULL)
		list = temp->prev;
}

//insereaza element in adn la linia corespunzatoare
modify *ie(adn *&ADN, int linie, int bucla, int index, char nume, char snod)
{
	modify* old = (modify*)malloc(sizeof(modify));
	if (linie == 1)
		old = insert(ADN->linie1, bucla, index, nume, snod);
	else
		old = insert(ADN->linie2, bucla, index, nume, snod);
	return old;
}

//sterge element in adn la linia corespunzatoare
modify *de(adn *&ADN, int linie, int bucla, int index)
{
	modify* old = (modify*)malloc(sizeof(modify));
	if (linie == 1)
		old = del(ADN->linie1, bucla, index);
	else
		old = del(ADN->linie2, bucla, index);
	return old;
}

//modifica element in adn la linia corspunzatoare
modify* ee(adn *&ADN, int linie, int bucla, int index, char nume, char snod)
{
	modify* old_value = (modify*)malloc(sizeof(modify));
	if (linie == 1)
		old_value = edit_element(ADN->linie1, bucla, index, nume, snod);
	else
		old_value = edit_element(ADN->linie2, bucla, index, nume, snod);
	return old_value;
}

//verifica daca structura adn e corecta
void pv (adn *&ADN, char *filename) {
	int count_bucle1 = 0, count_bucle2 = 0, elements1 = 0, elements2 = 0, i = 0;
	Nod *aux = ADN->linie1;
	FILE *f = fopen(filename, "a");
	//obtine nr de bucle din prima linie
	while (aux != NULL) {
		if (aux->snod == 'T') {
			count_bucle1 += 1;
		}
		aux = aux->next;
	}
	aux = ADN->linie1;
	//obtine nr de elemente din fiecare bucla din prima linie
	int *count1 = (int*)malloc((count_bucle1+1)*sizeof(int));
	while (aux != NULL) {
		if (aux->snod == 'T') {
			count1[i] = elements1;
			++i;
			elements1 = 1;
		} else {
			elements1 += 1;
		}
		aux = aux->next;
	}

	aux = ADN->linie2;
	//obtine nr de bucle din a doua linie
	int *count2 = (int*)malloc((count_bucle1+1)*sizeof(int));
	i = 0;
	while (aux != NULL) {
		if (aux->snod == 'T') {
			count_bucle2 += 1;
		}
		aux = aux->next;
	}
	aux = ADN->linie2;
	//obtine nr de elemente din fiecare bucla
	while (aux != NULL) {
		if (aux->snod == 'T') {
			count2[i] = elements2;
			++i;
			elements2 = 1;
		} else {
			elements2 += 1;
		}
		aux = aux->next;
	}
	//verifica ca nr de bucle sa fie egal in ambele linii
	if (count_bucle1 != count_bucle2) {
		fprintf(f, "%s\n", "false");
		fclose(f);
		return;
	}
	//verifica daca nr de elemente din fiecare bucla din prima linie =
	//cu nr de elem din fiecare bucla din a doua linie
	for (i = 0; i < count_bucle1; i++) {
		if (count1[i] != count2[i]) {
			fprintf(f, "%s\n", "false");
			fclose(f);
			return;
		}
	}
	Nod *aux2 = ADN->linie2;
	aux = ADN->linie1;
	//verifica structura adn sa fie corecta
	while (aux != NULL && aux2 != NULL) {
		if (aux->name == 'A' && aux2->name != 'T') {
			fprintf(f, "%s\n", "false");
			fclose(f);
			return;
		} else if (aux->name == 'T' && aux2->name != 'A') {
			fprintf(f, "%s\n", "false");
			fclose(f);
			return;
		} else if (aux->name == 'C' && aux2->name != 'G') {
			fprintf(f, "%s\n", "false");
			fclose(f);
			return;
		} else if (aux->name == 'G' && aux2->name != 'C') {
			fprintf(f, "%s\n", "false");
			fclose(f);
			return;
		}
		aux = aux->next;
		aux2 = aux2->next;
	}
	fprintf(f, "%s\n", "true");
	fclose(f);
}

//face undo
void un(adn *&ADN, stack *&s)
{
	if (s == NULL)
		return;
	if (strcmp(s->command, "pv") == 0) {
		pop(s);
		return;
	}
	if (strcmp(s->command, "pl") == 0) {
		pop(s);
		return;
	}
	if (strcmp(s->command, "pr") == 0) {
		pop(s);
		return;
	}
	if (strcmp(s->command, "rs") == 0) {
		reverse_sequence(ADN->linie1);
		reverse_sequence(ADN->linie2);
		pop(s);
		return;
	}
	if (strcmp(s->command, "ie") == 0) {
		de(ADN, s->linie, s->bucla, s->index);
		pop(s);
		return;
	}
	if (strcmp(s->command, "de") == 0) {
		ie(ADN, s->linie, s->bucla, s->index, s->nume, s->snod);
		pop(s);
		return;
	}
	if (strcmp(s->command, "ee") == 0) {
		ee(ADN, s->linie, s->bucla, s->index, s->nume, s->snod);
		pop(s);
		return;
	}
	
}

//inverseaza liniile adn
void rs(adn *&ADN) {
	reverse_sequence(ADN->linie1);
	reverse_sequence(ADN->linie2);
}

//citeste din fisier cele 2 linii adn si le insereaza in structura adn
void read_adn(adn *&ADN, char *filename)
{
	FILE *f = fopen(filename, "r");
    char *code;
    int n = 0, i, index = 1;
    int next_line = 0;
    int c, bucla_count = 0;
    fseek(f, 0, SEEK_END);
    long f_size = ftell(f);
    fseek(f, 0, SEEK_SET);
    code = (char*)malloc((f_size+2)*sizeof(char));
    while ((c = fgetc(f)) != EOF) {
        code[n++] = (char)c;
    }
    code[n-1] = '\0';    
    for (i = 0; i < n-1; i++) {
    	if (code[i] == '\n') {
    		next_line = 1;
    		bucla_count = 0;
    		index = 1;
    		++i;
    	}
    	while (code[i] == ' ' || code[i] == '*')
    		++i;
    	if (code[i+1] != '*') {
    		if (next_line == 0) {
    			ie(ADN, 1, bucla_count, index, code[i], 'F');
    		}
    		else {
    			ie(ADN, 2, bucla_count, index, code[i], 'F');
    		}
    		++index;
    	} else {
    		index = 0;
    		++bucla_count;
    		if (next_line == 0) {
    			ie(ADN, 1, bucla_count, index, code[i], 'T');
    		}
    		else if (next_line == 1) {
    			ie(ADN, 2, bucla_count, index, code[i], 'T');
    		}
    		++index;
    	}
    }
	fclose(f);
}

//elibereaza memoria din stack
void free_mem_stack(stack *&s) {
	stack *aux = s;
	while (aux != NULL) {
		free(aux->command);
		aux = aux->next;
	}
	free(s);
}

//elibereaza structura adn
void free_mem_adn(adn *& ADN) {
	free(ADN->linie1);
	free(ADN->linie2);
	free(ADN);
}

//citire comenzi din fisier
int parse_command(adn *&ADN, stack *&s, char *buffer, char *filename)
{
	char command[10], numeout, snodout;
	int *arguments;
	int linie = 0, nr_of_arguments, bucla = 0, index = 0;
	modify *m = (modify*)malloc(sizeof(modify));
	//citim comanda in buffer
	sscanf(buffer, "%s", command);
	buffer += strlen(command) + 1;
	//daca e pl sau pr
	if (strcmp(command, "pl") == 0 || strcmp(command, "pr") == 0) {
		//citim linia
		sscanf(buffer, "%d", &linie);
		nr_of_arguments = 1;
		//punem pe stiva
		push(s, command, linie, bucla, index, numeout, snodout, nr_of_arguments);
		if (strcmp(command, "pl") == 0) {
			if (linie == 1)
				pl(ADN->linie1, filename);
			else pl(ADN->linie2, filename);
		} else if (strcmp(command, "pr") == 0) {
			if (linie == 1)
				pr(ADN->linie1, filename);
			else pr(ADN->linie2, filename);
		}
		//daca e rs
	} else if (strcmp(command, "rs") == 0) {
		nr_of_arguments = 0;
		//punem comanda pe stiva
		push(s, command, linie, bucla, index, numeout, snodout, nr_of_arguments);
		rs(ADN);
	//daca e insert
	} else if (strcmp(command, "ie") == 0) {
		nr_of_arguments = 5;
		arguments = (int*)malloc(nr_of_arguments*sizeof(int));
		sscanf(buffer, " %d %d %d", &arguments[0], &arguments[1], &arguments[2]);
		char name, snod;
		buffer += 6;
		sscanf(buffer, "%c", &name);
		buffer += 2;
		sscanf(buffer, "%c", &snod);
		//apelez insert
		m = ie(ADN, arguments[0], arguments[1], arguments[2], name, snod);
		//salvez bucla si indicele unde se afla acum elementul
		//pt ca in caz ca elementul este nod suprapus acestea se vor schimba
		arguments[1] = m->bucla;
		arguments[2] = m->index;
		//pun in stiva
		push(s, command, arguments[0], arguments[1], arguments[2], name, snod, nr_of_arguments);
		//daca e edit
	} else if (strcmp(command, "ee") == 0) {
		nr_of_arguments = 5;
		arguments = (int*)malloc(nr_of_arguments*sizeof(int));
		sscanf(buffer, " %d %d %d", &arguments[0], &arguments[1], &arguments[2]);
		buffer += 6;
		char name, snod;
		sscanf(buffer, "%c", &name);
		buffer += 2;
		sscanf(buffer, "%c", &snod);
		modify *old = (modify*)malloc(sizeof(modify));
		//editez adn
		old = ee(ADN, arguments[0], arguments[1], arguments[2], name, snod);
		//salvez bucla si indicele unde se afla acum elementul
		//pt ca in caz ca elementul este nod suprapus acestea se vor schimba
		arguments[1] = old->bucla;
		arguments[2] = old->index;
		//pun in stiva
		push(s, command, arguments[0], arguments[1], arguments[2], old->nume, old->snod, nr_of_arguments);
		//sterge element
	} else if (strcmp(command, "de") == 0) {
		nr_of_arguments = 5;
		arguments = (int*)malloc(nr_of_arguments*sizeof(int));
		sscanf(buffer, " %d %d %d", &arguments[0], &arguments[1], &arguments[2]);
		modify *old = (modify*)malloc(sizeof(modify));
		//sterg element
		old = de(ADN, arguments[0], arguments[1], arguments[2]);
		//salvez bucla si indicele unde se afla acum elementul
		//pt ca in caz ca elementul este nod suprapus acestea se vor schimba
		arguments[1] = old->bucla;
		arguments[2] = old->index;
		//pun pe stiva comanda
		push(s, command, arguments[0], arguments[1], arguments[2], old->nume, old->snod, nr_of_arguments);
		//daca e exit
	} else if (strcmp(command, "ex") == 0) {
		free_mem_stack(s);
		free_mem_adn(ADN);
		return 1;
	}
	//daca e undo
	else if (strcmp(command, "un") == 0) {
		un(ADN, s);
	//daca e printstack
	} else if (strcmp(command, "ps") == 0) {
		printstack(s, filename);
	//daca e pv
	} else if (strcmp(command, "pv") == 0) {
		nr_of_arguments = 0;
		pv(ADN, filename);
		push(s, command, linie, bucla, index, numeout, snodout, nr_of_arguments);
	}
	return 0;
}

//citeste din fisier comenzile linie cu linie
void read_command(adn *&ADN, stack *&s, char *filename, char *output_file)
{
	int i = 0;
	FILE *f = fopen(filename, "r");
	char *buffer = (char*)malloc(101*sizeof(char));
	while (fgets(buffer, 100, f)) {
		i = parse_command(ADN, s, buffer, output_file);
		if (i == 1)
			return;
	}
	fclose(f);
}

int main(int argc, char *argv[]){
	stack *s = NULL;
	if (argc < 4)
		return 0;
	adn *ADN = (adn*)malloc(sizeof(adn));
	init(ADN->linie1);
	init(ADN->linie2);
	read_adn(ADN, argv[1]);
	read_command(ADN, s, argv[2], argv[3]);
	return 0;
}
