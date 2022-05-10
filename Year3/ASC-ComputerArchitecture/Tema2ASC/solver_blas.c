/*
 * Tema 2 ASC
 * 2018 Spring
 * Catalin Olaru / Vlad Spoiala
 */
#include "utils.h"
#include "cblas.h"

/* 
 * BLAS implementation
 */
double* my_solver(int N, double *A) {

	double *C;
    double vec1[2] = {0,1};
    double vec2[2] = {0,0};
    C = malloc(N * N * 2 * sizeof(double));

	cblas_zsyrk(CblasRowMajor,
				CblasUpper,
				CblasNoTrans,
				N,
				N,
				vec1,
				A,
				N,
				vec2,
				C,
				N
	);
	return C;
}
