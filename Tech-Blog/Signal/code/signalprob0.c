#include "csapp.c"

volatile long counter = 2;

void handler1(int sig) {
    sigset_t mask, prev_mask;

    Sigfillset(&mask);
    Sigprocmask(SIG_BLOCK, &mask, &prev_mask); // block sigs
    Sio_putl(--counter);
    Sigprocmask(SIG_SETMASK, &prev_mask, NULL); // restore sigs

    _exit(0);
}

int main() {
    pid_t pid;
    sigset_t mask, prev_mask;

    printf("%ld", counter);
    fflush(stdout);

    signal(SIGUSR1, handler1);
    if ((pid = Fork()) == 0) {
        while (1) {};
    }
    Kill(pid, SIGUSR1);
    Waitpid(-1, NULL, 0);

    Sigfillset(&mask);
    Sigprocmask(SIG_BLOCK, &mask, &prev_mask); // block sigs
    printf("%ld", ++counter);
    Sigprocmask(SIG_SETMASK, &prev_mask, NULL); // restore sigs

    exit(0);
}

