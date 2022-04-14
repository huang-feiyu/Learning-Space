`ifndef mux
  `include "mux.sv"
`endif
`define mux_16 1

module mux_16(
  input  [15:0] a,
  input  [15:0] b,
  input         select,
  output [15:0] out
);

  generate
    genvar i;
    for (i = 0; i < 16; i++) begin
      mux #(i) mux_inst(a[i], b[i], select, out[i]);
    end
  endgenerate

endmodule
