
#include <stdio.h>

void* allocate(int);
void deallocate(void*);

void retain(void*);
void release(void*);
int get_count(void*);

int main() {
    char* a = allocate(500);
    printf("Current a addr: %p , count : %d\n", a, get_count(a));
    retain(a);
    printf("Current a addr: %p , count : %d\n", a, get_count(a));
    retain(a);
    printf("Current a addr: %p , count : %d\n", a, get_count(a));
    retain(a);
    printf("Current a addr: %p , count : %d\n", a, get_count(a));
    release(a);
    printf("Current a addr: %p , count : %d\n", a, get_count(a));
    deallocate(a);
    printf("Current a addr: %p , count : %d\n", a, get_count(a));
    
    char* b = allocate(300);
    printf("Current b addr: %p , count : %d\n", b, get_count(b));
    retain(b);
    printf("Current b addr: %p , count : %d\n", b, get_count(b));
    release(b);
    printf("Current b addr: %p , count : %d\n", b, get_count(b));
    release(b);
    printf("Current b addr: %p , count : %d\n", b, get_count(b));

    char* c = allocate(300);
    printf("Current c addr: %p , count : %d\n", c, get_count(c));
    char* d = allocate(300);
    printf("Current d addr: %p , count : %d\n", d, get_count(d));
    deallocate(c);
    deallocate(d);
    printf("Current c addr: %p , count : %d\n", c, get_count(c));
    printf("Current d addr: %p , count : %d\n", d, get_count(d));
    return 0;
}
