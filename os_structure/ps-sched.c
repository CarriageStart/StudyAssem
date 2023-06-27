
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>

#define N_LOOP_FOR_ESTIMATION 100000000UL
#define NSECS_PER_MSEC 1000000UL
#define NSECS_PER_SEC 1000000000UL

typedef struct timespec timespec_t;
static inline 
long 
diff_nsec
(timespec_t before, timespec_t after)
{
}

static unsigned long loops_per_msec();

int 
main
(int argc, char* argv[]) 
{
    int ret = EXIT_FAILURE;

    if (argc < 4) {
        // err
        fprintf(stderr, "usage: %s <nproc> <total[ms]> <resolution[ms]>", argv[0]);
        exit(ret, "More inputs are needed");
    }
    int nproc = atoi(argv[1]);
    int total = atoi(argv[2]);
    int resol = atoi(argv[3]);

    if (nproc < 1) {
        // err
        fprintf(stderr, "<nproc>(%d) should be >= 1\n", argv[1]);
        exit(ret);
    }
    if (total < 1) {
        // err
        fprintf(stderr, "<total[ms]>(%d) should be >= 1\n", argv[2]);
        exit(ret);
    }
    if (resol < 1) {
        // err
        fprintf(stderr, "<resolution[ms]>(%d) should be >= 1\n", argv[3]);
        exit(ret);
    }
    if (total % resol) {
        // err
        fprintf(stderr, "<total[ms]>(%d) should be multiple of <resolution[ms]>(%d)\n", 
                argv[2], argv[3]);
        exit(ret);
    }
    int n_record = total / resol;


    timespec_t* logbuf = malloc(n_record * sizeof(timespec_t));
    if (!logbuf) 
        err(ret, "malloc(logbuf) failed");

    puts("estimating workload which takes just one milisecond");
    unsigned long n_loop_per_resol = loops_per_msec() * resol;



}


