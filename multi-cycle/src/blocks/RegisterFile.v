module registerFile(
    input clk,
    input regWrite,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] R1,
    output [31:0] R2
);

    reg [31:0] rFile [31:0];
    assign R1 = (A1 == 0)? 32'b0:rFile[A1];
    assign R2 = (A2 == 0)? 32'b0:rFile[A2];

    always @(posedge clk) begin
        if(regWrite && (A3 != 0))
            rFile[A3] <= WD; 
    end
endmodule