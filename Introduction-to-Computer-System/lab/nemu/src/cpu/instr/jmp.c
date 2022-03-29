#include "cpu/instr.h"

make_instr_func(jmp_near) {
    // jmp near, displacement relative to next instruction
    OPERAND rel;
    rel.type = OPR_IMM;
    rel.sreg = SREG_CS;
    rel.data_size = data_size;
    rel.addr = eip + 1;

    operand_read(&rel);

    int offset = sign_ext(rel.val, data_size);
    print_asm_1("jmp", "", 1 + data_size / 8, &rel);

    cpu.eip += offset;

    return 1 + data_size / 8;
}

// data_size = 8
make_instr_func(jmp_short) {
    OPERAND rel;
    rel.type = OPR_IMM;
    rel.sreg = SREG_CS;
    rel.data_size = 8;
    rel.addr = eip + 1;

    operand_read(&rel);
    print_asm_1("jmp", "", 2, &rel);

    int offset = sign_ext(rel.val, rel.data_size);
    cpu.eip += offset;

    // WRONG: return 1 + data_size / 8;
    return 2;
}

// an indirect function call where the address we call is loaded from memory
// instead of being specified right there
make_instr_func(jmp_near_indirect) {
    int len = 1;
    OPERAND rel;
    rel.data_size = data_size;
    len += modrm_rm(eip + 1, &rel);
    operand_read(&rel);
    print_asm_1("jmp", "", len, &rel);

    cpu.eip = (data_size == 16 ? rel.val & 0xffff : rel.val);

    return 0;
}

/* Direct JMP instructions that specify a target location outside the current
 * code segment contain a far pointer. This pointer consists of a selector for
 * the new code segment and an offset within the new segment.
 **/
// The far control-transfer instructions transfer control to a location in
// another segment by changing the content of the CS register.
make_instr_func(jmp_far_imm) {
    // The JMP ptr16:16 and ptr16:32 forms of the instruction use a four-byte or
    // six-byte operand as a long pointer to the destination. The JMP and forms
    // fetch the long pointer from the memory location specified (indirection).
    OPERAND rel;
    rel.type = OPR_IMM;
    rel.sreg = SREG_CS;
    rel.data_size = 32;
    rel.addr = eip + 1;
    operand_read(&rel);
    cpu.eip = (data_size == 16 ? rel.val & 0xffff : rel.val);
    print_asm_1("ljmp", "", 1 + 6, &rel);

    cpu.cs.val = instr_fetch(eip + 5, 2);
    load_sreg(1); // Load CS

    return 0;
}
