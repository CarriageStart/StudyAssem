
#include <stdio.h>

void* gc_allocate(int);
void gc_deallocate(void*);
void gc_init()
void gc_scan()

volatile void** foo;
volatile void** goo;

int main() {
    gc_init();

    foo = gc_allocate(500);
    goo = gc_allocate(200);

    fprintf(stdout, "First Allocation : %p\n", foo);
    fprintf(stdout, "Second Allocation : %p\n", goo);

    foo[0] = goo;

    gc_scan();
}
