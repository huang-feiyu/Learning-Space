`ifndef or_n2t
  `include "or_n2t.sv"
`endif
`define or_16 1

module or_16(
  input[15:0] a,
  input[15:0] b,
  output[15:0] out
);

  generate
    genvar i;
    for (i = 0; i < 16; i++) begin
      or_n2t #(i) or_n2t_inst(a[i], b[i], out[i]);
    end
  endgenerate

endmodule
