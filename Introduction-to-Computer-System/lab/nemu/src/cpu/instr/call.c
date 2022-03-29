#include "cpu/instr.h"

// push then jmp without condition
make_instr_func(call_near) {
    OPERAND rel, mem;
    rel.type = OPR_IMM;
    rel.sreg = SREG_CS;
    rel.data_size = data_size;
    rel.addr = eip + 1;

    operand_read(&rel);
    int offset = sign_ext(rel.val, data_size);
    print_asm_1("call", "", 1 + data_size / 8, &rel);

    cpu.esp -= data_size / 8; // push downward
    mem.type = OPR_MEM;
    mem.addr = cpu.esp;
    mem.sreg = SREG_DS;
    mem.data_size = data_size;
    mem.val = cpu.eip + data_size / 8 + 1; // return address
    operand_write(&mem);

    cpu.eip += offset; // jmp without condition

    return data_size / 8 + 1;
}

// an indirect function call where the address we call is loaded from memory
// instead of being specified right there
make_instr_func(call_near_indirect) {
    int len = 1;
    OPERAND rel, mem;
    rel.data_size = data_size;
    len += modrm_rm(eip + 1, &rel); // refers to ModR/M
    operand_read(&rel);
    print_asm_1("call", "", len, &rel);

    cpu.esp -= data_size / 8; // push downward
    mem.type = OPR_MEM;
    mem.addr = cpu.esp;
    mem.sreg = SREG_DS;
    mem.data_size = data_size;
    mem.val = eip + len; // return address
    operand_write(&mem);

    // jmp without condition
    cpu.eip = (data_size == 16 ? rel.val & 0xffff : rel.val); // absolute

    return 0;
}
