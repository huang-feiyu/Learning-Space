`ifndef bit_n2t
    `include "bit_n2t.sv"
`endif
`define register_n2t 1

module register_n2t(
    input  [15:0] in,
    input         load,
    input         clk,
    output [15:0] out
);

    generate
        genvar i;
        for (i = 0; i < 16; i++) begin
            bit_n2t bit_n2t(in[i], load, clk, out[i]);
        end
    endgenerate

endmodule