/*
 * Traffic Light Controller
 * input clock 50mhz assumed
 * slowclk @ 10hz
 * direction: a - NS, b - EW
 */
module trafficlight (
    output reg reda,
    output reg yellowa,
    output reg greena,
    output reg redb,
    output reg yellowb,
    output reg greenb,
    input wire i_clk,
    input wire i_rst_n
);
    `define START   3'b111      // init state, all red
    `define NS      3'b011      // north/south green
    `define NY      3'b010      // north/south yellow
    `define EW      3'b000      // east/west green
    `define EY      3'b001      // east/west yellow

    wire [2:0] state;
    wire slowclk;

    onehzclk #(.COMPARE(2500000-1), .WIDTH(22)) the_clk(
        .o_clk(slowclk),
        .i_clk(i_clk),
        .i_rst_n(i_rst_n)
    );

    tlfsm #(.T_WIDTH(12), .NS_TIME(12'd90), .EW_TIME(12'd60), .Y_TIME(12'd30)) the_fsm(
        .o_state(state),
        .i_clk(slowclk),
        .i_rst_n(i_rst_n)
    );

    always @* begin
        case (state)
            `START:     {reda, yellowa, greena, redb, yellowb, greenb} = #1 6'b100100;
            `NS:        {reda, yellowa, greena, redb, yellowb, greenb} = #1 6'b001100;
            `NY:        {reda, yellowa, greena, redb, yellowb, greenb} = #1 6'b010100;
            `EW:        {reda, yellowa, greena, redb, yellowb, greenb} = #1 6'b100001;
            `EY:        {reda, yellowa, greena, redb, yellowb, greenb} = #1 6'b100010;
            default:    {reda, yellowa, greena, redb, yellowb, greenb} = #1 6'bzzzzzz;
        endcase
    end

endmodule
