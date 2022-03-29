#include "cpu/intr.h"
#include "cpu/instr.h"
#include "memory/memory.h"

void raise_intr(uint8_t intr_no) {
#ifdef IA32_INTR
    // Trigger an exception/interrupt with 'intr_no'
    uint32_t addr = (uint32_t)hw_mem + page_translate(segment_translate(cpu.idtr.base + 8 * intr_no, SREG_DS));
    // 'intr_no' is the index to the IDT
    GateDesc *gatedesc = (void *)addr;
    // Push EFLAGS, CS, and EIP
    cpu.esp -= 4;
    vaddr_write(cpu.esp, SREG_SS, 4, cpu.eflags.val);
    cpu.esp -= 4;
    vaddr_write(cpu.esp, SREG_SS, 2, cpu.cs.val);
    cpu.esp -= 4;
    vaddr_write(cpu.esp, SREG_SS, 4, cpu.eip);
    // Find the IDT entry using 'intr_no'
    // Clear IF if it is an interrupt
    if (gatedesc->type == 0xe) // interrupt gate, type = 1110
        cpu.eflags.IF = 1;
    else if (gatedesc->type == 0xf) // trap gate, type = 1111
        cpu.eflags.IF = 0;
    // Set EIP to the entry of the interrupt handler
    cpu.eip = (gatedesc->offset_31_16 << 16) + gatedesc->offset_15_0;
    // load_sreg(SREG_CS);
#endif
}

void raise_sw_intr(uint8_t intr_no) {
    // return address is the next instruction
    cpu.eip += 2;
    raise_intr(intr_no);
}
