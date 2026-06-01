module programCounter(
    input clk,
    input reset,
    input pcUpdate,
    input [31:0] nextPC,
    output reg [31:0] currPC
);
    always @(posedge clk) begin
        if(reset)
            currPC <= 32'b0;
        else if(pcUpdate)
            currPC <= nextPC;
    end
endmodule