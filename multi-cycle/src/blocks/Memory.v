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

endmodule