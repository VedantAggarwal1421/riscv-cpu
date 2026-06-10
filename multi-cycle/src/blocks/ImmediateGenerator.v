module immediateGenerator(input [31:7] instr, input [2:0] immSrc, output reg [31:0] extendedImm);

    always @(*) begin
        extendedImm = 0;
        case(immSrc)
            3'b000: extendedImm = {{20{instr[31]}}, instr[31:20]}; //I Type
            3'b001: extendedImm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; //S Type
            3'b010: extendedImm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; //B Type
            3'b011: extendedImm = {instr[31:12], 12'b0}; //U type
            3'b100: extendedImm = {{11{instr[31]}}, instr[31], instr[20], instr[19:12], instr[30:21], 1'b0}; //J Type
            default: extendedImm = 32'b0;
        endcase
        //$display("%0b", extendedImm);
    end

endmodule