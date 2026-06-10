module controlUnit(
    input clk,
    input reset,
    input [31:0] instr,
    input zero,
    input overflow,
    input negative,
    input borrow,
    output logic pcUpdate,
    output logic adrSrc,
    output logic memWrite,
    output logic [2:0] formatCtrl,
    output logic IRWrite,
    output logic regWrite,
    output logic [2:0] immSrc,
    output logic [1:0] ALUSrcA,
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

    
    localparam memFetch = 4'd0;
    localparam fetch = 4'd1;
    localparam decode = 4'd2;
    localparam execute_R = 4'd3;
    localparam writeBack_ALU = 4'd4;
    localparam execute_I = 4'd5;
    localparam memRead = 4'd6;
    localparam writeBack_mem = 4'd7;
    localparam memStore = 4'd8;
    localparam pcSet = 4'd9;
    localparam branch = 4'd10;
    localparam jal_r = 4'd11;
    localparam execute_U = 4'd12;

    logic [3:0] currentState, nextState;

    //MAIN FSM
    //NEXT STATE LOGIC
    always_comb begin
        nextState = currentState; //Default Case
        case(currentState)
            memFetch: nextState = fetch;
            fetch: begin
                case(opcode)
                    7'b0110011: nextState = execute_R;
                    7'b0010011: nextState = execute_I;
                    7'b0110111: nextState = execute_U;
                    7'b0010111: nextState = execute_U;
                    default: nextState = decode;
                endcase
            end
            decode: begin
                case(opcode)
                    7'b0000011: nextState = memRead;
                    7'b0100011: nextState = memStore;
                    7'b1100011: nextState = branch;
                    7'b1101111: nextState = jal_r;
                    7'b1100111: nextState = jal_r;
                endcase
            end
            jal_r: nextState = writeBack_ALU;
            execute_R: nextState = writeBack_ALU;
            execute_I: nextState = writeBack_ALU;
            execute_U: nextState = writeBack_ALU;
            memRead: nextState = writeBack_mem;
            memStore: nextState = pcSet;
            branch: nextState = pcSet;
            pcSet: nextState = memFetch;
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
        formatCtrl = 3'b010;
        IRWrite = 0;
        regWrite = 0;
        immSrc = 3'd0;
        ALUSrcA = 2'd0;
        ALUSrcB = 2'd0;
        invertOp = 0;
        resSrc = 2'd0;
        case(currentState)
            memFetch: begin
                adrSrc = 0;
                pcUpdate = 1;
                ALUSrcA = 2'd0;        //Setting ALU to calculate PC+4 here to support correct PC update after reset
                ALUSrcB = 2'd1;
                resSrc = 2'd0;
                IRWrite = 1;
            end
            fetch: begin
                //IRWrite = 1;
            end
            decode: begin
                if(opcode == 7'b1100011 || opcode == 7'b1101111)
                    ALUSrcA = 2'd2;
                else
                    ALUSrcA = 2'd1;
                ALUSrcB = 2'd2;
                resSrc = 2'd1;
                adrSrc = 1;
                case(opcode)
                    7'b0000011: immSrc = 3'b000;
                    7'b0100011: immSrc = 3'b001;
                    7'b1100011: immSrc = 3'b010;
                    7'b1101111: immSrc = 3'b000;
                    7'b1100111: immSrc = 3'b000;
                endcase
            end
            memRead: begin
                resSrc = 2'd0;
                adrSrc = 1;
                formatCtrl = funct3;
            end
            memStore: begin
                resSrc = 2'd0;
                adrSrc = 1;
                memWrite = 1;
                formatCtrl = funct3;
            end
            branch: begin
                ALUSrcA = 2'd1;
                ALUSrcB = 2'd0;
                invertOp = 1;
                case(funct3)
                    3'b000: pcUpdate = zero; //BEQ
                    3'b001: pcUpdate = !zero;//BNE
                    3'b100: pcUpdate = (negative^overflow);//BLT
                    3'b101: pcUpdate = !(negative^overflow);//BGE
                    3'b110: pcUpdate = borrow;//BLTU
                    3'b111: pcUpdate = !borrow;//BGEU
                endcase
            end
            pcSet: begin
                ALUSrcA = 2'd0;
                ALUSrcB = 2'd1;
            end
            jal_r: begin
                ALUSrcA = 2'd2;
                ALUSrcB = 2'd1;
                pcUpdate = 1;
            end
            writeBack_mem: begin
                resSrc = 2'd2;
                regWrite = 1;
                ALUSrcA = 2'd0;
                ALUSrcB = 2'd1;
                formatCtrl = funct3;
            end
            execute_R: begin
                ALUSrcA = 2'd1;
                ALUSrcB = 2'd0;
                invertOp = invertOp_t;
            end
            execute_I: begin
                ALUSrcA = 2'd1;
                ALUSrcB = 2'd2;
                immSrc = 3'd0;
                if(funct3 == 3'b101)
                    invertOp = invertOp_t;
            end
            execute_U: begin
                immSrc = 3'b011;
                if(opcode == 7'b0110111)
                    ALUSrcA = 2'd3;
                else
                    ALUSrcA = 2'd2;
                ALUSrcB = 2'd2;
            end
            writeBack_ALU: begin
                resSrc = 2'd0;
                regWrite = 1;
                ALUSrcA = 2'd0;
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
            memStore: ALUCtrl = 3'b000;
            branch: ALUCtrl = 3'b000;
            pcSet: ALUCtrl = 3'b000;
            jal_r: ALUCtrl = 3'b000;
            execute_R: ALUCtrl = funct3;
            execute_I: ALUCtrl = funct3;
            execute_U: ALUCtrl = 3'b000;
            writeBack_mem: ALUCtrl = 3'b000;
            writeBack_ALU: ALUCtrl = 3'b000;
        endcase
    end
endmodule