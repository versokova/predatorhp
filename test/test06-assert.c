#include <stdlib.h>
#include <assert.h>
void reach_error() { assert(0); }


int main() {
    int a, b;
    int *p1 = &a;
    int *p2 = &b;

    if (p1 == p2) {
        goto err;
    }

    return 0;

    err: {reach_error();abort();}
    return 1;
}
