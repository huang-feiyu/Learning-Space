`ifndef and_n2t
  `include "and_n2t.sv"
`endif
`define dmux 1

module dmux(
  input  in,
  input  select,
  output a,
  output b
);

  and_n2t #(1) and_select_b(select, in, b);
  wire not_select;
  not_n2t not_select_n2t(select, not_select);
  and_n2t #(1) and_notsel_a(not_select, in, a);

endmodule
