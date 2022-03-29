#include "cpu/instr.h"

// TEST computes the bit-wise logical AND of its two operands
// The result of the operation is discarded and only the flags are modified
static void instr_execute_2op() {
    operand_read(&opr_src);
    operand_read(&opr_dest);
    opr_src.val = sign_ext(opr_src.val, opr_src.data_size);
    opr_dest.val = sign_ext(opr_dest.val, opr_dest.data_size);
    alu_and(opr_src.val, opr_dest.val, data_size);
}

make_instr_impl_2op(test, i, a, b)
make_instr_impl_2op(test, i, a, v)
make_instr_impl_2op(test, i, rm, b)
make_instr_impl_2op(test, i, rm, v)
make_instr_impl_2op(test, r, rm, b)
make_instr_impl_2op(test, r, rm, v)
