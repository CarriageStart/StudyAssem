
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

static pid_t* pids;

static inline 
long 
diff_nsec
(timespec_t before, timespec_t after)
{
    // Calculate the time diffence in ns
    return ((after.tv_sec*NSECS_PER_SEC + after.tv_nsec) 
                - (before.tv_sec*NSECS_PER_SEC + before.tv_nsec));
}

static 
unsigned long 
loops_per_msec
()
{
    // Calculate approximate number of loops per 1ms.
    timespec_t before, after;

    clock_gettime(CLOCK_MONOTONIC, &before);
    for (int i=0; i<N_LOOP_FOR_ESTIMATION; i++)
        ;
    clock_gettime(CLOCK_MONOTONIC, &after);

    return N_LOOP_FOR_ESTIMATION * NSECS_PER_MSEC / diff_nsec(before, after);
}

static inline
void
load
(unsigned long nloop)
{
    unsigned long i;
    for (i=0; i<nloop; i++)
        ;
}

static 
void
child_fn
(timespec_t* buf, 
 int id, int nrecord, unsigned long nloop_per_resol, timespec_t start)
{
    // Load for child process
    int i;
    for (i=0; i<nrecord; i++) {
        timespec_t ts;
        load(nloop_per_resol);
        clock_gettime(CLOCK_MONOTONIC, &ts);
        buf[i] = ts;
    }
    for (i=0; i<nrecord; i++) {
        printf("%d\t%ldms\t%d%%\n",
                id, diff_nsec(start, buf[i])/NSECS_PER_MSEC, (i+1)*100/nrecord);
    }
    exit(EXIT_SUCCESS);
}

int 
main
(int argc, char* argv[]) 
{
    int ret = EXIT_FAILURE;

    if (argc < 4) {
        // err
        fprintf(stderr, "usage: %s <nproc> <total[ms]> <resolution[ms]>\n", argv[0]);
        exit(ret);
    }
    int nproc = atoi(argv[1]);
    int total = atoi(argv[2]);
    int resol = atoi(argv[3]);

    if (nproc < 1) {
        // err
        fprintf(stderr, "<nproc>(%d) should be >= 1\n", nproc);
        exit(ret);
    }
    if (total < 1) {
        // err
        fprintf(stderr, "<total[ms]>(%d) should be >= 1\n", total);
        exit(ret);
    }
    if (resol < 1) {
        // err
        fprintf(stderr, "<resolution[ms]>(%d) should be >= 1\n", resol);
        exit(ret);
    }
    if (total % resol) {
        // err
        fprintf(stderr, "<total[ms]>(%d) should be multiple of <resolution[ms]>(%d)\n", 
                total, resol);
        exit(ret);
    }
    int n_record = total / resol;



    timespec_t* logbuf = malloc(n_record * sizeof(timespec_t));
    if (!logbuf) 
        err(ret, "malloc(logbuf) failed");

    puts("estimating workload which takes just one milisecond");
    unsigned long n_loop_per_resol = loops_per_msec() * resol;  
    puts("end estimation");
    fflush(stdout);

    pids = malloc(nproc * sizeof(pid_t));
    if (pids == NULL) {
        warn("malloc(pids) failed");
        goto FREE_LOGBUF;
    }



    timespec_t start;
    clock_gettime(CLOCK_MONOTONIC, &start);

    int i, ncreated;
    for (i=0, ncreated = 0; i<nproc; i++, ncreated++) {
        pids[i] = fork();
        if (pids[i] < 0) {
            // Fail to fork : finish to create process and wait
            goto WAIT_CHILDREN;
        }
        else if (pids[i] == 0) {
            // children Load
            child_fn(logbuf, i, n_record, n_loop_per_resol, start);      // TODO
            /* shouldn't reach here : Exit in child_fn*/
        }
    }

    // If all process created without err,
    ret = EXIT_SUCCESS;
WAIT_CHILDREN:
    // If there is an err in process creation,
    if (ret == EXIT_FAILURE) {
        for (i=0; i<ncreated; i++) {
            if (kill(pids[i], SIGINT) < 0) 
                warn("kill(%d) failed", pids[i]);
        }
    }

    for (i=0; i<ncreated; i++) {
        // pid_t wait(int* status) : Wait until all child process finishes
        //      status : exit state of child process
        //      return : finshed child pid.
        if (wait(NULL) < 0) 
            warn("wait() failed");
    }


    free(pids);
FREE_LOGBUF:
    free(logbuf);

    exit(ret);
    return 0;
}


