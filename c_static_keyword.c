
#include <stdio.h>

/*
 * By deafult, every things listed up as globl in C and C++.
 * Static does following things.
 * 1. Make space in .data section. but not list it as globl.
 * 2. Put the addr of data in .data section in varible space.
 *
 * Therefoee, for static variable, other files cannot access it,
 * since it is not globl.
 * For local static varaible, other functions cannot access it,
 * since the addr is saved in stack frame of function.
 */

static int i = 0;

int* another() {
    static int i = 0;
    ++i;
    printf( "another Current i : %d\n", i);
    return &i;
}


int main() {
    ++i;
    printf( "Main Current i : %d\n", i);

    int* p = another();
    ++i;
    ++*p;
    printf( "Main Current i : %d\n", i);
    another();
    ++i;
    printf( "Main Current i : %d\n", i);
    another();
    ++i;
    printf( "Main Current i : %d\n", i);
    return 0;
}
