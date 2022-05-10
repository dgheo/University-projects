#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

#define rootport 0
#define designated 1
#define blocked 2

//lista de noduri
typedef struct node {
	int value;
	int type;
	node *next;
} node;

//structura grafului
typedef struct graph {
	int nr_nodes;
	int rootbridge;
	node*** adjacency_matrix;
} graph;

//structura ce tine informatii despre switchuri
typedef struct switches{
	int nr;
	int priority;
	char mac[18];
	node *ports;
	switches *next;
} switches;

void show_bports(graph *&, FILE *);
void print_topology(graph *&, FILE *);

//adauga un switch la sfarsit in lista de structuri de tip switches
void addSwitch(switches *&s, int nr, int priority, char *mac) {
	switches *nou = (switches*)malloc(sizeof(switches));
	nou->ports = NULL;
	switches *temp;
	nou->nr = nr;
	nou->priority = priority;
	nou->next = NULL;
	strcpy(nou->mac, mac);
	if (s == NULL)
		s = nou;
	else {
		temp = s;
		while (temp->next != NULL)
			temp = temp->next;
		temp->next = nou;
	}
}

//adauga un nod intr-o lista de noduri
void addNode(node *&nod, int val, int type) {
	node *nou = (node*)malloc(sizeof(node));
	nou->next = NULL;
	nou->value = val;
	nou->type = type;
	if (nod == NULL)
		nod = nou;
	else {
		node *temp = nod;
		while (temp->next != NULL)
			temp = temp->next;
		temp->next = nou;
	}
}

//obtine rootbridgeul
graph* getRootBridge(switches *&s, graph *&g) {
	switches *temp = s;
	int min_priority = 5555555, ok = 0;
	char mac[18];
	//cat timp mai sunt elemente in lista de switchuri
	while (temp != NULL) {
		//alegem prioritatea minima
		if (temp->priority < min_priority)
			min_priority = temp->priority;
		temp = temp->next;
	}
	temp = s;
	while (temp != NULL) {
		//in cazul in care sunt mai multe switchuri cu aceeasi prioritate minima
		//obtinem si switchul cu mac-ul minim
		if (ok == 0 && min_priority == temp->priority) {
			strcpy(mac, temp->mac);
			ok = 1;
			g->rootbridge = temp->nr;
		}
		//gasim switchul cu mac-ul minim si prioritatea minima
		if (ok == 1 && min_priority == temp->priority) {
			if (strcmp(temp->mac, mac) < 0) {
				strcpy(mac, temp->mac);
				g->rootbridge = temp->nr;
			}
		}
		temp = temp->next;
	}
	return g;
}

//citim lista de switchuri din fisierul init
graph* readInit(char *filename, graph *&g, switches *&s) {
	int i, nr, priority;
	char mac[18];
	FILE *f = fopen(filename, "r");
	fscanf(f, "%d", &g->nr_nodes);
	for (i = 0; i < g->nr_nodes; i++) {
		fscanf(f, "%d %d %s\n", &nr, &priority, mac);
		addSwitch(s, nr, priority, mac);
	}
	g = getRootBridge(s, g);
	fclose(f);
	return g;
}

//parcurgem fisierul cu topologia
graph* ReadTopology(char *topology_file, graph *&g, switches *&s) {
	FILE *f = fopen(topology_file, "r");
	int switch1, switch2, port1, port2, tip_legatura, i, j;
	char buffer[100];
	//alocam memorie pentru matricea de adiacenta
	g->adjacency_matrix = (node***)malloc(g->nr_nodes*sizeof(node**));
	for (i = 0; i < g->nr_nodes; i++)
		g->adjacency_matrix[i] = (node**)malloc(g->nr_nodes*sizeof(node*));
	for (i = 0; i < g->nr_nodes; i++)
		for (j = 0; j < g->nr_nodes; j++)
			g->adjacency_matrix[i][j] = NULL;
	//parcurgem fisierul linie cu linie
	while (fgets(buffer, 100, f) != NULL) {
		sscanf(buffer, "%d %d %d %d %d", &switch1, &switch2, &port1, &port2, &tip_legatura);
		switches *temp = s;
		while(temp->nr != switch1)
			temp = temp->next;
		addNode(temp->ports, port1, -1);
		temp = s;
		while(temp->nr != switch2)
			temp = temp->next;
		addNode(temp->ports, port2, -1);
		//salvam valorile in matricea de adiacenta
		addNode(g->adjacency_matrix[switch1][switch2], tip_legatura, -1);
		addNode(g->adjacency_matrix[switch1][switch2], port1, -1);
		addNode(g->adjacency_matrix[switch1][switch2], port2, -1);
		addNode(g->adjacency_matrix[switch2][switch1], tip_legatura, -1);
		addNode(g->adjacency_matrix[switch2][switch1], port2, -1);
		addNode(g->adjacency_matrix[switch2][switch1], port1, -1);
	}
	fclose(f);
	return g;
}

//obtinem nodul cu distanta minima necesar algoritmului dijkstra
int minDistance(node *dist[], bool sptSet[], int nr_nodes, switches *&s)
{
   	int min = INT_MAX, min_index, cost, priority;
   	char mac[18];
    switches *temp = s;
   	for (int i = 0; i < nr_nodes; i++)
		//daca nodul nu a fost vizitat si distanta pana la el <= ca min
    	if (sptSet[i] == false && dist[i]->value <= min) {
    		//dada distanta e strict mai mica actualizam direct minimul
     		if (dist[i]->value < min) {
     			temp = s;
     			while (temp->nr != i)
     				temp = temp->next;
     			priority = temp->priority;
     			strcpy(mac, temp->mac);
				min = dist[i]->value, min_index = i;
			}
			//daca e egala comparam prioritatile
			else if (dist[i]->value == min) {
				temp = s;
				while (temp->nr != i)
     				temp = temp->next;
     			if (temp->priority < priority) {
     				priority = temp->priority;
	    	 		strcpy(mac, temp->mac);
					min = dist[i]->value, min_index = i;
     			}
     			//daca prioritatile sunt egale comparam mac-ul
     			else if (temp->priority == priority) {
     				if (strcmp(temp->mac, mac) < 0) {
     					priority = temp->priority;
	    	 			strcpy(mac, temp->mac);
						min = dist[i]->value, min_index = i;
     				}
     			}
			}
     	}
   	return min_index;
}	
 
// afiseaza rootporturile
int printSolution(node *dist[], int nr_nodes, graph *&g, FILE *f, switches *&s, int no_print) {
	node *temp, *aux;
	switches *temp2;
	char *str = "RP: ";
	if (no_print == 0)
		fprintf(f, "%s", str);
	for (int i = 0; i < nr_nodes; i++) {
		temp = dist[i];
		//obtinem nodurile si porturile acestora pt care
		//exista distanta minima de la rootbridge la acestea
		if (i != g->rootbridge) {
			if (temp != NULL)
				while (temp->next != NULL) {
					temp = temp->next;
				}
			temp2 = s;
			while (temp2->nr != i)
				temp2 = temp2->next;
			aux = temp2->ports;
			while (aux->value != temp->value)
				aux = aux->next;
			aux->type = 0;
			//le afisam
			if (no_print == 0) {
				if (i == nr_nodes - 1) {
					fprintf(f, "%d(%d)\n", i, temp->value);
				}
				else
					fprintf(f, "%d(%d) ", i, temp->value);
			}
		} else {
			temp2 = s;
			while (temp2->nr != i)
				temp2 = temp2->next;
			aux = temp2->ports;
			while (aux != NULL) {
				aux->type = 1;
				aux = aux->next;
			}
		}
	}
}

//adauga in ordine crescatoare elementele in lista
//folosita pentru a afisa porturile blocked ale nodurilor in cazul in care
//acestea au mai multe blocked ports
void addPort_order(node *&list, int val) {
	node *temp = list;
	node *nou = (node*)malloc(sizeof(node));
	nou->next = NULL;
	nou->value = val;
	if (list == NULL) {
		list = nou;
		return;
	}else if (list->next == NULL) {
		if (val < list->value) {
			nou->next = list;
			list = nou;
		}
		else {
			list->next = nou;
		}
	} else {
		while (temp->next != NULL) {
			if (val > temp->next->value)
				temp = temp->next;
			else {
				node *aux = temp->next;
				temp->next = nou;
				nou->next = aux;
				return;
			}
		}
		temp->next = nou;
	}
}

//afiseaza porturile blocate
void show_bports(graph *&g, FILE *f) {
	int i, j, nr_blocked_ports = 0, k = 0;
	node *temp, *list = NULL;
	char *s = "BP:";
	//obtinem numarul de blocke ports
	for (i = 0; i < g->nr_nodes; i++) {
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			if (temp != NULL) {
				temp = temp->next;
				if (temp->type == 2) {
					nr_blocked_ports++;
				}
			}
		}
	}
	//daca e 0 afisam doar BP:
	if (nr_blocked_ports == 0)
		fprintf(f, "%s\n", s);
	else
		fprintf(f, "%s ", s);
	for (i = 0; i < g->nr_nodes; i++) {
		list = NULL;
		//adaugam porturile in lista
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			if (temp != NULL) {
				temp = temp->next;
				if (temp->type == 2)
					addPort_order(list, temp->value);					
			}
		}
		if (list != NULL) {
			node *aux;
			aux = list;
			//afisam porturile blocate ale fiecarui nod in ordine
			if (nr_blocked_ports == 1)
				fprintf(f, "%d(%d)\n", i, aux->value);
			else {
				while (aux != NULL) {
					k++;
					if (k < nr_blocked_ports)
						fprintf(f, "%d(%d) ", i, aux->value);
					else
						fprintf(f, "%d(%d)\n", i, aux->value);
					aux = aux->next;
				}
			}
		}
	}
}

//obtine tipul porturilor - designated, blocked
graph* edit_ports(switches *&s, graph *&g, node *dist[], int write, FILE *f) {
	switches *sw, *sw2;
	node *temp, *temp2;
	int i, j, l = 0, porti, portj;
	for (i = 0; i < g->nr_nodes; i++) {
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			l++;
			if (temp != NULL) {
				temp = temp->next;
				//obtinem numarul portului din structura de tip switches
				sw = s;
				while (sw->nr != i)
					sw = sw->next;
				//folosind structura swithces obtinem porturile nodului cautat
				temp2 = sw->ports;
				//facem acest lucru pentru ambele switchuri i si j
				while (temp2->value != temp->value)
					temp2 = temp2->next;
				temp->type = temp2->type;
				temp = temp->next;
				sw = s;
				while (sw->nr != j)
					sw = sw->next;
				temp2 = sw->ports;
				while (temp2->value != temp->value)
					temp2 = temp2->next;
				temp->type = temp2->type;
			}
		}
	}
	for (i = 0; i < g->nr_nodes; i++) {
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			if (temp != NULL) {
				temp = temp->next;
				//acolo unde exista rootport celalt pot al legaturii va fi designated
				if (temp->type == 0 && temp->next->type == -1)
					temp->next->type = 1;
				if (temp->type == -1 && temp->next->type == 0)
					temp->type = 1;
			}
		}
	}
	for (i = 0; i < g->nr_nodes; i++) {
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			if (temp != NULL) {
				temp = temp->next;
				//daca ambele sunt necunocute
				if (temp->type == -1 && temp->next->type == -1) {
					//obtinem in functie de valoare porturile designated si blocked
					if (dist[i]->value < dist[j]->value) {
						temp->next->type = 2;
						temp->type = 1;
					}
					else if (dist[i]->value > dist[j]->value) {
						temp->type = 2;
						temp->next->type = 1;
					}
					else {
						sw = s;
						sw2 = s;
						while (sw->nr != temp->value)
							sw = sw->next;
						while (sw2->nr != temp->next->value)
							sw2 = sw2->next;
						if (sw->priority < sw2->priority) {
							temp->next->type = 2;
							temp->type = 1;
						}
						//daca au aceeasi val atunci in functie de prioritate
						else if (sw->priority > sw2->priority) {
							temp->type = 2;
							temp->next->type = 1;
						}
						else {
							//si mac in cazul egalitatii prioritatilor
							if (strcmp(sw->mac, sw2->mac) < 0) {
								temp->next->type = 2;
								temp->type = 1;
							}
							else {
								temp->type = 2;
								temp->next->type = 1;
							}
						}
					}
				}
			}
		}
	}
	for (i = 0; i < g->nr_nodes; i++) {
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			if (temp != NULL) {
				temp = temp->next;
				//daca un port e designated celalt e blocked
				if (temp->type == -1 && temp->next->type == 1)
					temp->type = 2;
				if (temp->type == 1 && temp->next->type == -1)
					temp->next->type = 2;
			}
		}
	}
	//daca se doreste afisarea blocked porturilor
	if (write == 1)
		show_bports(g, f);
	//daca se doreste afisarea topologiei
	else if (write == 2)
		print_topology(g, f);
	return g;
}

//varianta modificata a algoritmului dijkstra
graph* getRootPorts(char *out, graph *&g, switches *&s, FILE *f, int write, int src, int dst) {
	node *dist[g->nr_nodes];
	int cost;
	bool sptSet[g->nr_nodes];
	//initializam vectorul de distante si de noduri vizitate
	for (int i = 0; i < g->nr_nodes; i++) {
		dist[i] = NULL;
		addNode(dist[i], INT_MAX, -1);
		sptSet[i] = false;
	}
	//distanta de la sursa la sursa e 0
	dist[g->rootbridge]->value = 0;
	for (int count = 0; count < g->nr_nodes-1; count++) {
		//obtinem nodul cu distanta minima pana la sursa
		int u = minDistance(dist, sptSet, g->nr_nodes, s);
		//il marcam ca vizitat
		sptSet[u] = true;
		//ii parcurgem vecinii pe care nu i-am vizitat
		for (int j = 0; j < g->nr_nodes; j++)
			if (!sptSet[j] && g->adjacency_matrix[u][j] != NULL && dist[u]->value != INT_MAX) {
				//obtinem costul legaturii cu ei
				if (g->adjacency_matrix[u][j]->value == 10)
					cost = 100;
				else if (g->adjacency_matrix[u][j]->value == 100)
					cost = 19;
				else if (g->adjacency_matrix[u][j]->value == 1000)
					cost = 4;
				else if (g->adjacency_matrix[u][j]->value == 10000)
					cost = 1;
				//daca dist pana la u + cost de la u la j < ca distanta actuala
				//pastrata in vectorul de distante de la sursa la toate celelalte noduri
				//e mai mica
				if (dist[u]->value + cost < dist[j]->value) {
						//se actualizeaza distanta
						dist[j]->value = dist[u]->value + cost;
						//se adauga portul in lista pentru a sti care va fi root port pt switchul j
						//(ultimul element al listei)
						addNode(dist[j], g->adjacency_matrix[u][j]->next->next->value, -1);
				}
			}
	} 
	//daca se doreste afisarea rootporturilor
	if (write == 0) {
		printSolution(dist, g->nr_nodes, g, f, s, 0);
		edit_ports(s, g, dist, write, f);
		return g;
	}	//daca se doreste afisarea blockedporturilor
	else if (write == 1) {
		printSolution(dist, g->nr_nodes, g, f, s, 1);
		edit_ports(s, g, dist, write, f);
	//daca se doreste afisarea topologiei
	} else if (write == 2) {
		printSolution(dist, g->nr_nodes, g, f, s, 2);
		edit_ports(s, g, dist, write, f);
	}
	return g;
}

//afiseaza matricea de topologie
void print_topology(graph *&g, FILE *f) {
	int i, j, isRootPort = 1;
	node *temp;
	for (i = 0; i < g->nr_nodes; i++) {
		for (j = 0; j < g->nr_nodes; j++) {
			temp = g->adjacency_matrix[i][j];
			if (temp != NULL) {
				temp = temp->next;
				if (temp->type == 0) {
					if (j == g->nr_nodes - 1)
						fprintf(f, "%d\n", 1);
					else
						fprintf(f, "%d ", 1);
				}
				else {
					if (j == g->nr_nodes - 1)
						fprintf(f, "%d\n", 0);
					else
						fprintf(f, "%d ", 0);
				}
			}
			else {
				if (j == g->nr_nodes - 1)
					fprintf(f, "%d\n", 0);
				else
					fprintf(f, "%d ", 0);
			}
		}
	}
}

//citeste comenzile din fisier
graph* readCommands(char *topology, char *init, char *tasks, graph *&g, switches *&s, char *out) {
	char buffer[100];
	char *command = (char*)calloc(3,sizeof(char));
	FILE *f = fopen(tasks, "r");
	FILE *o = fopen(out, "w");
	int ok = 0, src, dst;
	while (fgets(buffer, 100, f) != NULL) {
		strncpy(command, buffer, 2);
		command[2] = '\0';
		if (strcmp(command, "c1") == 0) {
			fprintf(o, "%d\n", g->rootbridge);
		}
		else if (strcmp(command, "c2") == 0) {
			if (buffer[3] == '1') {
				if (ok == 0)
					g = getRootPorts(out, g, s, o, 0, src, dst);
				ok = 1;
			}
			else if (buffer[3] == '2') {
				if (ok == 0)
					g = getRootPorts(out, g, s, o, 1, src, dst);
				else
					show_bports(g, o);
				ok = 1;
			}
			else if (buffer[3] == '3') {
				if (ok == 0)
					g = getRootPorts(out, g, s, o, 2, src, dst);
				else
					print_topology(g, o);
				ok = 1;
			}
		} 
	}
	fclose(f);
	fclose(o);
	return g;
}

int main(int argc, char **argv) {
	graph *g = (graph*)malloc(sizeof(graph));
	switches *s = NULL;
	if (argc < 5)
		return -1;
	g = readInit(argv[1], g, s);
	g = ReadTopology(argv[2], g, s);
	g = readCommands(argv[2], argv[1], argv[3], g, s, argv[4]);
	return 0;
}
