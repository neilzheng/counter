/*
 * Compare Counter
 * decrease mode
 * count from load value to 0
 * default: count from { WIDTH{1'b1} } to 0
 * auto restarted on count finish
 * on each auto restart, o_clk is toggled
 */
module cntclk
#(
    parameter WIDTH = 16
) (
    output reg o_clk,                   // toggled on each auto restart
    output wire o_zero,                 // counter reaches zero, about to restart counting
    inout wire [WIDTH-1:0] io_value,    // current value, on load, fed load value
    input wire i_clk,                   // input clock
    input wire i_rst_n,                 // reset counter to default mode
    input wire i_load                   // load compare value, and restart counting
);

    wire [WIDTH-1:0] counter_value;
    wire counter_rstn;
    wire counter_restart;
    reg [1:0] counter_setup;
    reg [WIDTH-1:0] counter_loader;
    wire inner_rst_n;

    counter #(.WIDTH(WIDTH)) inner_counter (
        .io_value(counter_value),
        .o_match(o_zero),
        .i_clk(i_clk),
        .i_rst_n(counter_rstn),
        .i_restart(counter_restart),
        .i_setup(counter_setup)
    );

    assign counter_rstn = 1'b1;

    assign counter_restart = 1'b0;

    assign io_value = (i_load || (counter_setup != 2'b00)) ? { WIDTH{1'bz} } : counter_value;

    assign counter_value = (counter_setup != 2'b00) ? counter_loader : { WIDTH{1'bz} };

    assign inner_rst_n = (counter_setup == 2'b00) ? 1'b1 : 1'b0;

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter_setup <= #1 2'b11;
            counter_loader <= #1 { WIDTH{1'b1} };
        end else if (i_load) begin
            counter_loader <= #1 io_value;
            counter_setup <= #1 2'b11;
        end else begin
            counter_loader <= #1 { WIDTH{1'b0} };
            counter_setup <= #1 2'b00;
        end
    end

    always @(posedge o_zero, negedge inner_rst_n) begin
        if (!inner_rst_n) begin
            o_clk <= #1 1'b0;
        end else begin
            o_clk <= #1 !o_clk;
        end 
    end

endmodule
