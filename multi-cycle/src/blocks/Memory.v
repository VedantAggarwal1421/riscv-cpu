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

    //Synchronous Memory
    always @(posedge clk) begin
        rawRead <= mem[A1[12:2]];
        bytePos <= A1[1:0];
        if(memWrite)
            mem[A1[12:2]] <= WD;
    end

    loadFormatter lf(.dataIn(rawRead), .formatCtrl(formatCtrl), .bytePos(bytePos), .dataOut(RD));

    initial begin
        $readmemh("sim/program.hex", mem);
    end

    initial begin
        mem[32'h100 >> 2] = 32'hDEADBEEF;
        mem[32'h104 >> 2] = 32'hCAFEBABE;
        mem[32'h108 >> 2] = 32'h12345678;
        mem[32'h0FC >> 2] = 32'hAABBCCDD;
        mem[32'h200 >> 2] = 32'h11223344;
        mem[32'h204 >> 2] = 32'h55667788;
        mem[32'h208 >> 2] = 32'h99AABBCC;
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