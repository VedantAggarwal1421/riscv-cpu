module CPU(
    input clk,
    input reset
);
    //Control Wires
    wire pcUpdate;
    wire memWrite;
    wire IRWrite;
    wire regWrite;
    wire ALUSrcA;
    wire ALUSrcB;
    wire [2:0] ALUCtrl;
    wire resSrc;
    wire [31:0] instr;

    dataPath DP(
        .clk(clk);
        .reset(reset);
        .pcUpdate(pcUpdate);
        .memWrite(memWrite);
        .IRWrite(IRWrite);
        .regWrite(regWrite);
        .ALUSrcA(ALUSrcA);
        .ALUSrcB(ALUSrcB);
        .ALUCtrl(ALUCtrl);
        .resSrc(resSrc);
        .instOut(instr);
    );

    controlUnit CP(
        .clk(clk);
        .reset(reset);
        .instr(instr);
        .pcUpdate(pcUpdate);
        .memWrite(memWrite);
        .IRWrite(IRWrite);
        .regWrite(regWrite);
        .ALUSrcA(ALUSrcA);
        .ALUSrcB(ALUSrcB);
        .ALUCtrl(ALUCtrl);
        .resSrc(resSrc);
    );
endmodule