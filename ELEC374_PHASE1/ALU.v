module ALU #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input [DATA_WIDTH-1:0] a, b,
	input [3:0] control,
	output reg [DATA_WIDTH-1:0] result
);
	always @(*) begin
		case(control)
			4'd0:	result = a + b; // add (Cook)
			4'd1:	result = a - b; // sub (Cook)
			4'd2:	result = a * b; // mul (Hum)
			4'd3:	result = a / b; // div (Hum)
			4'd4:	result = a & b; // AND
			4'd5:	result = a | b; // OR
			4'd6:	result = a << 1; //Shift Left (Skr)
			4'd7:	result = a >> 1; // Shify Right (Skr)
			default: result = 0;
		endcase
	end
endmodule
