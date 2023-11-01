#include <stdlib.h>

/* error: dereference of NULL value */

int main() {
	int *p = NULL;
	return *p; // invalid deref
}
