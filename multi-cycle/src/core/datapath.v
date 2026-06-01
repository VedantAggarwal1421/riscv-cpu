module dataPath(
    input clk,
    input reset,
    input pcUpdate,
    input memWrite,
    input IRWrite,
    input regWrite,
    input ALUSrcA,
    input ALUSrcB,
    input ALUCtrl,
    input resSrc,
    output [31:0] instOut
);
    wire [31:0] currPC;
    wire [31:0] memRead;
    wire [31:0] instr;
    wire [31:0] reg1, reg2; // Register File Outputs
    wire [31:0] r1, r2; // A,B Outputs


    //Architectural State Elements
    programCounter PC(.clk(clk), .reset(reset), .pcUpdate(pcUpdate), .nextPC(), .currPC(currPC));
    registerFile regFile(.clk(clk), .regWrite(regWrite), .A1(instr[19:15]), .A2(instr[24:20]), .A3(instr[11:7]), .WD(), .R1(reg1), .R2(reg2));
    memory mem(.clk(clk), .memWrite(memWrite), .A1(currPC), .WD(), .RD(memRead));
    
    //Non Architectural State Elements
    enReg32 IRReg(.clk(clk), .reset(reset), .enable(IRWrite), .in(memRead), .out(instr));
    reg32 A(.clk(clk), .reset(reset), .in(reg1), .out(r1));
    reg32 B(.clk(clk), .reset(reset), .in(reg2), .out(r2));

    //Combinational Elements
endmodule