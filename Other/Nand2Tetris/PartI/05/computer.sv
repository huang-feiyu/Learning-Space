`include "./cpu_jopdorp_optimized.sv"
`include "rom_32K.sv"
`include "memory.sv"

`define computer 1

module computer(
    input  reset,
    input  clock
);

    wire [14:0] pc;
    wire [15:0] instruction;
    rom_32K rom_32k_inst(pc, instruction);

    wire writeM;
    wire [15:0] inM;
    wire [15:0] outM;
    wire [14:0] addressM;
    cpu_jopdorp_optimized cpu_inst(
        inM,
        instruction,
        reset,
        clock,
        outM,
        writeM,
        addressM,
        pc
    );

    memory memory_inst(outM, clock, writeM, addressM, inM);

endmodule