`ifndef dmux
  `include "dmux.sv"
`endif
`define dmux_4_way 1

module dmux_4_way(
  input       in,
  input [1:0] sel,
  output      a,
  output      b,
  output      c,
  output      d
);

  wire in1, in2;
  dmux #(1) dmux_inst_1(in , sel[1], in1, in2);
  dmux #(2) dmux_inst_2(in1, sel[0], a  , b  );
  dmux #(3) dmux_inst_3(in2, sel[0], c  , d  );

endmodule
