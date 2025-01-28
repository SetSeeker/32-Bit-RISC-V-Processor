module ALU #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input [DATA_WIDTH-1:0] a, b,
	input [3:0] control,
	output reg [DATA_WIDTH-1:0] result,
	output reg flag // keeps track if the result is 0
);
	
	always @(*) begin
		case(control)
			4'd0:	result = a + b; // add
			4'd1:	result = a - b; // sub
			4'd2:	result = a * b; // mul
			4'd3:	result = a / b; // div
			4'd4:	result = a & b; // AND
			4'd5:	result = a | b; // OR
			4'd6:	result = a << 1; //Shift Left
			4'd7:	result = a >> 1; // Shify Right
			default: result = 0;
		endcase
		
		flag = (result == 0) ? 1'd1 : 1'd0;
		
	end
endmodule
