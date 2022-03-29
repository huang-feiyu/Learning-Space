#include "cpu/instr.h"

// Load Interrupt Descriptor Table Register
make_instr_func(lidt) {
    OPERAND rel;

    int len = 1;
    len += modrm_rm(eip + 1, &rel);

#ifdef IA32_INTR
    rel.data_size = 16;
    operand_read(&rel);
    cpu.idtr.limit = rel.val;

    rel.addr += 2;
    rel.data_size = 32;
    operand_read(&rel);
    cpu.idtr.base = rel.val;
#endif

    print_asm_1("lidt", "", len, &rel);
    return len;
}
