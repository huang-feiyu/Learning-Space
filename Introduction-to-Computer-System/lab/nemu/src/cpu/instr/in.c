#include "cpu/instr.h"
#include "device/port_io.h"

/* IN transfers a data byte or data word from the port numbered by the
 * second operand into the register (AL, AX, or EAX) specified by the first
 * operand. Access any port from 0 to 65535 by placing the port number
 * in the DX register and using an IN instruction with DX as the second
 * parameter. These I/O instructions can be shortened by using an 8-bit
 * port I/O in the instruction. The upper eight bits of the port address will
 * be 0 when 8-bit port I/O is used.
 **/
make_instr_func(in_b) {
    print_asm_0("in", "b", 1);
    cpu.eax = pio_read(cpu.edx, 1);
    return 1;
}

make_instr_func(in_v) {
    print_asm_0("in", data_size == 16 ? "w" : "l", 1);
    cpu.eax = pio_read(cpu.edx, data_size / 8);
    return 1;
}
