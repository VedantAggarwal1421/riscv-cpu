module memory(
    input clk,
    input memWrite,
    input [31:0] A1,
    input [31:0] WD,
    output reg [31:0] RD
);

    reg [31:0] mem [0:2047];

    //Synchronous Memory
    always @(posedge clk) begin
        RD <= mem[A1[12:2]];
        if(memWrite)
            mem[A1[12:2]] <= WD;
    end

    initial begin
        $readmemh("sim/program.hex", mem);
    end
    initial begin
        mem[32'h100 >> 2] = 32'hDEADBEEF;
        mem[32'h104 >> 2] = 32'hCAFEBABE;
        mem[32'h108 >> 2] = 32'h12345678;
        mem[32'h0FC >> 2] = 32'hAABBCCDD;
        mem[32'h200 >> 2] = 32'h11223344;
        mem[32'h204 >> 2] = 32'h55667788;
        mem[32'h208 >> 2] = 32'h99AABBCC;
    end
endmodule