#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <time.h>

int  nr_op = 0;

void dijsktra(int **& matrice_adiacenta, int source, int dest, int nr_noduri)
{
    int *dist = (int*)malloc(nr_noduri*sizeof(int));
    int *prev = (int*)malloc(nr_noduri*sizeof(int));
    int *selected = (int*)malloc(nr_noduri*sizeof(int));
    int i, m, min, first, d, j;
    int *path = (int*)malloc(nr_noduri*sizeof(int));
    nr_op += 4;
    for(i = 0; i < nr_noduri; i++)
    {
        dist[i] = 999;
        prev[i] = -1;
	selected[i] = 0;
        nr_op += 10;
    }
    first = source;
    selected[first] = 1;
    dist[first] = 0;
    nr_op += 5;
    while(selected[dest] == 0)
    {
        min = 999;
        m = 0;
        nr_op += 4;
        for(i = 0; i < nr_noduri; i++)
        {
            d = dist[first] + matrice_adiacenta[first][i];
            nr_op += 9;
            if(d < dist[i] && selected[i] == 0)
            {
                dist[i] = d;
                prev[i] = first;
		nr_op += 9;
            }
            if(min > dist[i] && selected[i]==0)
            {
                min = dist[i];
                m = i;
		nr_op += 8;
            }
        }
        first = m;
        selected[first] = 1;
	nr_op += 3;
    }
    first = dest;
    j = 0;
    while(first != -1)
    {
        path[j] = first;
	j++;
        first = prev[first];
	nr_op += 7;
    }
    FILE* f = fopen("dijkstra.out", "w+");
    nr_op += 3;
    fprintf(f, "%d\n", dist[dest]);
    for (i = j - 1; i > 0; i--) {
	nr_op += 6;
	fprintf(f, "%d ", path[i]);
     }
    fprintf(f, "%d\n", dest);
    fprintf(f, "%d\n", nr_op);
    fclose(f);
}

void init(int **& matrice_adiacenta, int nr_noduri) {
	int i, j;
	matrice_adiacenta = (int**)malloc(nr_noduri*sizeof(int*));
	for (i = 0; i < nr_noduri; i++) {
		matrice_adiacenta[i] = (int*)malloc(nr_noduri*sizeof(int*));
		nr_op += 6;
	}
	for(i = 0; i < nr_noduri; i++)
		for(j = 1; j< nr_noduri; j++) {
			matrice_adiacenta[i][j] = 999;
			nr_op += 11;
		}

}

int main()
{
    int **matrice_adiacenta;
    int i, j, cost;
    int source, target, x, y, z, m, n;
    FILE *f = fopen("dijkstra.in", "r");
    fscanf(f, "%d %d", &m, &n);
    init(matrice_adiacenta, n);
    fscanf(f, "%d %d", &source, &target);
    for (i = 0; i < m; i++) {
	fscanf(f, "%d %d %d", &x, &y, &z);
	matrice_adiacenta[x][y] = z;
	matrice_adiacenta[y][x] = z;
	nr_op += 10;
    }
    dijsktra(matrice_adiacenta, source,target, n);
    fclose(f);
}

