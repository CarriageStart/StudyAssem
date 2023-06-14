
#include <stdio.h>

void* gc_allocate(int);
void gc_init();
void gc_scan();
int gc_show_heap_size();

volatile void **foo = NULL;
volatile void **goo = NULL;

int main() {
    gc_init();
    
    foo = gc_allocate(500);
    fprintf(stdout, "Allocation 1: %p\n", foo);
    gc_show_heap_size();

    goo = gc_allocate(200);
    foo[0] = goo;
    fprintf(stdout, "Allocation 2: %p\n", goo);
    gc_show_heap_size();

    fprintf(stdout, "Start first scan\n");
    gc_scan();
    gc_show_heap_size();

    goo = gc_allocate(300); 
    fprintf(stdout, "Allocation 3: %p\n", goo);
    // Allcation 2 is still reachable from foo
    fprintf(stdout, "Start second scan\n");
    gc_scan();
    gc_show_heap_size();
    
    goo = gc_allocate(200);
    fprintf(stdout, "Allocation 4: %p\n", goo);
    // Allcation 3 is not reachable from now
    fprintf(stdout, "Start third scan\n");
    gc_scan();
    gc_show_heap_size();

    foo = gc_allocate(500);
    // Allcation 1, 2 are not reachable from now
    fprintf(stdout, "Allocation 5: %p\n", foo);
    fprintf(stdout, "Start forth scan\n");
    gc_scan();
    gc_show_heap_size();

    goo = gc_allocate(10);
    fprintf(stdout, "Allocation 6: %p\n", goo);
    foo = gc_allocate(10);
    fprintf(stdout, "Allocation 7: %p\n", foo);
    gc_scan();
    gc_show_heap_size();
    
    goo = NULL;
    foo = NULL;
    gc_scan();
    gc_show_heap_size();

    return 0;
}

