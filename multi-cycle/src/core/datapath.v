module dataPath(
    input clk,
    input reset,
    input pcUpdate,
    input adrSrc,
    input memWrite,
    input [2:0] formatCtrl,
    input IRWrite,
    input regWrite,
    input [2:0] immSrc,
    input [1:0] ALUSrcA,
    input [1:0] ALUSrcB,
    input invertOp,
    input [2:0] ALUCtrl,
    input [1:0] resSrc,
    output [31:0] instOut,
    output zero,
    output overflow,
    output negative,
    output borrow
);
    wire [31:0] currPC;
    wire [31:0] adrMuxIn [1:0];
    wire [31:0] memIn;
    wire [31:0] memRead;
    wire [31:0] instr;
    wire [31:0] reg1, reg2; // Register File Outputs
    wire [31:0] ALUSrcAMuxIn [3:0];
    wire [31:0] ALUSrcBMuxIn [3:0];
    wire [31:0] ALUA, ALUB;
    wire [31:0] ALURes;
    wire [31:0] resMuxIn [3:0];
    wire [31:0] result;


    //Architectural State Elements
    programCounter PC(.clk(clk), .reset(reset), .pcUpdate(pcUpdate), .nextPC(result), .currPC(currPC));
    registerFile regFile(.clk(clk), .reset(reset), .regWrite(regWrite), .A1(instr[19:15]), .A2(instr[24:20]), .A3(instr[11:7]), .WD(result), .R1(reg1), .R2(reg2));
    memory mem(.clk(clk), .memWrite(memWrite), .formatCtrl(formatCtrl), .A1(memIn), .WD(ALUSrcBMuxIn[0]), .RD(memRead));
    
    //Non Architectural State Elements
    enReg32 oldPC(.clk(clk), .reset(reset), .enable(IRWrite), .in(currPC), .out(ALUSrcAMuxIn[2]));
    enReg32 IRReg(.clk(clk), .reset(reset), .enable(IRWrite), .in(memRead), .out(instr));
    reg32 A(.clk(clk), .reset(reset), .in(reg1), .out(ALUSrcAMuxIn[1]));
    reg32 B(.clk(clk), .reset(reset), .in(reg2), .out(ALUSrcBMuxIn[0]));
    reg32 aluOut(.clk(clk), .reset(reset), .in(ALURes), .out(resMuxIn[0]));

    //Combinational Elements
    assign adrMuxIn[0] = currPC;
    assign adrMuxIn[1] = result;
    nMux #(.N(2)) adrMux(.in(adrMuxIn), .sel(adrSrc), .out(memIn));

    assign ALUSrcAMuxIn[0] = currPC;
    assign ALUSrcAMuxIn[3] = 32'd0;
    assign ALUSrcBMuxIn[1] = 32'd4;
    assign ALUSrcBMuxIn[3] = 32'd0;
    nMux #(.N(4)) ALUSrcAMux(.in(ALUSrcAMuxIn), .sel(ALUSrcA), .out(ALUA));
    nMux #(.N(4)) ALUSrcBMux(.in(ALUSrcBMuxIn), .sel(ALUSrcB), .out(ALUB));
    
    assign resMuxIn[1] = ALURes;
    assign resMuxIn[2] = memRead;
    assign resMuxIn[3] = 32'd0;
    nMux #(.N(4)) resMux(.in(resMuxIn), .sel(resSrc), .out(result));

    ALU alu(.A(ALUA), .B(ALUB), .invertOp(invertOp), .ALUCtrl(ALUCtrl), .ALURes(ALURes), .zero(zero), .overflow(overflow), .negative(negative), .borrow(borrow));
    immediateGenerator immGen(.instr(instr[31:7]), .immSrc(immSrc), .extendedImm(ALUSrcBMuxIn[2]));

    assign instOut = instr;
endmodule