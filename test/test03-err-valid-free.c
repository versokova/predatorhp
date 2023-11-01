#include <stdlib.h>

/* error: double freee */

int main() {
	int *p = malloc(sizeof(p));
	int *q = p;
	free(p);
	free(q); // double free
	return 0;
}
