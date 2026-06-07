module controlUnit(
    input clk,
    input reset,
    input [31:0] instr,
    output logic pcUpdate,
    output logic adrSrc,
    output logic memWrite,
    output logic IRWrite,
    output logic regWrite,
    output logic [2:0] immSrc,
    output logic ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic invertOp,
    output logic [2:0] ALUCtrl,
    output logic [1:0] resSrc
);
    
    wire [6:0] funct7;
    wire [2:0] funct3; 
    wire [6:0] opcode;
    wire invertOp_t;

    assign funct7 = instr[31:25];
    assign funct3 = instr[14:12];
    assign opcode = instr[6:0];
    assign invertOp_t = funct7[5];

    
    localparam memFetch = 3'd0;
    localparam fetch = 3'd1;
    localparam decode = 3'd2;
    localparam execute_R = 3'd3;
    localparam writeBack_ALU = 3'd4;
    localparam execute_I = 3'd5;
    localparam memRead = 3'd6;
    localparam writeBack_mem = 3'd7;

    logic [2:0] currentState, nextState;

    //MAIN FSM
    //NEXT STATE LOGIC
    always_comb begin
        nextState = currentState; //Default Case
        case(currentState)
            memFetch: nextState = fetch;
            fetch: nextState = decode;
            decode: begin
                case(opcode)
                    7'b0110011: nextState = execute_R;
                    7'b0010011: nextState = execute_I;
                    7'b0000011: nextState = memRead;
                endcase
            end
            execute_R: nextState = writeBack_ALU;
            execute_I: nextState = writeBack_ALU;
            memRead: nextState = writeBack_mem;
            writeBack_mem: nextState = memFetch;
            writeBack_ALU: nextState = memFetch;
        endcase
    end

    //FSM REGISTER
    always_ff @(posedge clk) begin
        if(reset)
            currentState <= memFetch;
        else
            currentState <= nextState;
    end

    //OUTPUT LOGIC
    always_comb begin
        pcUpdate = 0;
        adrSrc = 0;
        memWrite = 0;
        IRWrite = 0;
        regWrite = 0;
        immSrc = 3'd0;
        ALUSrcA = 0;
        ALUSrcB = 2'd0;
        invertOp = 0;
        resSrc = 2'd0;
        case(currentState)
            memFetch: begin
                pcUpdate = 1;
                ALUSrcA = 0;        //Setting ALU to calculate PC+4 here to support correct PC update after reset
                ALUSrcB = 2'd1;
                resSrc = 2'd0;
                IRWrite = 1;
            end
            fetch: begin
                //IRWrite = 1;
            end
            decode: begin
                ALUSrcA = 1;
                ALUSrcB = 2'd2;
                immSrc = 3'd0;
                resSrc = 2'd1;
                adrSrc = 1;
            end
            memRead: begin
                resSrc = 2'd0;
                adrSrc = 1;
            end
            writeBack_mem: begin
                resSrc = 2'd2;
                regWrite = 1;
                ALUSrcA = 0;
                ALUSrcB = 2'd1;
            end
            execute_R: begin
                ALUSrcA = 1;
                ALUSrcB = 2'd0;
                invertOp = invertOp_t;
            end
            execute_I: begin
                ALUSrcA = 1;
                ALUSrcB = 2'd2;
                immSrc = 3'd0;
                if(funct3 == 3'b101)
                    invertOp = invertOp_t;
            end
            writeBack_ALU: begin
                resSrc = 2'd0;
                regWrite = 1;
                ALUSrcA = 0;
                ALUSrcB = 2'd1;
            end
        endcase
    end

    //ALU DECODER
    always_comb begin
        ALUCtrl = 3'd0;
        case(currentState)
            memFetch: ALUCtrl = 3'b000;
            decode: ALUCtrl = 3'b000;
            execute_R: ALUCtrl = funct3;
            execute_I: ALUCtrl = funct3;
            writeBack_mem: ALUCtrl = 3'b000;
            writeBack_ALU: ALUCtrl = 3'b000;
        endcase
    end
endmodule