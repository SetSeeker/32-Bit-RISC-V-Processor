// 32 bit carry-lookahead-adder

//Take my previous 4 bit adders and make 32 bit

module carry_lookahead_32bit #(parameter DATA_WIDTH = 32) (
   input [31:0] d1, d2,
	input cin,
   output cout,
   output [31:0] sum
);

   wire c0, c1, c2, c3, c4, c5, c6, c7;
   reg [31:0] b;

   always @(*) begin
		if (cin == 1)
			b <= -d2;
		else
			b <= d2;
	end

   //Use 4 bit cla with 4 bit increments to make 32 bit adder
   cla_4 n1(d1[3:0], b[3:0], cin, sum[3:0], c0);
   cla_4 n2(d1[7:4], b[7:4], c0, sum[7:4], c1);
   cla_4 n3(d1[11:8], b[11:8], c1, sum[11:8], c2);
   cla_4 n4(d1[15:12], b[15:12], c2, sum[15:12], c3);
   cla_4 n5(d1[19:16], b[19:16], c3, sum[19:16], c4);
   cla_4 n6(d1[23:20], b[23:20], c4, sum[23:20], c5);
   cla_4 n7(d1[27:24], b[27:24], c5, sum[27:24], c6);
   cla_4 n8(d1[31:28], b[31:28], c6, sum[31:28], c7);

   assign cout = c7;
	//assign final_sum = sum;
	 
	//Account for carry of last add
	//always @(*) begin
//	if (c7 == 1 ) begin 
//		assign sum = sum|(c7<<32);
//	end

endmodule
