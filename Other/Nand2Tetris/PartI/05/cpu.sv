`include "../03/pc.sv"
`ifndef and_16
    `include "../01/and_16.sv"
`endif
`ifndef alu_optimized
    `include "../02/alu_optimized.sv"
`endif

module cpu(
    input  [15:0] inM,
    input  [15:0] instruction,
    input         reset,
    input         clock,
    output [15:0] outM,
    output        writeM,
    output [15:0] addressM,
    output [15:0] pc
);
    // ALU: compute
    wire [15:0] alu_in1;
    wire [15:0] alu_in2;
    wire alu_out_zr, alu_out_ng;
    mux_16 select_m_or_a(addressM, inM, instruction[12], alu_in2);
    alu_optimized alu_computation(
        alu_in1,
        alu_in2,
        instruction[11],
        instruction[10],
        instruction[9],
        instruction[8],
        instruction[7],
        instruction[6],
        outM,
        alu_out_zr,
        alu_out_ng
    );

    /* decoding the current instruction: ixxaccccccdddjjj */
    // determines opcode
    wire a_instruction, c_instruction;
    not_n2t not_a_instruction(instruction[15], a_instruction);
    not_n2t not_c_instruction(a_instruction, c_instruction);

    /* exectuing the current instruction */
    // A register
    wire c_type_output2a;
    wire [15:0] value_instruction, value_dest_to_a;
    and_n2t and_c_type_dest_a(c_instruction, instruction[5], c_type_output2a); // the 1st d-bit: instruction[5]
    and_16 and_instruction_address(instruction, 16'b0111111111111111, value_instruction);
    mux_16 mux_c_type_dest_a(outM, value_instruction, c_type_output2a, value_dest_to_a);

    wire clk_n;
    not_n2t not_clk(clock, clk_n);

    wire load_a;
    or_n2t or_load_a(a_instruction, c_type_output2a, load_a);
    register_n2t register_load_a(value_dest_to_a, load_a, clk_n, addressM);

    // D register
    wire load_d;
    and_n2t and_load_d(c_instruction, instruction[4], load_d);
    register_n2t register_load_d(outM, load_d, clock, alu_in1);

    // LABLE: ALU

    // writeM
    and_n2t and_writeM(c_instruction, instruction[3], writeM);

    /* deciding which instruction to fetch and execute next */
    // jjj: [positive:zero:negative]
    wire jeq, jlt, jgt, jgt_n, jle;
    and_n2t and_jeq(alu_out_zr, instruction[1], jeq);
    and_n2t and_jlt(alu_out_ng, instruction[2], jlt);
    or_n2t or_jgt(jeq, jlt, jgt_n);
    not_n2t not_jgt(jgt_n, jgt);

    // jump or not
    wire jump_a, inc_pc;
    or_n2t or_jle(jeq, jlt, jle);
    or_n2t or_jump(jgt, jle, jump_a);
    not_n2t not_jump(jump_a, inc_pc);

    // if jump then pc = A else pc++
    pc pc_next(pc, jump_a, inc_pc, reset, clock, pc);

endmodule
