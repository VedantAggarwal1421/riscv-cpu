module ALU(
    input [31:0] A,
    input [31:0] B,
    input invertOp,
    input [2:0] ALUCtrl,
    output reg [31:0] ALURes,
    output zero,
    output overflow,
    output negative,
    output borrow
);
    wire [31:0] BEff;
    wire [31:0] resSub;
    assign BEff = (invertOp)? (~B + 1) : B;

    always @(*) begin
      case(ALUCtrl)
        3'b000: ALURes = A+BEff; //ADD/Sub
        3'b001: ALURes = A << B[4:0]; //SLL
        3'b010: ALURes = {31'b0, $signed(A) < $signed(B)}; //SLT
        3'b011: ALURes = A < B; //SLTU
        3'b100: ALURes = A ^ B; //XOR
        3'b101: begin
          if(invertOp)
            ALURes = $signed(A) >>> B[4:0]; //SRA
          else
            ALURes = A >> B[4:0]; //SRL
        end
        3'b110: ALURes = A | B;
        3'b111: ALURes = A & B;
      endcase
    end

    assign overflow = (A[31] != B[31]) && (ALURes[31] != A[31]);
    assign zero = (ALURes == 0);
    assign negative = ALURes[31];
    assign borrow = (ALUCtrl == 3'b000 && invertOp)? A < B : 0; //Borrow only calculated conditionally because for whatever reason lui fails if borrow is calculated

endmodule