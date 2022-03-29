#include "cpu/instr.h"
#include "device/port_io.h"

/* OUT transfers a data byte or data word from the register (AL, AX, or
 * EAX) given as the second operand to the output port numbered by the
 * first operand. Output to any port from 0 to 65535 is performed by placing
 * the port number in the DX register and then using an OUT instruction
 * with DX as the first operand. If the instruction contains an eight-bit port
 * ID, that value is zero-extended to 16 bits.
 **/
make_instr_func(out_b) {
    print_asm_0("out", "b", 1);
    pio_write(cpu.edx, 1, cpu.eax);
    return 1;
}

make_instr_func(out_v) {
    print_asm_0("out", data_size == 16 ? "w" : "l", 1);
    pio_write(cpu.edx, data_size / 8, cpu.eax);
    return 1;
}
