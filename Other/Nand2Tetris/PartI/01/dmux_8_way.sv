`ifndef dmux_4_way
  `include "dmux_4_way.sv"
`endif
`define dmux_8_way 1

module dmux_8_way(
  input       in,
  input [2:0] select,
  output      a,
  output      b,
  output      c,
  output      d,
  output      e,
  output      f,
  output      g,
  output      h
);

  wire low, high;
  dmux #(1) mux_inst(in, select[2], low, high);
  dmux_4_way #(1) dmux_inst_1(low , select[1:0], a, b, c, d);
  dmux_4_way #(2) dmux_inst_2(high, select[1:0], e, f, g, h);

endmodule
