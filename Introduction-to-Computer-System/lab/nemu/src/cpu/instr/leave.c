#include "cpu/instr.h"

// By copying the frame pointer to the stack pointer, LEAVE releases the stack
// space used by a procedure for its local variables. The old frame pointer is
// popped into BP or EBP, restoring the caller's frame. A subsequent RET
// instruction removes any arguments pushed onto the stack of the exiting procedure.
make_instr_func(leave) {
    // movl %ebp, %esp
    // popl %ebp
    print_asm_0("leave", "", 1);

    cpu.esp = cpu.ebp;

    OPERAND mem;
    mem.type = OPR_MEM;
    mem.addr = cpu.esp;
    mem.sreg = SREG_DS;
    mem.data_size = data_size;
    operand_read(&mem);

    cpu.ebp = mem.val; // OLD frame pointer is popped into EBP
    cpu.esp += data_size / 8;

    return 1;
}
