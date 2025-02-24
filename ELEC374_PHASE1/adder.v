//carry-look-ahead adder (4 bit)

module cla_4(
   input [3:0] a,
   input [3:0] b,
   input cin,
   output [3:0] sum,
   output cout
);
   wire [3:0] P, G, c;

   assign P = a ^ b; // Propagate
   assign G = a & b; // Generate

   assign c[0] = cin;
   assign c[1] = G[0] | (P[0] & c[0]);
   assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c[0]);
   assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c[0]);
   assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & c[0]);

   assign sum = P ^ c;

endmodule