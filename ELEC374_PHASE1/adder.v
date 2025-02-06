//full carry-look-ahead adder

module carry_lookahead_adder #(parameter DATA_WIDTH = 32)(
	input [3:0] x, y;
	input cin;
	output [3:0] sum;
	output cout; 
)

	wire [3:0] G, P, C;
	
	assign P=xor(x, y)
	assign G=and(x, y)
	
	assign sum = xor(P, C)
	
	
//	assign C[0] = cin;
	assign C[1] = or(G[0], and(P[0],C[0])
	assign C[2] = or(G[1], or(and(P[1],G[0]), and(P[1],P[0],C[0])
	assign C[3] = or( or(G[2], and(P[2],G[1])), or( and(P[2],P[1],G[0]), and(P[2],P[1],P[0],G[0]))
	assign C[4] = or(G[3], or( or(and(P[3],G[2]), and(P[3],P[2],G[1])), or( and(P[3],P[2],P[1],G[0]), and(P[3],P[2],P[1],P[0],G[0]) ) ) )
	
	assign sum = and(P, C)

	
	