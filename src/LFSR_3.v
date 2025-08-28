module LFSR_3(
    input clk,
    input reset,
    output [2:0] randd
);
    wire a1, a2, a3, a4;
    assign a4 = a1 ^ a3;

    DFF bit1(.D(a4), .clk(clk), .reset(reset), .Q(a1));
    DFF bit2(.D(a1), .clk(clk), .reset(reset), .Q(a2));
    DFF bit3(.D(a2), .clk(clk), .reset(reset), .Q(a3));

    assign randd = {a1, a2, a3};
endmodule
