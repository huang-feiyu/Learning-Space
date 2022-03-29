#include "cpu/instr.h"

/* POP replaces the previous contents of the memory, the register, or the
 * segment register operand with the word on the top of the 80386 stack.
 * The stack pointer SP is incremented by 2 for an operand-size of 16 bits or
 * by 4 for an operand-size of 32 bits. It then points to the new top of stack.
 **/
static void instr_execute_1op() {
    opr_dest.type = OPR_MEM;
    opr_dest.addr = cpu.esp;
    opr_dest.sreg = SREG_DS;
    opr_dest.data_size = data_size;

    operand_read(&opr_dest);
    opr_src.val = opr_dest.val;
    operand_write(&opr_src);

    cpu.esp += data_size / 8; // pop
}

make_instr_impl_1op(pop, r, v)
make_instr_impl_1op(pop, rm, v)

make_instr_func(popa) {
    opr_src.data_size = 32;
    opr_src.type = OPR_MEM;
    opr_src.sreg = SREG_DS;

    for (int i = 7; i >= 0; i--) {
        if (i != 4) { // skip esp/sp
            opr_src.addr = cpu.esp;
            operand_read(&opr_src);
            cpu.gpr[i].val = opr_src.val;
        }
        cpu.esp += 4;
    }

    print_asm_0("popa", "", 1);

    return 1;
}
