module nMux #(
    parameter N = 4
)(
    input [31:0] in [N-1:0],
    input [$clog2(N)-1:0] sel,
    output [31:0] out
);
    assign out = in[sel];
endmodule