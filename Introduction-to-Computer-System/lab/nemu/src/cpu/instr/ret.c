#include "cpu/instr.h"

// RET transfers control to a return address located on the stack.
make_instr_func(ret_near) {
    print_asm_0("ret", "", 1);
    OPERAND mem;
    mem.type = OPR_MEM;
    mem.addr = cpu.esp;
    mem.sreg = SREG_DS;
    mem.data_size = data_size;
    operand_read(&mem);

    cpu.eip = mem.val; // return address
    cpu.esp += data_size / 8; // pop

    return 0;
}

make_instr_func(ret_near_imm16) {
    print_asm_0("ret", "", 3);
    OPERAND rel, mem;
    rel.type = OPR_IMM;
    rel.addr = eip + 1;
    rel.sreg = SREG_DS;
    rel.data_size = 16;

    operand_read(&rel);
    print_asm_1("ret", "", 1 + data_size / 8, &rel);

    mem.type = OPR_MEM;
    mem.addr = cpu.esp;
    mem.sreg = SREG_DS;
    mem.data_size = data_size;

    operand_read(&mem);

    cpu.eip = mem.val; // return address
    cpu.esp += data_size / 8; // pop

    cpu.esp += sign_ext(rel.val, 16); // pop imm16 bytes of parameters

    return 0;
}
