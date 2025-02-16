module ALU #(parameter DATA_WIDTH = 32)(
	input [DATA_WIDTH-1:0] a, b,
	input [3:0] control,
	output reg [(DATA_WIDTH*2)-1:0] Z_reg
);

	// Block A: Add/Sub/Mul/Div
	wire [DATA_WIDTH-1:0] add_result, sub_result;
	wire [(DATA_WIDTH*2)-1:0] mul_result, div_result;

	// Block B: Shift/Rotate/AND/OR/Neg/NOT
	wire [DATA_WIDTH-1:0] and_result, or_result, shr_result, shra_result, shl_result,
						  ror_result, rol_result, neg_result, not_result;

	reg [(DATA_WIDTH*2)-1:0] A_result, B_result;
	
	// Block A (Add/Sub/Mul/Div)
	// add #(DATA_WIDTH) ADD ( // addition

	// );

	// sub #(DATA_WIDTH) SUB ( // subtract

	// );

	booth_multiplier #(DATA_WIDTH) MUL (
        .a(a),
        .b(b),
        .data_out(mul_result)
    );

	// div #(DATA_WIDTH) DIV ( // divide 

	// );

	// Unit B (Shift/Rotate/AND/OR/Neg/NOT)
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

	// Block A control logic
	always @(*) begin
		case(control)
			// 4'd0:	A_result = add_result;
			// 4'd1:	A_result = sub_result;
			4'd2:	A_result = mul_result; 
			// 4'd3:	A_result = div_result; 
			default: A_result = 0;
		endcase
	// end

	// // Block B control logic
	// always @(*) begin
		case(control)
			4'd4:	B_result = and_result;
			4'd5:	B_result = or_result;
			4'd6:	B_result = shr_result;
			4'd7:	B_result = shra_result; 
			4'd8:	B_result = shl_result; 
			4'd9:	B_result = ror_result; 
			4'd10:	B_result = rol_result;
			4'd11:	B_result = neg_result;
			4'd12:	B_result = not_result; 
			default: B_result = 0;
		endcase
	end

	// MUX to select between A and B based on the range of control value
	always @(*) begin
		if (control <= 4'd3)
			Z_reg = B_result;
		else
			Z_reg = B_result;
	end
endmodule
