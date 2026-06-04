module controlUnit(
    input clk,
    input reset,
    input [31:0] instr,
    output logic pcUpdate,
    output logic memWrite,
    output logic IRWrite,
    output logic regWrite,
    output logic ALUSrcA,
    output logic ALUSrcB,
    output logic invertOp,
    output logic [2:0] ALUCtrl,
    output logic resSrc
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

    logic [2:0] currentState, nextState;

    //MAIN FSM
    //NEXT STATE LOGIC
    always_comb begin
        nextState = currentState; //Default Case
        case(currentState)
            memFetch: nextState = fetch;
            fetch: nextState = decode;
            decode: nextState = execute_R;
            execute_R: nextState = writeBack_ALU;
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
        memWrite = 0;
        IRWrite = 0;
        regWrite = 0;
        ALUSrcA = 0;
        ALUSrcB = 0;
        invertOp = 0;
        resSrc = 0;
        case(currentState)
            memFetch: begin
                ALUSrcA = 0;
                ALUSrcB = 1;
                resSrc = 1;
            end
            fetch: begin
                pcUpdate = 1;
                IRWrite = 1;
                ALUSrcA = 0;
                ALUSrcB = 1;
                resSrc = 1;
            end
            execute_R: begin
                ALUSrcA = 1;
                ALUSrcB = 0;
                invertOp = invertOp_t;
            end
            writeBack_ALU: begin
                resSrc = 0;
                regWrite = 1;
            end
        endcase
    end

    //ALU DECODER
    always_comb begin
        ALUCtrl = 3'd0;
        case(currentState)
            memFetch: ALUCtrl = 3'b000;
            fetch: ALUCtrl = 3'b000;
            execute_R: ALUCtrl = funct3;
        endcase
    end
endmodule