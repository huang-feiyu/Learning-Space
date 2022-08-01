`ifndef mux
    `include "../01/mux.sv"
`endif
`ifndef dff
    `include "dff.sv"
`endif
`define bit_n2t 1

module bit_n2t(
    input  in,
    input  load,
    input  clk,
    output out
);

    wire dff_in;
    mux mux_load(out, in, load, dff_in);
    dff dff_out(dff_in, clk, out);

endmodule
