//carry-look-ahead adder (4 bit)

module cla_4 #(parameter DATA_WIDTH = 32)(
	input [3:0] x,
	input [3:0] y,
	input cin,
	output [3:0] sum,
	output cout
);

	wire [3:0] G, P, C;
	
	assign P = x ^ y;
	assign G = x & y;

	assign C[0] = cin;
	assign C[1] = G[0] | (P[0] & C[0]);
	assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
	assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
	assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

	assign sum = P ^ C;
	
endmodule