`ifndef and_n2t
    `include "../01/and_n2t.sv"
`endif
`ifndef dmux_8_way
    `include "../01/dmux_8_way.sv"
`endif
`ifndef mux_8_way_16
    `include "../01/mux_8_way_16.sv"
`endif
`ifndef register_n2t
    `include "register_n2t.sv"
`endif
`define ram_8 1

module ram_8(
    input  [15:0] in,
    input  [2:0]  address,
    input         load,
    input         clock,
    output [15:0] out
);

    wire load_0, load_1, load_2, load_3, load_4, load_5, load_6, load_7;
    // choose only one
    dmux_8_way load_8_way(load, address,
            load_0,
            load_1,
            load_2,
            load_3,
            load_4,
            load_5,
            load_6,
            load_7);

    wire [15:0] out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7;
    register_n2t reg_0(in, load_0, clock, out_0);
    register_n2t reg_1(in, load_1, clock, out_1);
    register_n2t reg_2(in, load_2, clock, out_2);
    register_n2t reg_3(in, load_3, clock, out_3);
    register_n2t reg_4(in, load_4, clock, out_4);
    register_n2t reg_5(in, load_5, clock, out_5);
    register_n2t reg_6(in, load_6, clock, out_6);
    register_n2t reg_7(in, load_7, clock, out_7);

    mux_8_way_16 out_mux(
            out_0,
            out_1,
            out_2,
            out_3,
            out_4,
            out_5,
            out_6,
            out_7,
            address, out);

endmodule
