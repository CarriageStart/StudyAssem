
#include <stdio.h>

void* allocate(int);
void deallocate(void*);

int main() {
    char* arr1 = allocate(500);
    char* arr2 = allocate(1000);
    char* arr3 = allocate(100);

    fprintf(stdout, "Allocations: %p, %p, %p\n", arr1, arr2, arr3);
    deallocate(arr1);

    char* arr4 = allocate(1000);
    char* arr5 = allocate(250);
    char* arr6 = allocate(250);
    fprintf(stdout, "Allocations: %p, %p, %p, %p, %p, %p\n", 
            arr1, arr2, arr3, arr4, arr5, arr6);

    fscanf(stdin, "%s", arr4);
    fprintf(stdout, "%s\n", arr4);

    deallocate(arr2);
    deallocate(arr3);
    deallocate(arr4);
    deallocate(arr5);
    deallocate(arr6);

    return 0;
}
