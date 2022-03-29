#include "cpu/instr.h"

/* PUSH decrements the stack pointer by 2 if the operand-size attribute of
 * the instruction is 16 bits; otherwise, it decrements the stack pointer by 4.
 * PUSH then places the operand on the new top of stack, which is pointed to by
 * the stack pointer.
 **/
static void instr_execute_1op() {
    operand_read(&opr_src);
    cpu.esp -= data_size / 8; // push downward
    opr_dest.type = OPR_MEM;
    opr_dest.addr = cpu.esp;
    opr_dest.sreg = SREG_DS;
    opr_dest.val = sign_ext(opr_src.val, opr_src.data_size);
    operand_write(&opr_dest);
}

make_instr_impl_1op(push, r, v)
make_instr_impl_1op(push, rm, v)
make_instr_impl_1op(push, i, v)

make_instr_func(push_i_b) {
    int len = 1; // push
    opr_src.type = OPR_IMM;
    opr_src.addr = eip + 1;
    opr_src.sreg = SREG_CS;
    opr_src.data_size = 8;

    len += opr_src.data_size / 8; // opr_src.data_size=8
    cpu.esp -= data_size / 8; // 16:2; 32:4
    print_asm_1("push", "b", len, &opr_src);

    operand_read(&opr_src);
    opr_src.val = sign_ext(opr_src.val, 8); // sign-extended

    opr_dest.type = OPR_MEM;
    opr_dest.addr = cpu.esp; // push downward stack
    opr_dest.sreg = SREG_DS;
    opr_dest.val = opr_src.val;
    opr_dest.data_size = data_size; // top of the stack
    operand_write(&opr_dest);

    return len;
}

// you can use #define, but i don't know how to use it
uint32_t is32_get_gpr_val(int num, bool is32) {
    // 0:eax, 1:ecx, 2:edx, 3:ebx, 4:esp, 5:ebp, 6:esi, 7:edi
    return is32 ? cpu.gpr[num]._32 : cpu.gpr[num]._16;
}

make_instr_func(pusha) {
    uint32_t temp = cpu.esp; // esp/sp

    opr_dest.data_size = 32;
    opr_dest.type = OPR_MEM;
    opr_dest.sreg = SREG_DS;

    for (int i = 0; i < 8; i++) {
        temp -= data_size >> 3;
        opr_dest.addr = temp;
        opr_dest.val = cpu.gpr[i].val;
        operand_write(&opr_dest);
    }
    cpu.esp = temp;

    print_asm_0("pusha", "", 1);

    return 1;
}
