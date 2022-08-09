#include "csapp.c"

void sigint_handler(int sig) {
    printf("Caught SIGINT!\n");
    exit(0);
}

int main() {
    // install the SIGINT handler
    if (signal(SIGINT, sigint_handler) == SIG_ERR)
        unix_error("signal error");
    Pause();

    return 0;
}
