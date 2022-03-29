#include "nemu.h"
#include "cpu/reg.h"
#include "memory/memory.h"

#include <stdlib.h>

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <sys/types.h>
#include <regex.h>

enum {
    NOTYPE = 256, // <SPACE>
    EQ,
    NEQ,
    NUM,
    HEX,
    REG,
    AND,
    OR,
    NOT,
    LETTER,
    DEREF,
    NEG
};

static struct rule {
    char *regex;
    int token_type;
} rules[] = {
    {" +", NOTYPE}, // white space
    {"==", EQ},
    {"!=", NEQ},
    {"\\b[0-9]+\\b", NUM},
    {"\\b0[xX][0-9a-fA-F]+\\b", HEX},
    {"\\$[a-zA-Z]+", REG},
    {"\\+", '+'},
    {"-", '-'}, // minus or negative
    {"\\*", '*'}, // multiply or De-reference
    {"/", '/'},
    {"\\(", '('},
    {"\\)", ')'},
    {"&&", AND},
    {"\\|\\|", OR},
    {"!", NOT},
    {"\\b[a-zA-Z]+\\b", LETTER}
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]))

static regex_t re[NR_REGEX];

void is_op(int);

/* Rules are used for more times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
    int i;
    char error_msg[128];
    int ret;

    for (i = 0; i < NR_REGEX; i++) {
        ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
        if (ret != 0) {
            regerror(ret, &re[i], error_msg, 128);
            assert(ret != 0);
        }
    }
}

typedef struct token {
    int type;
    char str[32];
} Token;

Token tokens[32];
int nr_token;

static bool make_token(char *e) {
    int position = 0;
    int i;
    regmatch_t pmatch;

    nr_token = 0;

    while (e[position] != '\0') {
        /* Try all rules one by one. */
        for (i = 0; i < NR_REGEX; i++) {
            if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
                char *substr_start = e + position;
                int substr_len = pmatch.rm_eo;

                printf("match regex[%d] at position %d with len %d: %.*s\n",
                       i, position, substr_len, substr_len, substr_start);
                position += substr_len;
                // Now a new token is recognized with rules[i].

                switch (rules[i].token_type) {
                case NOTYPE:
                    break;
                default:
                    strncpy(tokens[nr_token].str, substr_start, substr_len);
                    tokens[nr_token].str[substr_len] = '\0';
                    tokens[nr_token].type = rules[i].token_type;

                    if (tokens[nr_token].type == '-' || tokens[nr_token].type == '*') {
                        is_op(nr_token);
                    }
                    nr_token++;
                    break; // not necessary
                }
                break;
            }
        }

        if (i == NR_REGEX) {
            printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
            return false;
        }
    }

    return true;
}


int str2int(char *str, int type) {
    int ret = 0;
    if (type == NUM)
        sscanf(str, "%d", &ret);
    if (type == HEX)
        sscanf(str, "%x", &ret);
    if (type == REG) {
        bool success;
        get_reg_val(str + 1, &success); // remove `$`
        if (!success) {
            printf("str2int: Invalid register\n");
            assert(0);
        }
    }
    return ret;
}

// check start'(' and end')' and check if parentheses valid
bool check_parentheses(int start, int end) {
    if (tokens[start].type != '(' || tokens[end].type != ')')
        return false;

    int pos = 0, left_count = 0, flag = 0;
    for (int i = start; i <= end; i++) {
        if (tokens[i].type == '(')
            left_count++;
        if (tokens[i].type == ')')
            left_count--;
        if (flag == 0 && left_count == 0) {
            pos = i;
            flag = 1;
        }
    }

    if (left_count != 0) {
        printf("check_parentheses: invalid expression\n");
        assert(0);
    }

    return pos == end; // valid expression & like (expression)
}

// get priority of tokens. Reverse!
int get_priority(int type) {
    // cppreference: operator_precedence
    switch(type) {
    case NEG:
    case NOT:
    case DEREF:
        return 1;
    case '*':
    case '/':
        return 2;
    case '+':
    case '-':
        return 3;
    case EQ:
    case NEQ:
        return 4;
    case AND:
        return 5;
    case OR:
        return 6;
    default:
        return 0;
    }
}

// get dominant operator
int dominant_operator(int start, int end) {
    int op = 0, pos = 0;
    for (int i = start; i <= end; i++) {
        if (tokens[i].type == '(') {
            // token in "()" cannot be dominant operator
            int cnt = 1;
            do {
                i++;
                if (tokens[i].type == '(') cnt++;
                if (tokens[i].type == ')') cnt--;
            } while (cnt != 0);
            continue;
        }

        if (get_priority(tokens[i].type) >= get_priority(op)) {
            op = tokens[i].type;
            pos = i;
        }
    }
    return pos;
}

// evaluate. p: start; q: end
int eval(int p, int q) {
    if (p > q) {
        printf("Eval error\n");
        assert(0);
    } else if (p == q) {
        return str2int(tokens[p].str, tokens[p].type);
    } else if (check_parentheses(p, q) == true) {
        return eval(p + 1, q - 1); // just throw away the "()"
    } else {
        int op = dominant_operator(p, q); // position
        int op_type = tokens[op].type;
        printf("\033[1m\033[33m[main op]:\033[0m %d: %s, type %d\n",
                op, tokens[op].str, op_type);

        // unary operator
        if (p == op || get_priority(op_type) == 1) {
            int val = eval(p + 1, q);
            switch(op_type) {
            case NEG:
                return -val;
            case DEREF:
                return paddr_read(val, 4);
            case NOT:
                return !val;
            }
        }

        // binary operator
        int val1 = eval(p, op - 1);
        int val2 = eval(op + 1, q);
        switch(op_type) {
        case '+':
            return val1 + val2;
        case '-':
            return val1 - val2;
        case '*':
            return val1 * val2;
        case '/':
            return val1 / val2;
        case EQ:
            return val1 == val2;
        case NEQ:
            return val1 != val2;
        case AND:
            return val1 && val2;
        case OR:
            return val1 || val2;
        default:
            printf("eval: sth wrong in expr\n");
            assert(0);
        }
    }
}

uint32_t expr(char *e, bool *success) {
    if (!make_token(e)) {
        *success = false;
        return 0;
    }

    *success = true;
    return eval(0, nr_token - 1);
}

void is_op(int index) {
    if (index == 0 || (tokens[index - 1].type != NUM &&
                       tokens[index - 1].type != HEX &&
                       tokens[index - 1].type != REG &&
                       tokens[index - 1].type != ')' )) {

        if (tokens[index].type == '-') tokens[index].type = NEG;
        if (tokens[index].type == '*') tokens[index].type = DEREF;
    }
}
