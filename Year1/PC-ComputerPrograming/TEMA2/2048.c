#include <ncurses.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
const int NMAX=4;

typedef struct points{
	int x;
	int y;
}pts;
//vector de coordonate a poziitiilor de start pentru citire si afisare
pts A[16]={
	{1,1},{1,6},{1,11},{1,16},
	{3,1},{3,6},{3,11},{3,16},
	{5,1},{5,6},{5,11},{5,16},
	{7,1},{7,6},{7,11},{7,16}
};

int score=0;

//functie initializare standard screen
void init(){
	initscr();
	cbreak();
	noecho();
	keypad(stdscr, true);
	curs_set(0);
	if (has_colors() != false)
	{
		start_color();
		init_pair(1, COLOR_GREEN, COLOR_GREEN);
		init_pair(2, COLOR_RED, COLOR_RED);
		init_pair(3, COLOR_BLUE, COLOR_BLUE);
	}

}


//functie pentru terminarea ncurses
void clean(){

	getch();
	keypad(stdscr,false);
	nodelay(stdscr ,false);
	nocbreak();
	echo();
	endwin();
	exit(0);
}



void showMenu();

//functie pentru generarea unui numar aleatoriu din {2,4}
void gen() {
	int numar,n,r;
	char c;
	r = rand() % 16;
	while ((c=mvinch(A[r].x,A[r].y))!=' '){
		r = rand() % 16;
	}
	n = rand() % 2;
	if(n==1){
		numar=4;
	} else {
		numar=2;
	}
	mvaddch(A[r].x,A[r].y,numar+'0');

}


//functie pentru convertirea stringului citit in integer
//pentru a putea manipula tabla
int toInt(char* s){
	int i,n;
	n=0;
	for(i=0;i<strlen(s);i++){
		n*=10;
		n+=(int)(s[i]-'0');
	}

	return n;
}


//functie care transforma integer in sir pentru a putea fi afisate
char* toString(int i){
	char *c,*b;int k=0;
	b=(char*)malloc(5);
	c =(char*)malloc(5);
	if(i==0){
		b[0]=' ';
		b[1]=0;
		return b;
	}
	while(i){
		c[k]=(i%10)+'0';
		i/=10;
		k++;
	}
	c[k]=0;
	for(i=0;i<k;i++){
		b[i]=c[k-i-1];
	}
	b[k]=0;
	return b;
}


//functie de citire a stringului de cifre de pe tabla
char* read(pts A){
	int i,j=0;
	char *f,c;
	f=(char*)malloc(5);
	for(i=A.y;;i++){
		c=mvinch(A.x,i);
		if(c!=' '&&c!='|'){
			f[j]=c;
			j++;
		} else {
			break;
		}
	}
	f[j]=0;
	return f;
}

// functie pentru mutarea componentelor in sus
void move_up() {
	char *nr;
	int k=0,i,j=0,l=0,n[4],p,finish=1;
	for(p=0;p<4;p++){
		nr=read(A[0+p]);
		n[0]=toInt(nr);


		nr=read(A[4+p]);
		n[1]=toInt(nr);


		nr=read(A[8+p]);
		n[2]=toInt(nr);


		nr=read(A[12+p]);
		n[3]=toInt(nr);

		for(i=0;i<4;i++){
			if(n[i]==0){
				finish=0;
			}
		}


		for(i=0;i<3;i++){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k<4;k++){
					if(n[k]!=0){
						j=0;
						l++;
					}}
				for(k=i;k<3;k++){
					n[k]=n[k+1];
					n[k+1]=0;

				}

			}
		}
		for(i=0;i<3;i++){

			if(n[i]==n[i+1]&&n[i]!=0){
				n[i]+=n[i+1];
				score+=n[i];
				i++;
				n[i]=0;

				l++;
			}
		}
		for(i=0;i<3;i++){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k<4;k++){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k<3;k++){
					n[k]=n[k+1];
					n[k+1]=0;

				}

			}
		}
		for(i=0;i<4;i++){
			mvprintw(A[(i*4)+p].x,A[(i*4)+p].y,"    ");
		}
		for(i=0;i<4;i++){
			mvprintw(A[(i*4)+p].x,A[(i*4)+p].y,toString(n[i]));
		}


	}
	if(finish==1){
		showMenu();
	}
	if(l!=0){
		gen();
	}
	l=0;
}



// functie pentru mutarea componentelor in dreapta
void move_right() {
	char *nr;
	int k=0,i,j=0,l=0,n[4],p,finish=1;
	for(p=0;p<4;p++){
		nr=read(A[p*4]);
		n[0]=toInt(nr);


		nr=read(A[p*4+1]);
		n[1]=toInt(nr);


		nr=read(A[p*4+2]);
		n[2]=toInt(nr);


		nr=read(A[p*4+3]);
		n[3]=toInt(nr);
		for(i=0;i<4;i++){
			if(n[i]==0){
				finish=0;
			}
		}


		for(i=3;i>0;i--){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k>=0;k--){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k>0;k--){
					n[k]=n[k-1];
					n[k-1]=0;

				}

			}
		}
		for(i=3;i>0;i--){

			if(n[i]==n[i-1]&&n[i]!=0){
				n[i]+=n[i-1];
				score+=n[i];
				i--;
				n[i]=0;
				l++;
			}
		}
		for(i=3;i>0;i--){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k>=0;k--){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k>0;k--){
					n[k]=n[k-1];
					n[k-1]=0;

				}
			}
		}
		for(i=0;i<4;i++){
			mvprintw(A[p*4+i].x,A[p*4+i].y,"    ");
		}
		for(i=0;i<4;i++){
			mvprintw(A[p*4+i].x,A[p*4+i].y,toString(n[i]));
		}


	}

	if(finish==1){
		showMenu();
	}
	if(l!=0){
		gen();
	}
	l=0;
}

// functie pentru mutarea componentelor in stanga
void move_left() {
	char *nr;
	int k=0,i,j=0,l=0,n[4],p,finish=1;
	for(p=0;p<4;p++){
		nr=read(A[p*4]);
		n[0]=toInt(nr);


		nr=read(A[p*4+1]);
		n[1]=toInt(nr);


		nr=read(A[p*4+2]);
		n[2]=toInt(nr);


		nr=read(A[p*4+3]);
		n[3]=toInt(nr);

		for(i=0;i<4;i++){
			if(n[i]==0){
				finish=0;
			}

		}

		for(i=0;i<3;i++){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k<4;k++){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k<3;k++){
					n[k]=n[k+1];
					n[k+1]=0;

				}

			}
		}
		for(i=0;i<3;i++){

			if(n[i]==n[i+1]&&n[i]!=0){
				n[i]+=n[i+1];
				score+=n[i];
				i++;
				n[i]=0;
				l++;
			}
		}
		for(i=0;i<3;i++){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k<4;k++){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k<3;k++){
					n[k]=n[k+1];
					n[k+1]=0;

				}

			}
		}
		for(i=0;i<4;i++){
			mvprintw(A[p*4+i].x,A[p*4+i].y,"    ");
		}
		for(i=0;i<4;i++){
			mvprintw(A[p*4+i].x,A[p*4+i].y,toString(n[i]));
		}


	}

	if(finish==1){
		showMenu();
	}
	if(l!=0){
		gen();
	}
	l=0;
}

// functie pentru mutarea componentelor in jos
void move_down() {
	char *nr;
	int k=0,i,j=0,l=0,n[4],p,finish=1;
	for(p=0;p<4;p++){
		nr=read(A[0+p]);
		n[0]=toInt(nr);


		nr=read(A[4+p]);
		n[1]=toInt(nr);


		nr=read(A[8+p]);
		n[2]=toInt(nr);


		nr=read(A[12+p]);
		n[3]=toInt(nr);

		for(i=0;i<4;i++){
			if(n[i]==0){
				finish=0;
			}
		}


		for(i=3;i>0;i--){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k>=0;k--){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k>0;k--){
					n[k]=n[k-1];
					n[k-1]=0;

				}

			}
		}
		for(i=3;i>0;i--){

			if(n[i]==n[i-1]&&n[i]!=0){
				n[i]+=n[i-1];
				score+=n[i];
				i--;
				n[i]=0;
				l++;
			}
		}
		for(i=3;i>0;i--){
			j=0;
			while(n[i]==0&&!j){
				j=1;
				for(k=i;k>=0;k--){
					if(n[k]!=0){
						l++;
						j=0;
					}}
				for(k=i;k>0;k--){
					n[k]=n[k-1];
					n[k-1]=0;

				}

			}
		}
		for(i=0;i<4;i++){
			mvprintw(A[(i*4)+p].x,A[(i*4)+p].y,"    ");
		}
		for(i=0;i<4;i++){
			mvprintw(A[(i*4)+p].x,A[(i*4)+p].y,toString(n[i]));
		}


	}
	if(finish==1){
		showMenu();
	}
	if(l!=0){
		gen();
	}
	l=0;
}

//functie pentru desenarea tablei de joc

void draw_board(){
	int i,j;
	for(j=0;j<=8;j+=2)
		for(i=0;i<=20;i++){
			mvaddch(j,i,'-');
		}

	for(j=0;j<=21;j+=5)
		for(i=0;i<=8;i++){
			mvaddch(i,j,'|');
		}
}


//functie pentru afisarea meniului 
void showMenu(){
	erase();
	mvprintw(5,20,"Apasati <1> pentru Joc Nou.");
	mvprintw(6,20,"Apasati <0> pentru Iesire.");
	int k;
	k=getch();
	while((k-'0')!=1&&(k-'0')!=0){
		k=getch();
	}
	if(k-'0'==1){
		erase();
		gen();
		gen();
		draw_board();
		score=0;
	} else {
		clean();
		exit(0);
	}
}

// functie pentru actualizarea scorului
void writeScore(){
	mvprintw(3,25,"Score:");
	mvprintw(3,32,toString(score));
}

int main(int argc, char** argv) {
	char c;
	init();
	showMenu();
	srand(time(NULL));



	while(1) {
		c = getch();
		switch(c){
			case 'd':
				move_right();
				writeScore();
				break;
			case 'a':
				move_left();
				writeScore();
				break;
			case 'w':
				move_up();
				writeScore();   
				break;
			case 's':
				move_down();
				writeScore();
				break;
		}
	}
	clean();
	return 0;
}

