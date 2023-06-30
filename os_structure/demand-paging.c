/*
 * In this script, ...
 */

#include <unistd.h>     // Unix(Posix) standard
#include <time.h>
#include <stdio.h>
#include <stdlib.h>     // Standard library
#include <string.h> 
#include <err.h>        // Error outputs

#define BUFFER_SIZE (100 * 1024 * 1024)
#define N_CYCLE     10
#define PAGE_SIZE   4096

int
main
(void)
{
    time_t t;
    char* s;
    char* p;

    t = time(NULL);
    s = ctime(&t);
    printf("%.*s: before allocation, please press Enter key\n", 
            (int)(strlen(s) - 1), s);
    // %5s, str      : 5 characters of str.
    // %*s, len, str : "len" number of characters of str.
    // %.*s, len, str: "len" number of character of non-Cstring str.
    getchar();

    p = malloc(BUFFER_SIZE);
    if (p == NULL) 
        err(EXIT_FAILURE, "malloc() failed");


    t = time(NULL);
    s = ctime(&t);
    printf("%.*s: allocated %dMB, please press Enter key\n", 
            (int)(strlen(s) - 1), s, BUFFER_SIZE / (1024*1024));
    getchar();


    int i;
    for (i=0; i<BUFFER_SIZE; i+=PAGE_SIZE) {
        p[i] = 0;
        int cycle = i / (BUFFER_SIZE/N_CYCLE);
        if (cycle != 0 && i % (BUFFER_SIZE/N_CYCLE) == 0) {
            t = time(NULL);
            s = ctime(&t);
            printf("%.*s: touched %dMB.\n",
                    (int)(strlen(s) - 1), s, i/(1024*1024));
            sleep(1);
        }
    }

    t = time(NULL);
    s = ctime(&t);
    printf("%.*s: touched %dMB, please press Enter key\n",
            (int)(strlen(s) - 1), s, BUFFER_SIZE / (1024*1024));
    getchar();

    exit(EXIT_SUCCESS);

}



