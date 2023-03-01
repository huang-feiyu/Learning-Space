`ifndef and_n2t
  `include "and_n2t.sv"
`endif
`define mux 1

module mux(
  input  a,
  input  b,
  input  select,
  output out
);

  wire select_and_b, not_select, not_select_and_a;
  and_n2t select_b(.a(select), .b(b), .out(select_and_b));
  not_n2t not_sel_n2t(.in(select), .out(not_select));
  and_n2t not_sel_and_a(.a(not_select), .b(a), .out(not_select_and_a));
  or_n2t mux(.a(select_and_b), .b(not_select_and_a), .out(out));

  // behavior description
  // assign out = (select) ? b : a;

endmodule
