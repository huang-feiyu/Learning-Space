`ifndef ram_4K
    `include "ram_4K.sv"
`endif
`ifndef dmux_4_way
    `include "../01/dmux_4_way.sv"
`endif
`ifndef mux_4_way_16
    `include "../01/mux_4_way_16.sv"
`endif
`define ram_16K 1

module ram_16K(
    input  [15:0] in,
    input  [13:0] address,
    input         load,
    input         clock,
    output [15:0] out
);

    wire load_0, load_1, load_2, load_3;
    dmux_4_way load_4_way(load, address[13:12],
            load_0,
            load_1,
            load_2,
            load_3);

    wire [15:0] out_0, out_1, out_2, out_3;
    ram_4K _ram_0(in, address[11:0], load_0, clock, out_0);
    ram_4K _ram_1(in, address[11:0], load_1, clock, out_1);
    ram_4K _ram_2(in, address[11:0], load_2, clock, out_2);
    ram_4K _ram_3(in, address[11:0], load_3, clock, out_3);

    mux_4_way_16 out_4_way(
            out_0,
            out_1,
            out_2,
            out_3,
            address[13:12], out);

endmodule
