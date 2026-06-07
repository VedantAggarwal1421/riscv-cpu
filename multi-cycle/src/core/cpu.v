module CPU(
    input clk,
    input reset
);
    //Control Wires
    wire pcUpdate;
    wire adrSrc;
    wire memWrite;
    wire IRWrite;
    wire regWrite;
    wire [2:0] immSrc;
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire invertOp;
    wire [2:0] ALUCtrl;
    wire [1:0] resSrc;
    wire [31:0] instr;

    dataPath DP(
        .clk(clk),
        .reset(reset),
        .pcUpdate(pcUpdate),
        .adrSrc(adrSrc),
        .memWrite(memWrite),
        .IRWrite(IRWrite),
        .regWrite(regWrite),
        .immSrc(immSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .invertOp(invertOp),
        .ALUCtrl(ALUCtrl),
        .resSrc(resSrc),
        .instOut(instr)
    );

    controlUnit CP(
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .pcUpdate(pcUpdate),
        .adrSrc(adrSrc),
        .memWrite(memWrite),
        .IRWrite(IRWrite),
        .regWrite(regWrite),
        .immSrc(immSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .invertOp(invertOp),
        .ALUCtrl(ALUCtrl),
        .resSrc(resSrc)
    );
endmodule