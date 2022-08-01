`ifndef or_n2t
  `include "or_n2t.sv"
`endif
`define or_8_way 1

module or_8_way(
  input [7:0] in,
  output      out
);

  wire or_1, or_2, or_3, or_4, or_5, or_6;
  or_n2t #(1) or_inst_1(in[0], in[1], or_1);
  or_n2t #(2) or_inst_2(or_1 , in[2], or_2);
  or_n2t #(3) or_inst_3(or_2 , in[3], or_3);
  or_n2t #(4) or_inst_4(or_3 , in[4], or_4);
  or_n2t #(5) or_inst_5(or_4 , in[5], or_5);
  or_n2t #(6) or_inst_6(or_5 , in[6], or_6);
  or_n2t #(7) or_inst_7(or_6 , in[7], out );

endmodule
