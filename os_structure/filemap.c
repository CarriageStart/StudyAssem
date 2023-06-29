
#include <sys/types.h>  // All types usesd in system
#include <sys/stat.h>   // Status for file attributes
#include <fcntl.h>      // Control File desciptor
#include <unistd.h>     // POSIX(Unix) std
#include <sys/mman.h>   // Memory Manage
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>

// Runtime Non-computing constant
#define BUFFER_SIZE 1000
#define ALLOC_SIZE (100*1024*1024)


static char command[BUFFER_SIZE];
static char file_contents[BUFFER_SIZE];
static char overwrite_data[] = "HELLO";

int 
main
(void)
{
    pid_t pid = getpid();
    snprintf(command, BUFFER_SIZE, "cat /proc/%d/maps", pid);

    puts("*** memory map before mapping file ***");
    fflush(stdout);
    system(command);

    // File is loaded to the physcal memory.
    int fd = open("testfile", O_RDWR); // O_RDWR : Open Read and wirte
    if (fd==-1) 
        err(EXIT_FAILURE, "open() failed");
    // The file on the physcal memory is mapped to the virtual memory. (Can be accesible)
    char* file_contents = mmap(NULL, ALLOC_SIZE, 
            PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    if (file_contents == (void*) -1) {
        warn("mmap() failed");
        goto close_file;
    }

    puts("");
    printf("*** Succeeded to map file: address = %p; size = 0x%x ***\n",
            file_contents, ALLOC_SIZE);

    puts("*** Memory map after mapping file ***");
    fflush(stdout);
    system(command);

    puts("");
    printf("*** File contents before overwrite mapped region: %s", file_contents);

    memcpy(file_contents, overwrite_data, strlen(overwrite_data));

    puts("");
    printf("*** overwritten mapped region with :%s\n", file_contents);


    if (munmap(file_contents, ALLOC_SIZE) == -1) 
        warn("mummap() failed");
close_file:
    if (close(fd) == -1)
        err(EXIT_FAILURE, "close() failed");
    exit(EXIT_SUCCESS);
}



