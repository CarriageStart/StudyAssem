
#include <unistd.h>
#include <sys/mman.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <err.h>

#define CACHE_LINE_SIZE 64
#define N_LOOP          (4 * 1024UL * 1024 * 1024)
#define NSECS_PER_SECS  1000000000UL


typedef struct timespec timespec_t;

static inline
long
diff_nsec(timespec_t before, timespec_t after) 
{
    return ((after.tv_sec*NSECS_PER_SECS + after.tv_nsec)
            - (before.tv_sec*NSECS_PER_SECS + before.tv_nsec));
}

int
main
(int argc, char* argv[])
{
    char* progname = argv[0];
    if (argc != 2) {
        fprintf(stderr, "usage: %s <size[KB]>\n", progname);
        exit(EXIT_FAILURE);
    }

    register int size = atoi(argv[1]) * 1024;
    if (size < 1) {
        fprintf(stderr, "size should be >= 1: %d\n", size);
        exit(EXIT_FAILURE);
    }

    char* buffer = mmap(NULL, size,
            PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (buffer == (void*) -1)
        err(EXIT_FAILURE, "mmap() failed");

    timespec_t before, after;
    clock_gettime(CLOCK_MONOTONIC, &before);
    for (int i=0; i < N_LOOP/(size/CACHE_LINE_SIZE); ++i) {
        for (long j=0; j < size; j += CACHE_LINE_SIZE)
            buffer[j] = 0;
    }
    clock_gettime(CLOCK_MONOTONIC, &after);

    printf("Time per loop : %f ns, \tsize : %d\n", (double)diff_nsec(before, after) / N_LOOP, size);
    if (munmap(buffer, size) == -1) 
        err(EXIT_FAILURE, "munmap() failed");
    exit(EXIT_SUCCESS);
}


