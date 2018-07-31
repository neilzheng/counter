module trafficlighttb;
    reg clk;
    reg rst_n;

    trafficlight DUT(.i_clk(clk), .i_rst_n(rst_n));

    initial begin
        $dumpfile("trafficlight.vcd");
        $dumpvars(0, DUT);

        clk = 0;
        rst_n = 0;
        # 10
        rst_n = 1;

        # 10000
        $finish;
    end

    always #5 clk <= ~clk;
endmodule
