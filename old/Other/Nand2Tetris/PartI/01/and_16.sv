`ifndef and_n2t
  `include "and_n2t.sv"
`endif
`define and_16 1

module and_16(
  input  [15:0] a,
  input  [15:0] b,
  output [15:0] out
);

  generate
    genvar i;
    for (i = 0; i < 16; i++) begin
      and_n2t #(i) and_n2t_i(a[i], b[i], out[i]);
    end
  endgenerate

endmodule
