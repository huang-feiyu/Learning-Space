`ifndef mux_4_way_16
    `include "../01/mux_4_way_16.sv"
`endif
`ifndef dmux_4_way
    `include "../01/dmux_4_way.sv"
`endif
`include "../03/ram_16K_optimized.sv"
`include "screen_8K.sv"

module memory(
    input [15:0]      in,
    input          clock,
    input           load,
    input [14:0] address,
    output[15:0]    out);

    wire loadM1, loadM2, loadS, loadK, loadM;
    dmux_4_way dmux_load(load, address[14:13], loadM1, loadM2, loadS, loadK);
    or_n2t or_load_M(loadM1, loadM2, loadM);

    // load RAM
    wire [15:0] ram_out;
    ram_16K_optimized ram_load(in, address[13:0], loadM, clock, ram_out);

    // load screen
    wire [15:0] screen_out;
    screen_8K screen_load(in, address[12:0], loadS, clock, screen_out);

    // load keyboard
    reg [15:0] scancode; // keyboard

    // output
    mux_4_way_16 mux_output(ram_out, ram_out, screen_out, scancode, address[14:13], out);

endmodule