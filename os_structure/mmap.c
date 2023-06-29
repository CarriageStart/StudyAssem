
#include <unistd.h>
#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <err.h>

#define BUFFER_SIZE 1000
#define ALLOC_SIZE (100*1024*1024)


static char command[BUFFER_SIZE];

int 
main
(void) 
{
    pid_t pid;

    pid = getpid();
    snprintf(command, BUFFER_SIZE, "cat /proc/%d/maps", pid);

    puts("*** Memory map before memory allocation ***");
    fflush(stdout);
    system(command);


    void* new_memory;
    new_memory = mmap(NULL, ALLOC_SIZE, 
            PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (new_memory == (void*)-1) // mmap returns -1 if err => But we cast -1 into void*.
        err(EXIT_FAILURE, "mmap() failed");
    int* a = (int*)new_memory;
    a[0] = 1;

    puts("");
    printf("*** Succeeded to allocate memory: address = %p; size = 0x%x ***\n",
            new_memory, ALLOC_SIZE);
    puts("");
    puts("*** memory map after allocation ***");
    fflush(stdout);
    system(command);

    if (munmap(new_memory, ALLOC_SIZE) == -1)
        err(EXIT_FAILURE, "mummap() failed");
    exit(EXIT_SUCCESS);
}



