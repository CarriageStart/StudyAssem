
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <err.h>

const int TIME_SLEEP = 10000;
const unsigned long TIME_REPEAT = -1;

static 
void 
child () 
{
    char* args[] = {"/bin/echo", "hello", NULL};
    printf("I'm child! my pid is %d.\n", getpid());
    fflush(stdout);
    for (;;) {
        printf("I'm child! my pid is %d.\n", getpid());
    }
    //sleep(TIME_SLEEP);
    execve("/bin/echo", args, NULL);
    err(EXIT_FAILURE, "exec() failed");
}


static
void
parent (pid_t pid_c)
{
    printf("I'm parent!, my pid is %d and the pid of my child is %d\n",
            getpid(), pid_c);
    //sleep(TIME_SLEEP);
    exit(EXIT_SUCCESS);
}


int
main (void)
{
    pid_t ret;
    ret = fork();
    if (ret == -1)
        err(EXIT_FAILURE, "fork() failed");
    else if (ret == 0) 
        child();
    else
        parent(ret);

    err(EXIT_FAILURE, "Shouldn't reach here");
    return -1;
}

