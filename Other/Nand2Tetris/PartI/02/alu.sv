`ifndef or_8_way
  `include "../01/or_8_way.sv"
`endif
`ifndef mux_16
  `include "../01/mux_16.sv"
`endif
`ifndef add_16
  `include "add_16.sv"
`endif
`ifndef and_16
  `include "and_16.sv"
`endif
`ifndef not_16
  `include "not_16.sv"
`endif
`define alu 1

module alu(
  input  [15:0] x,  // 16-bit input
  input  [15:0] y,  // 16-bit input
  input         zx, // zero the x input?
  input         nx, // negate the x input?
  input         zy, // zero the y input?
  input         ny, // negate the y input?
  input         f,  // out = f == 1 ? x + y : x & y
  input         no, // negate the output?
  output [15:0] out,
  output        zr, // out == 0
  output        ng  // out < 0
);

  wire [15:0] zdx, [15:0] notx, [15:0] ndx;
  mux_16 zero_the_x(x, [15:0] 0, zx, zdx);
  not_16 negate_the_x(zdx, notx);
  mux_16 x_or_notx(zdx, notx, nx, ndx);

  // same for y
  wire [15:0] zdy, [15:0] noty, [15:0] ndy;
  mux_16 zero_the_y(y, [15:0] 0, zy, zdy);
  not_16 negate_the_y(zdy, noty);
  mux_16 y_or_noty(zdy, noty, ny, ndy);

  // do the alu
  wire [15:0] xplusy, [15:0] xandy, [15:0] fxy, [15:0] nfxy;
  add_16 x_plus_y(zdx, zdy, xplusy);
  and_16 x_and_y(zdx, zdy, xandy);
  mux_16 f_x_and_y(xandy, xplusy, f, fxy);
  not_16 fxy_not(fxy, nfxy);
  mux_16 fxy_or_nfxy(fxy, nfxy, no, out);

  // set the flags
  wire temp_1, temp_2;
  wire [15:0] drop;
  or_8_way #(1) or_1(out[7:0], temp_1);
  or_8_way #(2) or_2(out[15:8], temp_2);
  or_n2t #(1) or_zr(temp_1, temp_2, zr);
  and_16 #(1) and_ng(out, [15:0] 0, drop);
  assign ng = drop[15];

endmodule
