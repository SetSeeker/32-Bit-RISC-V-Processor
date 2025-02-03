module ALU #(parameter DATA_WIDTH = 32)(
	input [DATA_WIDTH-1:0] a, b,
	input [3:0] control,
	output reg [DATA_WIDTH-1:0] result
);

	wire [DATA_WIDTH-1:0] and_result, or_result, add_result, sub_result, mul_result, div_result, shr_result, shra_result, shl_result,
						ror_result, rol_result, neg_result, not_result;

	and_op #(DATA_WIDTH) AND ( // and
		.a(a),
		.b(b),
		.data_out(and_result)
	);

	or_op #(DATA_WIDTH) OR ( // or
		.a(a),
		.b(b),
		.data_out(or_result)
	);

	// add #(DATA_WIDTH) ADD ( // addition

	// );

	// sub #(DATA_WIDTH) SUB ( // subtract

	// );

	// mul #(DATA_WIDTH) MUL ( // multiply

	// );

	// div #(DATA_WIDTH) DIV ( // divide 

	// );

	shr #(DATA_WIDTH) SHR ( // shift right
		.data_in(a),
		.shift_amount(b),
		.data_out(shr_result)
	);

	shra #(DATA_WIDTH) SHRA ( // shift right arithmetic
		.data_in(a),
		.shift_amount(b),
		.data_out(shra_result)
	);

	shl #(DATA_WIDTH) SHL ( // shift left
		.data_in(a),
		.shift_amount(b),
		.data_out(shl_result)
	);

	ror #(DATA_WIDTH) ROR ( // rotate right
		.data_in(a),
		.rotate_amount(b),
		.data_out(ror_result)
	);

	rol #(DATA_WIDTH) ROL ( // rotate left
		.data_in(a),
		.rotate_amount(b),
		.data_out(rol_result)
	);

	neg #(DATA_WIDTH) NEG ( // negate
		.data_in(a),
		.data_out(neg_result)
	);

	not_op #(DATA_WIDTH) NOT ( // not
		.data_in(a),
		.data_out(not_result)
	);

	always @(*) begin
		case(control)
			4'd0:	result = and_result;
			4'd1:	result = or_result;
			4'd2:	result = add_result;
			4'd3:	result = sub_result;
			4'd4:	result = mul_result; 
			4'd5:	result = div_result; 
			4'd6:	result = shr_result;
			4'd7:	result = shra_result; 
			4'd8:	result = shl_result; 
			4'd9:	result = ror_result; 
			4'd10:	result = rol_result;
			4'd11:	result = neg_result;
			4'd12:	result = not_result; 
			default: result = 0;
		endcase
	end
endmodule
