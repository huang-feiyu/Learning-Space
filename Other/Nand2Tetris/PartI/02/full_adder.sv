`ifndef half_adder
  `include "half_adder.sv"
`endif
`define full_adder 1

module full_adder(
  input  a,
  input  b,
  input  c,
  output carry,
  output sum
);

  wire sum_ab, carry_1, carry_2;
  half_adder #(1) half_adder_inst_1(a, b, carry_1, sum_ab);
  half_adder #(2) half_adder_inst_2(sum_ab, c, carry_2, sum);
  or_n2t #(3) or_inst(carry_1, carry_2, carry);

endmodule
