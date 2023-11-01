#include <stdlib.h>

/* warning: memory leak detected while destroying a variable on stack */

int main() {
	int *p = malloc(sizeof(int));
	return 0;
} // memory leak end of function
