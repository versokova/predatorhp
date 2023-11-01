#include <stdlib.h>

extern _Bool __VERIFIER_nondet_bool();

int **g = NULL;

int main() {
	g = (int **) malloc(sizeof(int *));
 	if (__VERIFIER_nondet_bool()) exit(1);
	free(g);
	g = NULL;
	return 0;
}
