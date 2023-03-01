`ifndef not_n2t
  `include "not_n2t.sv"
`endif
`define not_16 1

module not_16(
  input [15:0] in,
  output [15:0] out
);

  generate
    genvar i;
    for (i = 0; i < 16; i++) begin
      not_n2t #(i) not_n2t_i(in[i], out[i]);
    end
  endgenerate

endmodule
