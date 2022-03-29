#include "cpu/instr.h"

// INC adds 1 to the operand. It does not change the carry flag.
// To affect the carry flag, use the ADD instruction with a second operand of 1.
static void instr_execute_1op() {
    operand_read(&opr_src);
    bool temp = cpu.eflags.CF;
    opr_src.val = alu_add(1, opr_src.val, data_size);
    cpu.eflags.CF = temp;
	operand_write(&opr_src);
}

make_instr_impl_1op(inc, r, v)
make_instr_impl_1op(inc, rm, v)
