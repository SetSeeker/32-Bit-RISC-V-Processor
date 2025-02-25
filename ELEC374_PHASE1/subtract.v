module subtract#(parameter DATA_WIDTH = 32) (
   input [31:0] a,
   input [31:0] b,
   input cin,
   output [31:0] sum,
   output cout
);
   wire [31:0] negative_b;
	
   assign negative_b = ~b + 1; // Correct 2's complement negation of b
	
   collective_add n1(.d1(a), .d2(negative_b), .cin(cin), .sum(sum), .cout(cout));

endmodule