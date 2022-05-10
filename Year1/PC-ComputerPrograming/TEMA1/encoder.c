#include "encoder.h"

//Funtia citeste de la consola termeni pana la intalnirea cuvantului END 
//Si afla tipul termenilor: -1 caractere, 0pentru numere,1 pentru cuvinte
void read_and_count(termeni *t, int *nr_el, int *iw, int *ic, int *in) {
    int i = 0, j, n, word, count = 0;
    int ok = 0;
    char end[10];
    strcpy(end, "END");
    //Alocare memorie pentru 2 variabile termen si next-termen folosite ptru citirea de la consola
    char *termen = (char*)malloc(51*sizeof(char));
    char *next_termen = (char*)malloc(51*sizeof(char));
    //Alocare memorie pentru structura de tip termeni
    //Initial luam un nr de elemente, iar in cazul in care nr termenilor cititi e mai mare realocam vectorul de cuvinte 
    //Din structura de tip termeni
    t->termen = (char**)malloc(*nr_el*sizeof(char*));
        for(i = 0; i < *nr_el; i++)
        	t->termen[i] = (char*)malloc(51*sizeof(char));
    t->type = (int*)malloc(*nr_el*sizeof(int));
    //Citim primul termen si verificam sa fie diferit de END
    scanf("%s", termen);
    if (strcmp(termen, end) == 0)
        return;
    //Citim al 2-lea termen 
    scanf("%s", next_termen);
    if (strcmp(next_termen, end) == 0)
        return;
    //Citim termeni pana la intalnirea lui END
    while (1) {
    	ok = 0;
    	word = 1;
    	//Verificam daca termenul citit este caracter, daca are dimensiunea 1 si nu este cifra,cu exceptia lui "0"
        if (strlen(termen) == 1 && (isdigit(termen[0]) == 0 || termen[0] == '0')) {
        	word = 0;
        	//Realocam memorie daca am atins nr maxim de elemente
        	if (count == (*nr_el) - 1) {
        		t->termen = (char**)realloc(t->termen, sizeof(char*)*(*nr_el)*2);
				for (j = (*nr_el)-1; j < (*nr_el)*2; j++)
        			t->termen[j] = (char*)realloc(t->termen[j], sizeof(char)*50);
        		(*nr_el) *= 2;	//Dublam nr maxim de elemente
        		t->type = (int*)realloc(t->type, sizeof(int)*(*nr_el));
        	}
        	//Copiem in vectorul de termeni caracterul citit 
            strcpy(t->termen[count], termen);
            t->type[count] = -1;	//tipul termenului e -1
            count++;	//Crestem nr de termeni gasiti
            (*ic)++;	//Incrementam nr caracterelor gasite
        }
 		//Verificam daca termenul este un numar adica daca primul caracter este - sau o cifra diferita de "0"       
        else if (termen[0] == '-' || (isdigit(termen[0]) != 0 && termen[0] != '0')) {
            for(j = 1; j < strlen(termen); j++) { //pentru fiecare caracter verificam daca nu este cifra si e egala cu "0" 
                if (isdigit(termen[j]) == 0 || termen[j] == '0') {
                    ok = 1;
                    break;
                }
            }
            //daca termenul e numar 
            if (ok == 0) {
            	word = 0;
            	//verificam daca e necesar sa realocam memorie
              	if (count == (*nr_el) - 1) {
        			t->termen = (char**)realloc(t->termen, sizeof(char*)*(*nr_el)*2);
					for (j = (*nr_el)-1; j < (*nr_el)*2; j++)
        				t->termen[j] = (char*)realloc(t->termen[j], sizeof(char)*50);
        			(*nr_el) *= 2;
        			t->type = (int*)realloc(t->type, sizeof(int)*(*nr_el));
        		}
        		//Copiem numarul in vectorul de termeni 
        		strcpy(t->termen[count], termen);     
            	t->type[count] = 0;//tipul specific nr e "0"
            	count++;//Crestem nr de termeni
            	(*in)++;//Crestem nr de numere
        	} 
        }
        //Daca termenul e cuvant 
        if (word == 1) {
        	//verificam daca e necesar sa realocam memorie
        	if (count == (*nr_el) - 1) {
        		t->termen = (char**)realloc(t->termen, sizeof(char*)*(*nr_el)*2);
				for (j = (*nr_el)-1; j < (*nr_el)*2; j++)
        			t->termen[j] = (char*)realloc(t->termen[j], sizeof(char)*50);
        		(*nr_el) *= 2;
        		t->type = (int*)realloc(t->type, sizeof(int)*(*nr_el));
        	}
        	//copie cuvantul in vectorul de termeni
            strcpy(t->termen[count], termen);
            t->type[count] = 1;//tipul specific cuv e 1
            count++;//Crestem nr de termeni
            (*iw)++;//Crestem nr de cuvinte
        }
        strcpy(termen, next_termen);//copiem in termen next-termen
        scanf("%s", next_termen);//citim urmatorul termen
        if (strcmp(next_termen, end) == 0) {//daca urmatorul termen e END 
        	sscanf(termen, "%d", &t->nr);//atunci penultimul termen nu e termen si este n
        	break;//Iesim din bucla
        }
    }
    t->n = count;//in n pastram numarul total de termeni
    //afisam numarul de cuvinte,de caractere si de numere
    printf("%d %d %d\n", *iw, *ic, *in);
}

//Codifica termenii si creaza mesajul codificat in functie de tipul fiecarui termen
void codificare(char **mesaj_codificat, termeni *t, int nr_el) {
	int i;
	char *aux = (char*)calloc(nr_el*100,sizeof(char));
	for (i = 0; i < t->n; i++) {
		if (t->type[i] == -1)
			*mesaj_codificat = codificare_caracter(*mesaj_codificat, t->termen[i]);
		else if (t->type[i] == 0)
			*mesaj_codificat = codificare_numar(*mesaj_codificat, t->termen[i]);
		else if (t->type[i] == 1)
			*mesaj_codificat = codificare_cuvant(*mesaj_codificat, t->termen[i]);
	}
}

//Codifica caracterul si-l adauga la mesajul codificat
char* codificare_caracter(char *mesaj_codificat, char *caracter) {
	//Alocam memorie pentru un vector de structuri tip aparitii_caractere
	aparitii_caractere *ac = (aparitii_caractere*)malloc(strlen(mesaj_codificat)*sizeof(aparitii_caractere));
	char *m = (char*)calloc(strlen(mesaj_codificat) + 4, sizeof(char));
	strcpy(m, mesaj_codificat);
	//daca inca nu avem nici un termen in mesajul codificat adaugam caracterul si intoarcem m
	if (strlen(mesaj_codificat) == 0) {
		m[0] = *caracter;
		m[1] = '\0';
		return m;
	}
	//Obtinem nr de caractere distincte si caract respective si nr de aparitii al fiecarul caracter
	int nr_caractere_distincte = get_nr_aparitii(mesaj_codificat, ac);
	char c_min = get_min(ac, nr_caractere_distincte);	//Obtinem caracterul minim
	char c_max = get_max(ac, nr_caractere_distincte);	//Obtinem caracterul maxim
	//adaugam caracterul maxim la sf mesajului apoi caracterul curent apoi caracterul minim si apoi terminatorul de sir
	m[strlen(mesaj_codificat)] = c_max;
	m[strlen(mesaj_codificat)+1] = *caracter;
	m[strlen(mesaj_codificat)+2] = c_min;
	m[strlen(mesaj_codificat)+3] = '\0';
	return m;
}

//Obtinem numarul de aparitii al fiecarui caracter si nr de caractere distincte 
int get_nr_aparitii(char *mesaj_codificat, aparitii_caractere *ac) {
	int i, j, nr_caractere_distincte;
	int gasit = 0;
	nr_caractere_distincte = 1;
	ac[0].c = mesaj_codificat[0];
	ac[0].nr = 1;
	//pentru fiecare caract din mesaj 
	for (i = 1; i < strlen(mesaj_codificat); i++) {
		gasit = 0;
		//pentru fiecare din caract distincte deja gasite 
		for (j = 0; j < nr_caractere_distincte; j++) 
			//daca un caracter din mesajul codificat se regaseste in caracterele distincte
			if (mesaj_codificat[i] == ac[j].c) {
				gasit = 1;
				//crestem numarul de aparitii ale acelui caracter
				ac[j].nr++;
			}
			//daca nu l-am gasit 
		if (gasit == 0) {
			ac[nr_caractere_distincte].nr = 1;	//initial nr de caract distincte e 1
			ac[nr_caractere_distincte].c = mesaj_codificat[i];	//adaugam caract in vectorul de structuri
			nr_caractere_distincte++;	//crestem nr de caract distincte
		}
	}
	return nr_caractere_distincte;
}

//Determinam caracterul cu numarul maxim de aparitii
char get_max(aparitii_caractere *ac, int nr_caractere_distincte) {
	int i, max = 0;
	char c;
	for (i = 0; i < nr_caractere_distincte; i++) {
		if (ac[i].nr > max) {
			max = ac[i].nr;
			c = ac[i].c;
		}
	}
	return c;
}

//Determinam caracterul cu numarul minim de aparitii
char get_min(aparitii_caractere *ac, int nr_caractere_distincte) {
	int i, min = 999999;
	char c;
	for (i = 0; i < nr_caractere_distincte; i++) {
		if (ac[i].nr < min) {
			min = ac[i].nr;
			c = ac[i].c;
		}
	}
	return c;
}

//efectuaeaza codificarea unui numar
char* codificare_numar(char *mesaj_codificat, char *numar) {
	char max = '0', min = '9';
	int *pos = (int*)malloc(strlen(numar)*sizeof(int));	//pastram pozitiile caracterului maxim(daca e cu +) sau minim(daca e cu -)
	int i, j = 0, k, l = 0;
	char **nr;
	char* mesaj;
	if (numar[0] != '-') {	//daca nr e pozitiv cautam caracterul maxim si pozitiile sale 
		for (i = 0; i < strlen(numar); i++) {
			if (numar[i] > max) {
				max = numar[i];
				pos[j] = i;
			}
			else if (numar[i] == max) {
				j++;
				pos[j] = i;
			}
		}
	}
	else {	//daca nr e negativ cautam caracterul minim si pozitiile sale
		for (i = 1; i < strlen(numar); i++) {
			if (numar[i] < min) {
				min = numar[i];
				pos[j] = i;
			}
			else if (numar[i] == min) {
				j++;
				pos[j] = i;
			}
		}
	}
	//alocam un vector de numere de dimensiune j+1 unde j este nr de caracter maxime/minime
	nr = (char**)malloc((j+1)*sizeof(char*));
	for (i = 0; i <= j; i++)
		nr[i] = (char*)malloc(strlen(numar)*sizeof(char));
	for (i = 0; i <= j; i++) {	//pornind de la pozitia caracterului maxim/minim formam potentialele numere maxime/minime
		for (k = pos[i]; k < strlen(numar); k++) {
			nr[i][l++] = numar[k];
		}
		if (numar[0] != '-')	//verificam daca primul caracter e - pentru a sari peste el
			for (k = 0; k < pos[i]; k++) {
				nr[i][l++] = numar[k];
			}
		else {
			for (k = 1; k < pos[i]; k++) {
				nr[i][l++] = numar[k];
			}
		}
		l = 0;
	}
	//daca nr e pozitiv obtinem maxim dintre potentialele nr maxime aflate mai sus
	double nr2;
	if (numar[0] != '-')
		nr2 = max_number(nr, j+1);
	else	//daca nr e negativ obtinem minim dintre potentialele nr minime aflate mai sus
		nr2 = min_number(nr, j+1);
	sprintf(numar, "%0.lf", nr2);
	strcat(mesaj_codificat, numar);	// adaugam nr la mesajul codificat si intoarcem mesajul codificat
	return mesaj_codificat;
}

//gasim numarul maxim
double max_number(char **nr, int linii) {
	double max = 0;
	int i;
	double val;
	for (i = 0; i < linii; i++) {
		val = atof(nr[i]);
		if (val > max)
			max = val;
	}
	return max;
}

//gasim numarul minim
double min_number(char **nr, int linii) {
	double min = 2147483647;
	int i;
	double val;
	for (i = 0; i < linii; i++) {
		val = atof(nr[i]);
		if (val < min)
			min = val;
	}
	return min;
}

//codifica cuvantul
char* codificare_cuvant(char* mesaj_codificat, char *cuvant) {
	char* mesaj = (char*)calloc(strlen(cuvant),sizeof(char));
	int i, d, has_digits = 0, j = 0;
	for (i = 0; i < strlen(cuvant); i++) {	//verificam daca cuvantul contine cifre
		if (isdigit(cuvant[i]) != 0)
			has_digits = 1;
	}
	d = greatest_divisor(strlen(cuvant));	//obtinem cel mai mare divizor a lungimii cuvantului
	//daca nu are cifre 
	if (has_digits == 0) {
		for (i = d; i < strlen(cuvant); i++) { //nu inverseaza ordinea caracterelor
			mesaj[j] = cuvant[i];
			j++;
		}

	}
	else {
		for (i = strlen(cuvant) - 1; i >= d; i--) {	//inverseaza ordinea caracterelor
			mesaj[j] = cuvant[i];
			j++;
		}
	}
	for (i = 0; i < d; i++) {	//Adauga primele d caractere la inceputul cuvantului
		mesaj[j] = cuvant[i];
		j++;
	}
	mesaj[j] = '\0';
	strcat(mesaj_codificat, mesaj);	//adauga cuvantul la mesajul codificat
	return mesaj_codificat;
}
//obtinem cel mai mare divizor al unui numar
int greatest_divisor(int n) {
	int i = 1;
	int gd = 0;
	while (i <= n/2) {
		if (n % i == 0)
			gd = i;
		i++;
	}
	return gd;
}
//imparte mesajul in n parti
mesaje3* impartire_mesaj(char* mesaj_codificat, int n) {
	mesaje3 *m = (mesaje3*)malloc(n*sizeof(mesaje3));
	int i, j = 0, k, l= 0;
	if (strlen(mesaj_codificat)%n == 0)	//daca dimensiunea mesajului e divizibila cu n mesajul se imparte in n parti de lung egale
		for (i = 0; i < strlen(mesaj_codificat); i = i + (strlen(mesaj_codificat)/n)) {
			j = 0;
			m[l].mesaj = (char*)calloc(strlen(mesaj_codificat)/n, sizeof(char));
			for (k = i; k < i + (strlen(mesaj_codificat)/n); k++) {
				m[l].mesaj[j] = mesaj_codificat[k];
				j++;
			}
			l++;
		}
	else {	//daca dimensiunea mesajului nu e divizibila cu n mesajul se imparte in n-1 parti de lung egale si una in care punem caracterele ramase
		for (i = 0; i < strlen(mesaj_codificat) - strlen(mesaj_codificat)/n - strlen(mesaj_codificat)%n; i = i + (strlen(mesaj_codificat)/n)) {
			j = 0;
			m[l].mesaj = (char*)calloc(strlen(mesaj_codificat)/n, sizeof(char));
			for (k = i; k < i + (strlen(mesaj_codificat)/n); k++) {
				m[l].mesaj[j] = mesaj_codificat[k];
				j++;
			}
			l++;
		}
	}	//daca dimensiunea mesajului nu e divizibila cu n, punem ultimele caractere in ultimul element al structurii de tip mesaje3
	i = 0;
	if (k < strlen(mesaj_codificat)) {
		m[l].mesaj = (char*)calloc(strlen(mesaj_codificat) - k, sizeof(char));
		for (j = k; j < strlen(mesaj_codificat); j++) {
			m[l].mesaj[i++] = mesaj_codificat[j];
		}
	}
	return m;	//intoarce structura de mesaje
}

//Calculeaza complexitatea
mesaje3* complexitate(mesaje3 *m, int n) {
	int i, j;
	for (i = 0; i < n; i++) {//pentru fiecare elem din struct de mesaje calculeaza complexitatea
	// facand media aritm a codurilor ASCII ale unui mesaj
		for (j = 0; j < strlen(m[i].mesaj); j++) {
			m[i].complexitate += m[i].mesaj[j];
		}
		m[i].complexitate /= strlen(m[i].mesaj);
	}
	return m;
}
//sortam elementele din structura de tip mesaje3 in ordine descresc in functie de complexitate
mesaje3* sortare(mesaje3 *m, int n) {
	int i, j;
	mesaje3 aux;
	for (i = 0; i < n - 1; i++) {
		for (j = i; j < n; j++) {
			if (m[i].complexitate < m[j].complexitate) {
				aux = m[i];
				m[i] = m[j];
				m[j] = aux;
			}
			if (m[i].complexitate == m[j].complexitate) {	//daca au aceeasi complexitate sortam lexicografic
				if (strcmp(m[i].mesaj, m[j].mesaj) < 0) {
					aux = m[i];
					m[i] = m[j];
					m[j] = aux;
				}
			}
		}
	}
	return m;	//intoarce struct sortata
}

//reasambleaza mesajul codificat
char* reasamblare(mesaje3 *m, int n, char* mesaj_codificat) {
	int i, count = 1;
	strcpy(mesaj_codificat, m[0].mesaj);
	for (i = 1; i < n; i++) {
		if (count == n)	// daca am scris toate elementele din struct de tip mesaje3 iesim din for
			break;
		if (n - i != i) {	//daca n-i != i adaugam si n-i si i
			strcat(mesaj_codificat, m[n - i].mesaj);
			strcat(mesaj_codificat, m[i].mesaj);
			count += 2;
		}
		else {	//daca sunt egale adaugam doar una dintre ele
			strcat(mesaj_codificat, m[i].mesaj);
			count++;
		}
	}
	return mesaj_codificat;
}

int main(){
	char *mesaj_codificat;
	termeni *t = (termeni*)malloc(sizeof(termeni));
    int nr_el = 2, iw = 0, ic = 0, in = 0, i;
    read_and_count(t, &nr_el, &iw, &ic, &in);	//citeste termenii, le determina tipul si numarul in functie de tip
    mesaje3 *m = (mesaje3*)calloc(t->nr, sizeof(mesaje3));
    mesaj_codificat = (char*)calloc(nr_el*102,sizeof(char));
    codificare(&mesaj_codificat, t, nr_el);		//are loc codificarea mesajului
    printf("%s\n", mesaj_codificat);
    m = impartire_mesaj(mesaj_codificat, t->nr);	//mesajul este impartint in n parti
    m = complexitate(m, t->nr);		//se calculeaza complexitatea
    m = sortare(m, t->nr);		//se efectueaza sortarea descrescatoare
	mesaj_codificat = reasamblare(m, t->nr, mesaj_codificat);	//are loc reasamblarea mesajului
	printf("%s\n", mesaj_codificat);
    return 0;
}