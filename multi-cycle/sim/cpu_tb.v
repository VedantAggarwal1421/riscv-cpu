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
        $dumpfile("wave.vcd");
        $dumpvars(0, cpu_tb);
        reset = 1; #20
        reset = 0; #5000
        $finish;
    end
endmodule