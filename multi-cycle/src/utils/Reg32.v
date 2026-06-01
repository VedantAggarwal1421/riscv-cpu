module reg32(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    always @(posedge clk) begin
        if(reset)
            out <= 32'b0;
        else
            out <= in;
    end
endmodule

module enReg32(
    input clk,
    input reset,
    input enable,
    input [31:0] in,
    output reg [31:0] out
);
    always @(posedge clk) begin
        if(reset)
            out <= 32'b0;
        else if(enable)
            out <= in;
    end
endmodule