// 32 bit carry-lookahead-adder

// Use 4 bit adders to make 16 bit
module cla16 #(parameter DATA_WIDTH = 32) (
    input [15:0] d1,
    input [15:0] d2,
    input cin,
    output [15:0] sum,
    output cout
);
    wire c1, c2, c3;

    // Use 4 bit cla with 4 bit increments to make 16 bit adder
    cla_4 n1(.a(d1[3:0]), .b(d2[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c1));
    cla_4 n2(.a(d1[7:4]), .b(d2[7:4]), .cin(c1), .sum(sum[7:4]), .cout(c2));
    cla_4 n3(.a(d1[11:8]), .b(d2[11:8]), .cin(c2), .sum(sum[11:8]), .cout(c3));
    cla_4 n4(.a(d1[15:12]), .b(d2[15:12]), .cin(c3), .sum(sum[15:12]), .cout(cout));
    
endmodule

// Take two 16 bit adders and make 32 bit
module collective_add #(parameter DATA_WIDTH = 32) (
    input [31:0] d1,
    input [31:0] d2,
    input cin,
    output [31:0] sum,
    output cout
);

    wire c1;

    cla16 n1(.d1(d1[15:0]), .d2(d2[15:0]), .cin(cin), .sum(sum[15:0]), .cout(c1));
    cla16 n2(.d1(d1[31:16]), .d2(d2[31:16]), .cin(c1), .sum(sum[31:16]), .cout(cout));
    
endmodule