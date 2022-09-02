// Linux port of xv6-riscv shell (no libc)
// Compile with "-ffreestanding"!
// from: https://jyywiki.cn/pages/OS/2022/demos/sh-xv6.c

#include <fcntl.h>
#include <stdarg.h>
#include <stddef.h>
#include <sys/syscall.h>

// Parsed command representation
enum { EXEC = 1,
       REDIR,
       PIPE,
       LIST,
       BACK };

#define MAXARGS 10
#ifdef NULL
#undef NULL
#endif
#define NULL ((void*)0)

/* parent class */
struct cmd {
    int type;
};

/* child classes */
struct execcmd {
    int type;
    char *argv[MAXARGS], *eargv[MAXARGS];
};

struct redircmd {
    int type, fd, mode;
    char *file, *efile;
    struct cmd* cmd;
};

struct pipecmd {
    int type;
    struct cmd *left, *right;
};

struct listcmd {
    int type;
    struct cmd *left, *right;
};

struct backcmd {
    int type;
    struct cmd* cmd;
};

struct cmd* parsecmd(char*);

// Minimum runtime library
long syscall(int num, ...) {
    /**
     * protocol between user and designer
     *
     * args (refers to "man syscall" for further information)
     * 1. long: %rdi
     * 2. long: %rsi
     * 3. long: %rdx
     * 4. long: %r10
     *
     * ... %r8, %r9
     */
    va_list ap;
    va_start(ap, num);
    register long a0 asm("rax") = num;  // return value
    register long a1 asm("rdi") = va_arg(ap, long);
    register long a2 asm("rsi") = va_arg(ap, long);
    register long a3 asm("rdx") = va_arg(ap, long);
    register long a4 asm("r10") = va_arg(ap, long);
    va_end(ap);
    asm volatile("syscall"                               // assembler template
                 : "+r"(a0)                              // output operands
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4)    // input operands
                 : "memory", "rcx", "r8", "r9", "r11");  // list of clobbered registers
    return a0;
}

size_t strlen(const char* s) {
    size_t len = 0;
    for (; *s; s++) len++;
    return len;
}

char* strchr(const char* s, int c) {
    for (; *s; s++) {
        if (*s == c) return (char*)s;
    }
    return NULL;
}

void print(const char* s, ...) {
    va_list ap;
    va_start(ap, s);
    while (s) {
        syscall(SYS_write, 2, s, strlen(s));
        s = va_arg(ap, const char*);
    }
    va_end(ap);
}

// NOTE: Weird do-while loop
#define assert(cond)                    \
    do {                                \
        if (!(cond)) {                  \
            print("Panicked.\n", NULL); \
            syscall(SYS_exit, 1);       \
        }                               \
    } while (0)

/**
 * A simple free list, just allocate memory linearly
 */
static char mem[4096], *freem = mem;

void* zalloc(size_t sz) {
    assert(freem + sz < mem + sizeof(mem));
    void* ret = freem;
    freem += sz;
    return ret;
}

// Execute cmd.  Never returns.
void runcmd(struct cmd* cmd) {
    int p[2];
    struct backcmd* bcmd;   // &
    struct execcmd* ecmd;   // execute
    struct listcmd* lcmd;   // ;
    struct pipecmd* pcmd;   // |
    struct redircmd* rcmd;  // <, >, +(>>)

    if (cmd == 0) syscall(SYS_exit, 1);

    switch (cmd->type) {
        // cmd - just execute cmd
        case EXEC:
            ecmd = (struct execcmd*)cmd;
            if (ecmd->argv[0] == 0) syscall(SYS_exit, 1);
            syscall(SYS_execve, ecmd->argv[0], ecmd->argv, NULL);
            print("fail to exec ", ecmd->argv[0], "\n", NULL);
            break;

        // cmd [><+] file - cmd write to its file descriptor
        case REDIR:
            rcmd = (struct redircmd*)cmd;
            syscall(SYS_close, rcmd->fd);
            if (syscall(SYS_open, rcmd->file, rcmd->mode, 0644) < 0) {
                print("fail to open ", rcmd->file, "\n", NULL);
                syscall(SYS_exit, 1);
            }
            runcmd(rcmd->cmd);
            break;

        // left ; right - fork a child execute left, parent execute right (no dependency)
        case LIST:
            lcmd = (struct listcmd*)cmd;
            if (syscall(SYS_fork) == 0) runcmd(lcmd->left);
            syscall(SYS_wait4, -1, 0, 0, 0);
            runcmd(lcmd->right);
            break;

        // left | right - left's stdout connects to right's stdout
        // for further information, build a state-machine or `man dash` Pipelines Sections
        case PIPE:
            pcmd = (struct pipecmd*)cmd;
            assert(syscall(SYS_pipe, p) >= 0);
            if (syscall(SYS_fork) == 0) {
                syscall(SYS_close, 1); // stdout
                syscall(SYS_dup, p[1]);
                syscall(SYS_close, p[0]);
                syscall(SYS_close, p[1]);
                runcmd(pcmd->left); // never returns
            }
            if (syscall(SYS_fork) == 0) {
                syscall(SYS_close, 0); // stdin
                syscall(SYS_dup, p[0]);
                syscall(SYS_close, p[0]);
                syscall(SYS_close, p[1]);
                runcmd(pcmd->right); // never returns
            }
            syscall(SYS_close, p[0]);
            syscall(SYS_close, p[1]);
            syscall(SYS_wait4, -1, 0, 0, 0);
            syscall(SYS_wait4, -1, 0, 0, 0);
            break;

        // cmd & - fork a child to execute cmd, do not wait for it
        case BACK:
            bcmd = (struct backcmd*)cmd;
            if (syscall(SYS_fork) == 0) runcmd(bcmd->cmd);
            break;

        default:
            assert(0);
    }
    syscall(SYS_exit, 0);
}

int getcmd(char* buf, int nbuf) {
    print("> ", NULL);
    for (int i = 0; i < nbuf; i++) buf[i] = '\0';

    while (nbuf-- > 1) {
        int nread = syscall(SYS_read, 0, buf, 1);
        if (nread <= 0) return -1;
        if (*(buf++) == '\n') break;
    }
    return 0;
}

void _start() {
    static char buf[100];

    // Read and run input commands .
    while (getcmd(buf, sizeof(buf)) >= 0) {
        if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
            // Chdir must be called by the parent, not the child.
            buf[strlen(buf) - 1] = 0;  // chop \n
            if (syscall(SYS_chdir, buf + 3) < 0)
                print("cannot cd ", buf + 3, "\n", NULL);
            continue;
        } else if (buf[0] == 'e' && buf[1] == 'x' && buf[2] == 'i' && buf[3] == 't') {
            syscall(SYS_exit, 0);
        }
        if (syscall(SYS_fork) == 0) runcmd(parsecmd(buf));
        syscall(SYS_wait4, -1, 0, 0, 0);
    }
    syscall(SYS_exit, 0);
}

// Constructors

struct cmd* execcmd(void) {
    struct execcmd* cmd;

    cmd = zalloc(sizeof(*cmd));
    cmd->type = EXEC;
    return (struct cmd*)cmd;
}

struct cmd* redircmd(struct cmd* subcmd, char* file, char* efile, int mode,
                     int fd) {
    struct redircmd* cmd;

    cmd = zalloc(sizeof(*cmd));
    cmd->type = REDIR;
    cmd->cmd = subcmd;
    cmd->file = file;
    cmd->efile = efile;
    cmd->mode = mode;
    cmd->fd = fd;
    return (struct cmd*)cmd;
}

struct cmd* pipecmd(struct cmd* left, struct cmd* right) {
    struct pipecmd* cmd;

    cmd = zalloc(sizeof(*cmd));
    cmd->type = PIPE;
    cmd->left = left;
    cmd->right = right;
    return (struct cmd*)cmd;
}

struct cmd* listcmd(struct cmd* left, struct cmd* right) {
    struct listcmd* cmd;

    cmd = zalloc(sizeof(*cmd));
    cmd->type = LIST;
    cmd->left = left;
    cmd->right = right;
    return (struct cmd*)cmd;
}

struct cmd* backcmd(struct cmd* subcmd) {
    struct backcmd* cmd;

    cmd = zalloc(sizeof(*cmd));
    cmd->type = BACK;
    cmd->cmd = subcmd;
    return (struct cmd*)cmd;
}

// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char** ps, char* es, char** q, char** eq) {
    char* s;
    int ret;

    s = *ps;
    while (s < es && strchr(whitespace, *s)) s++;
    if (q) *q = s;
    ret = *s;
    switch (*s) {
        case 0:
            break;
        case '|':
        case '(':
        case ')':
        case ';':
        case '&':
        case '<':
            s++;
            break;
        case '>':
            s++;
            if (*s == '>') {
                ret = '+';
                s++;
            }
            break;
        default:
            ret = 'a';
            while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s)) s++;
            break;
    }
    if (eq) *eq = s;

    while (s < es && strchr(whitespace, *s)) s++;
    *ps = s;
    return ret;
}

int peek(char** ps, char* es, char* toks) {
    char* s;

    s = *ps;
    while (s < es && strchr(whitespace, *s)) s++;
    *ps = s;
    return *s && strchr(toks, *s);
}

struct cmd* parseline(char**, char*);
struct cmd* parsepipe(char**, char*);
struct cmd* parseexec(char**, char*);
struct cmd* nulterminate(struct cmd*);

struct cmd* parsecmd(char* s) {
    char* es;
    struct cmd* cmd;

    es = s + strlen(s);
    cmd = parseline(&s, es);
    peek(&s, es, "");
    assert(s == es);
    nulterminate(cmd);
    return cmd;
}

struct cmd* parseline(char** ps, char* es) {
    struct cmd* cmd;

    cmd = parsepipe(ps, es);
    while (peek(ps, es, "&")) {
        gettoken(ps, es, 0, 0);
        cmd = backcmd(cmd);
    }
    if (peek(ps, es, ";")) {
        gettoken(ps, es, 0, 0);
        cmd = listcmd(cmd, parseline(ps, es));
    }
    return cmd;
}

struct cmd* parsepipe(char** ps, char* es) {
    struct cmd* cmd;

    cmd = parseexec(ps, es);
    if (peek(ps, es, "|")) {
        gettoken(ps, es, 0, 0);
        cmd = pipecmd(cmd, parsepipe(ps, es));
    }
    return cmd;
}

struct cmd* parseredirs(struct cmd* cmd, char** ps, char* es) {
    int tok;
    char *q, *eq;

    while (peek(ps, es, "<>")) {
        tok = gettoken(ps, es, 0, 0);
        assert(gettoken(ps, es, &q, &eq) == 'a');
        switch (tok) {
            case '<':
                cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
                break;
            case '>':
                cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREAT | O_TRUNC, 1);
                break;
            case '+':  // >>
                cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREAT, 1);
                break;
        }
    }
    return cmd;
}

struct cmd* parseblock(char** ps, char* es) {
    struct cmd* cmd;

    assert(peek(ps, es, "("));
    gettoken(ps, es, 0, 0);
    cmd = parseline(ps, es);
    assert(peek(ps, es, ")"));
    gettoken(ps, es, 0, 0);
    cmd = parseredirs(cmd, ps, es);
    return cmd;
}

struct cmd* parseexec(char** ps, char* es) {
    char *q, *eq;
    int tok, argc;
    struct execcmd* cmd;
    struct cmd* ret;

    if (peek(ps, es, "(")) return parseblock(ps, es);

    ret = execcmd();
    cmd = (struct execcmd*)ret;

    argc = 0;
    ret = parseredirs(ret, ps, es);
    while (!peek(ps, es, "|)&;")) {
        if ((tok = gettoken(ps, es, &q, &eq)) == 0) break;
        assert(tok == 'a');
        cmd->argv[argc] = q;
        cmd->eargv[argc] = eq;
        assert(++argc < MAXARGS);
        ret = parseredirs(ret, ps, es);
    }
    cmd->argv[argc] = 0;
    cmd->eargv[argc] = 0;
    return ret;
}

// NUL-terminate all the counted strings.
struct cmd* nulterminate(struct cmd* cmd) {
    int i;
    struct backcmd* bcmd;
    struct execcmd* ecmd;
    struct listcmd* lcmd;
    struct pipecmd* pcmd;
    struct redircmd* rcmd;

    if (cmd == 0) return 0;

    switch (cmd->type) {
        case EXEC:
            ecmd = (struct execcmd*)cmd;
            for (i = 0; ecmd->argv[i]; i++) *ecmd->eargv[i] = 0;
            break;

        case REDIR:
            rcmd = (struct redircmd*)cmd;
            nulterminate(rcmd->cmd);
            *rcmd->efile = 0;
            break;

        case PIPE:
            pcmd = (struct pipecmd*)cmd;
            nulterminate(pcmd->left);
            nulterminate(pcmd->right);
            break;

        case LIST:
            lcmd = (struct listcmd*)cmd;
            nulterminate(lcmd->left);
            nulterminate(lcmd->right);
            break;

        case BACK:
            bcmd = (struct backcmd*)cmd;
            nulterminate(bcmd->cmd);
            break;
    }
    return cmd;
}
