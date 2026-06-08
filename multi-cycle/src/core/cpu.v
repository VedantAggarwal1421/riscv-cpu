module CPU(
    input clk,
    input reset
);
    //Control Wires
    wire pcUpdate;
    wire adrSrc;
    wire memWrite;
    wire [2:0] formatCtrl;
    wire IRWrite;
    wire regWrite;
    wire [2:0] immSrc;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire invertOp;
    wire [2:0] ALUCtrl;
    wire [1:0] resSrc;
    wire [31:0] instr;
    wire zero, overflow, negative, borrow;

    dataPath DP(
        .clk(clk),
        .reset(reset),
        .pcUpdate(pcUpdate),
        .adrSrc(adrSrc),
        .memWrite(memWrite),
        .formatCtrl(formatCtrl),
        .IRWrite(IRWrite),
        .regWrite(regWrite),
        .immSrc(immSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .invertOp(invertOp),
        .ALUCtrl(ALUCtrl),
        .resSrc(resSrc),
        .instOut(instr),
        .zero(zero),
        .overflow(overflow),
        .negative(negative),
        .borrow(borrow)
    );

    controlUnit CP(
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .zero(zero),
        .overflow(overflow),
        .negative(negative),
        .borrow(borrow),
        .pcUpdate(pcUpdate),
        .adrSrc(adrSrc),
        .memWrite(memWrite),
        .formatCtrl(formatCtrl),
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