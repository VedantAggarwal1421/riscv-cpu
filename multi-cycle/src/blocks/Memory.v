module memory(
    input clk,
    input memWrite,
    input [2:0] formatCtrl,
    input [31:0] A1,
    input [31:0] WD,
    output reg [31:0] RD
);

    
    reg [31:0] mem [0:2047];
    reg [31:0] rawRead;
    reg [1:0] bytePos;
    wire [3:0] byteMask;
    wire [31:0] fWrite;

    //Synchronous Memory
    always @(posedge clk) begin
        rawRead <= mem[A1[12:2]];
        bytePos <= A1[1:0];
        if(memWrite) begin
            if(byteMask[0])
                mem[A1[12:2]][7:0] <= fWrite[7:0];
            if(byteMask[1])
                mem[A1[12:2]][15:8] <= fWrite[15:8];
            if(byteMask[2])
                mem[A1[12:2]][23:16] <= fWrite[23:16];
            if(byteMask[3])
                mem[A1[12:2]][31:24] <= fWrite[31:24];
            
            //$display("MEM WRITE: addr=%h data=%h" , A1, fWrite);
        end
    end

    loadFormatter lf(.dataIn(rawRead), .formatCtrl(formatCtrl), .bytePos(bytePos), .dataOut(RD));
    storeFormatter sf(.dataIn(WD), .formatCtrl(formatCtrl), .bytePos(bytePos), .byteMask(byteMask), .dataOut(fWrite));

    initial begin
        $readmemh("sim/program.hex", mem);
    end

endmodule

module loadFormatter(
    input [31:0] dataIn,
    input [2:0] formatCtrl,
    input [1:0] bytePos,
    output reg [31:0] dataOut
);
    wire [7:0] byte_data;
    wire [15:0] half_data;
    assign byte_data = dataIn[bytePos*8 +: 8];
    assign half_data = dataIn[bytePos[1]*16 +: 16];
    wire byte_data_sign, half_data_sign;
    assign byte_data_sign = byte_data[7];
    assign half_data_sign = half_data[15];

    always_comb begin
        case(formatCtrl)
            3'b000: dataOut = {{24{byte_data_sign}}, byte_data}; //LB
            3'b001: dataOut = {{16{half_data_sign}}, half_data}; //LH
            3'b010: dataOut = dataIn; //LW
            3'b100: dataOut = {24'b0, byte_data}; //LBU
            3'b101: dataOut = {16'b0, half_data}; //LHU
            default: dataOut = dataIn;
        endcase
        //$display(bytePos, byte_start);
    end
endmodule

module storeFormatter(
    input [31:0] dataIn,
    input [2:0] formatCtrl,
    input [1:0] bytePos,
    output reg [3:0] byteMask,
    output reg [31:0] dataOut
);
    always @(*) begin
        case(formatCtrl)
            3'b000: begin //SB
                dataOut = dataIn << 8*bytePos;
                byteMask = 4'b0001 << bytePos;
            end
            3'b001: begin //SH
                dataOut = dataIn << 16*bytePos[1];
                byteMask = 4'b0011 << 2*bytePos[1];
            end
            3'b010: begin //SW
                dataOut = dataIn;
                byteMask = 4'b1111;
            end
        endcase
    end
endmodule