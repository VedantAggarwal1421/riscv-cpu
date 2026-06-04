`timescale 1ns/1ns

module cpu_tb();
    reg clk;
    reg reset;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    CPU DUT(.clk(clk), .reset(reset));
    initial begin
        reset = 1; #15
        reset = 0; #1000
        $finish;
    end
endmodule