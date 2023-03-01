`ifndef mux_4_way_16
  `include "mux_4_way_16.sv"
`endif
`define mux_8_way_16 1

module mux_8_way_16(
  input  [15:0] a,
  input  [15:0] b,
  input  [15:0] c,
  input  [15:0] d,
  input  [15:0] e,
  input  [15:0] f,
  input  [15:0] g,
  input  [15:0] h,
  input  [2:0]  select,
  output [15:0] out
);

  wire [15:0] out1;
  wire [15:0] out2;
  mux_4_way_16 #(1) mux_16_inst_1(a, b, c, d, select[1:0], out1);
  mux_4_way_16 #(2) mux_16_inst_2(e, f, g, h, select[1:0], out2);
  mux_16 #(3) mux_16_inst(out1, out2, select[2], out);

endmodule
