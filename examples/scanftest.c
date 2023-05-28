
#include <stdio.h>

int main(void) {
    printf("int size : %lu byte\n", sizeof(int));
    int x = 0; int y = 0;
    void* p = (void*)(&x);
    int num_var = fscanf(stdin, "%d %d", (int*)p, &y);
    printf("values are : %d and %d\n", x, y);
    return 0;
}
