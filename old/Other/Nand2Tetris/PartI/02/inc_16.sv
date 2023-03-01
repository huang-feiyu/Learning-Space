`ifndef add_16
  `include "add_16.sv"
`endif
`define inc_16 1

module inc_16(input [15:0] in, output [15:0] out);

  add_16 add_16_inst(in, 1, out);

endmodule