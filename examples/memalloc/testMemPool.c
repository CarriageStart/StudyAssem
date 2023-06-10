
#include <stdio.h>

void* allocate(int, int); 
void deallocate(void*); 
void deallocate_pool(int); 

int main() {
    char* a1 = allocate(1, 400);
    char* a2 = allocate(2, 100);
    char* a2_1 = allocate(2, 200);
    char* a2_2 = allocate(2, 300);
    char* a3 = allocate(3, 400);

    printf("Here?");
    printf("Current a1 addr : %p\n", a1);
    deallocate(a1);
    deallocate_pool(2);
    
    a1 = allocate(1, 200);
    printf("New a1 addr : %p\n", a1);
    
    deallocate_pool(3);
    return 0;
}
