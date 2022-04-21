`ifndef ram_8
    `include "ram_8.sv"
`endif
`define ram_64 1

module ram_64(
    input  [15:0] in,
    input  [5:0]  address,
    input         load,
    input         clock,
    output [15:0] out
);

    wire load_0, load_1, load_2, load_3, load_4, load_5, load_6, load_7;
    dmux_8_way load_8_way(load, address[5:3],
            load_0,
            load_1,
            load_2,
            load_3,
            load_4,
            load_5,
            load_6,
            load_7);

    wire [15:0] out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7;
    ram_8 _ram_0(in, address[2:0], load_0, clock, out_0);
    ram_8 _ram_1(in, address[2:0], load_1, clock, out_1);
    ram_8 _ram_2(in, address[2:0], load_2, clock, out_2);
    ram_8 _ram_3(in, address[2:0], load_3, clock, out_3);
    ram_8 _ram_4(in, address[2:0], load_4, clock, out_4);
    ram_8 _ram_5(in, address[2:0], load_5, clock, out_5);
    ram_8 _ram_6(in, address[2:0], load_6, clock, out_6);
    ram_8 _ram_7(in, address[2:0], load_7, clock, out_7);

    mux_8_way_16 out_mux(
            out_0,
            out_1,
            out_2,
            out_3,
            out_4,
            out_5,
            out_6,
            out_7,
            address[5:3], out);
endmodule
