module ALU #(parameter DATA_WIDTH = 32)(
	input [DATA_WIDTH-1:0] a, b,
	input [3:0] control,
	output reg [(DATA_WIDTH*2)-1:0] Z_reg
);

	wire [(DATA_WIDTH*2)-1:0] mul_result, div_result;

	wire [DATA_WIDTH-1:0] add_result, sub_result, and_result, or_result, shr_result, shra_result, shl_result,
						  ror_result, rol_result, neg_result, not_result, pc_result;

	reg [DATA_WIDTH-1:0]  result;

	wire cout;

	
	// Block A (Add/Sub/Mul/Div)
	collective_add #(DATA_WIDTH) ADD (
		.cin(0),
		.cout(cout),
		.d1(a),
		.d2(b),
		.sum(add_result)
	);

	collective_add #(DATA_WIDTH) PC (
		.cin(0),
		.cout(cout),
		.d1(b),
		.d2(1),
		.sum(pc_result)
	);

	// sub #(DATA_WIDTH) SUB ( // subtract

	// );

	boothMul #(DATA_WIDTH) MUL (
        .a(a),
        .b(b),
        .data_out(mul_result)
    );

	// non_restore_div #(DATA_WIDTH) DIV ( // divide 

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
		.data_in(b),
		.data_out(shr_result)
	);

	shra #(DATA_WIDTH) SHRA ( // shift right arithmetic
		.data_in(b),
		.data_out(shra_result)
	);

	shl #(DATA_WIDTH) SHL ( // shift left
		.data_in(b),
		.data_out(shl_result)
	);

	ror #(DATA_WIDTH) ROR ( // rotate right
		.data_in(b),
		.data_out(ror_result)
	);

	rol #(DATA_WIDTH) ROL ( // rotate left
		.data_in(b),
		.data_out(rol_result)
	);

	neg #(DATA_WIDTH) NEG ( // negate
		.data_in(b),
		.data_out(neg_result)
	);

	not_op #(DATA_WIDTH) NOT ( // not
		.data_in(b),
		.data_out(not_result)
	);

	// Block A control logic
	always @(*) begin
		case(control)
			4'd1:	result = {32'd0, add_result};
			4'd2:	result = {32'd0, sub_result};
			4'd3:	result = mul_result;
			4'd4:	result = div_result;
			4'd5:   result = {32'd0, and_result};
			4'd6:   result = {32'd0, or_result};
			4'd7:   result = {32'd0, shr_result};
			4'd8:   result = {32'd0, shra_result}; 
			4'd9:   result = {32'd0, shl_result}; 
			4'd10:  result = {32'd0, ror_result}; 
			4'd11:  result = {32'd0, rol_result};
			4'd12:  result = {32'd0, neg_result};
			4'd13:  result = {32'd0, not_result};
			4'd14:  result = {32'd0, pc_result};
			default: result = 64'd0;
		endcase
	end
	

	// MUX to select between A and B based on the range of control value
	always @(*) begin
		Z_reg = result;
	end
endmodule
