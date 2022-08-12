# Signal

> A note about CSAPP Chapter 7: ECF.

## Process

Exception provides a basic construction block for process. Processes give
programs an illusion: It seems like our program is the only program running in
the OS.

Two important illusions:
* Programs engross the CPU: Logical control flow & Concurrency flow
* Programs engross the MEM: Private address space

---

* Get ID (PID)
```c
#include <sys/types.h>
#include <unistd.h>

pid_t getpid(void); // process PID
pid_t getppid(void); // parent process PID
```

* Create & Terminate
```c
// Create
#include <sys/types.h>
#include <unistd.h>

// the created child process is almostly same with parent process
// return two times:
//   * parent: PID of the created child process
//   * child: 0
pid_t fork(void);

// Terminate
#include <stdlib.h>

void exit(int status); // exit with status to terminate process
```

* Reap
```c
// a zombie process: a process that has terminated but not been reaped

#include <sys/types.h>
#include <sys/wait.h>

// wait for its child process to change state (terminated, stopped, resumed)
// pid: all child processes if pid < -1; the specific child process if pid > 0
pid_t waitpid(pid_t pid, int *statusp, int options);

// simple version of waitpid()
pid_t wait(int *statusp); // waitpid(-1, &status, 0)
```

* Sleep
```c
#include <unistd.h>

unsigned int sleep(unsigned int secs); // sleep for secs seconds

int pause(void); // sleep until a signal is received
```

* Load & Exec program
```c
#include <unistd.h>

// load and execute a new program in context
int execve(const char *filename, const char *argv[], const char *envp[]);
```

## Introduction to Signal

> In short, Signal is a high-level exception in software.

Signal is a little message to notify process system that an event happens. In
general, low-level hardware exception is processed by kernel. But signal
provides an approach to notify *user* that an event happens.

Transfer a signal to a destination process:
* send signal: (1) kernel detects a system event; (2) kernel calls `kill()`
* receive signal: use *signal handler* to catch the signal

## Manage Signal

* send signal
```c
/* 1. process group */
#include <unistd.h>

pid_t getpgrp(void); // get process group ID

int setpgid(pid_t pid, pid_t pgid); // set process group ID
// create a new group whose groud ID is pid, the only process is the caller process
setpgid(0, 0);

/* 2. use /bin/kill to sent signal to program */

/* 3. send signal from keyboard */

/* 4. use kill() to send signal */
#include <sys/types.h>
#include <signal.h>

int kill(pid_t pid, int sig);

/* 5. use alarm() to send signal */
#include <unistd.h>

unsigned int alarm(unsigned int secs);

```

* receive signal
```c
#include <signal.h>
typedef void (*sighandler_t)(int); // sighandler_t func = &my_func

// change the default behavior of a signal
sighandler_t signal(int signum, sighandler_t handler);
```

* block & unblock signal
```c
#include <signal.h>

// change blocked bit vector
// do stuff according to the how
int sigprocmask(int how, const sigset_t *set, sigset_t *oldset);
```

## Signal Handler

* Safe
    * KISS
    * ONLY use async-safe functions (figure 8-33)
    * Store and recover `errno`
    * Block all signal to protect the access to global data structure
    * Use `volatile` on a global variable to prevent compiler optimization (cache)
    * Use `sig_atomic_t` on flag to avoid interruption
* Correct
    * There is only one signal unhandled for each type
    * Cannot use signal to count events in other process
* Protablility
    * Use `Signal()` - Wrapper of `sigaction()`

## Error Handling

C programming language provides a user-level error handling mechanism, called
*nonlocal jump*.

`setjmp` is similar to `catch`, `longjmp` is similar to `longjmp`.

`setjmp` call once, return mutiple times. `longjmp` do not return.

```c
#include <setjmp.h>

int setjmp(jmp_buf env);
void longjmp(jmp_buf env, int retval);

// signal handler version
int sigsetjmp(sigjmp_buf env, int savesigs);
void siglongjmp(sigjmp_buf env, int retval);
```
