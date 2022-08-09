#include "csapp.c"

int main() {
    // pid_t pid;
    // int x = 1;

    // pid = Fork();
    // if (pid == 0) {
    //     // child
    //     printf("child : x=%d\n", ++x);
    //     exit(0);
    // }

    // // parent
    // printf("parent: x=%d\n", --x);
    // exit(0);

    int x = 1;

    if (Fork() == 0) {
        printf("p1: x=%d\n", ++x);
    }
    printf("p2: x=%d\n", --x);
    exit(0);
}
