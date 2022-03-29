#include "cpu/instr.h"

make_instr_func(iret) {
    // refers to raise_instr(): Push EFLAGS, CS, EIP
    // => iret: Pop EIP, CS, EFLAGS
    cpu.eip = vaddr_read(cpu.esp, SREG_SS, 4);
    cpu.esp += 4; // eip
    cpu.cs.val = vaddr_read(cpu.esp, SREG_SS, 2);
    cpu.esp += 4; // 16-bit visible
    cpu.eflags.val = vaddr_read(cpu.esp, SREG_SS, 4);
    cpu.esp += 4; // eflags

    print_asm_0("iret", "", 1);
    //load_sreg(SREG_CS);
    return 0;
}
