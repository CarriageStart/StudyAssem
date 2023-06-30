
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>

#define BUFFER_SIZER    (100 * 1024 * 1024)
#define PAGE_SIZE       4096
#define COMMAND_SIZE    4096


static char *p;
static char command[COMMAND_SIZE];

static
void
child_fn
()
{
    puts("*** child ps info before memory access ***:");
    fflush(stdout);
    snprintf(command, COMMAND_SIZE,
            "ps -o pid,comm,vsz,rss,min_flt,maj_flt | grep %d", getpid());
    system(command);

    puts("***free memory info before memory access ***:");
    fflush(stdout);
    system("free");


    for (int i=0; i<BUFFER_SIZER; i+=PAGE_SIZE) 
        p[i] = 1;

    puts("***child ps info after memory access ***:");
    fflush(stdout);
    system(command);

    puts("***free memory info after memory access ***:");
    fflush(stdout);
    system("free");

    exit(EXIT_SUCCESS);
}

static
void
parent_fn
()
{
    wait(NULL);
    exit(EXIT_SUCCESS);
}

int 
main
(void)
{
    p = malloc(BUFFER_SIZER);
    if (p == NULL) 
        err(EXIT_FAILURE, "malloc() failed");

    // Initialize all physical memory
    for (int i=0; i<BUFFER_SIZER; i+=PAGE_SIZE)
        p[i];


    puts("*** free memory info before fork ***:");
    fflush(stdout);
    system("free");

    pid_t pid = fork();
    if (pid == -1)
        err(EXIT_FAILURE, "fork() failed");

    if (pid == 0)
        child_fn();
    else
        parent_fn();

    err(EXIT_FAILURE, "Shouldn't reach here");

}



