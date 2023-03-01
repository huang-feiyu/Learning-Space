`ifndef inc_16
    `include "../02/inc_16.sv"
`endif
`ifndef mux_16
    `include "../01/mux_16.sv"
`endif
`ifndef or_n2t
    `include "../01/or_n2t.sv"
`endif
`ifndef register_n2t
    `include "register_n2t.sv"
`endif
`define pc 1

module pc(
    input  [15:0] in,
    input         load,
    input         inc,
    input         reset,
    input         clk,
    output [15:0] out
);

    wire [15:0] incd;
    inc_16 inc_16_inst(out, incd);

    wire [15:0] o, u, uu;
    mux_16 inc_sel_or_not(out, incd, inc, o);
    mux_16 inc_load_or_not(o, in, load, u);
    mux_16 inc_reset_or_not(u, 16'b0, reset, uu);

    register_n2t reg_n2t_inst(uu, 1, clk, out);

endmodule