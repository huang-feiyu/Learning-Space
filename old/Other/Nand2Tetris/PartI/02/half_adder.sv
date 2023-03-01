`ifndef xor_n2t
  `include "../01/xor_n2t.sv"
`endif
`define half_adder 1

module half_adder(
  input  a,
  input  b,
  output carry,
  output sum
);

  xor_n2t #(1) xor_inst(a, b, sum);
  and_n2t #(2) and_inst(a, b, carry);

endmodule