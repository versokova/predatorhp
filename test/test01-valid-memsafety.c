#include <stdlib.h>

void main() {
	int *p = malloc(sizeof(*p));
	free(p);
}
