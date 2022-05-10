/*
 * Tema 2 ASC
 * 2018 Spring
 * Catalin Olaru / Vlad Spoiala
 */
#include "utils.h"
#include <stdlib.h>
#include <stdio.h>
/*
 * Optimised implementation
 */

double* my_solver(int N, double *A)
{
    register double *C;
    int i, j, k;

    C = malloc(N * N * 2 * sizeof(double));
 	for (i = 0; i < N; i++) {
		for ( j = i; j < N; j++) {
			register double x = 0;
			register double y = 0;
			for( k = 0; k < N; k++){
				x += A[2 *( N * i + k ) + 0] * A[2 *( N * j + k ) + 0] - A[2 *( N * i + k ) + 1]*  A[2 *( N * j + k ) + 1];
    
   				y += A[2 *( N * i + k ) + 0] * A[2 *( N * j + k ) + 1] + A[2 *( N * j + k ) + 0] * A[2 *( N * i + k ) + 1];
			}
			C[2 *( N * i + j ) + 0] += x;
			C[2 *( N * i + j ) + 1] += y;
		}	     
	}
	return C;
}
