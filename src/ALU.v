module ALU #(parameter DATA_WIDTH = 32)(
	input [DATA_WIDTH-1:0] a, b,
	input [4:0] control,
	output reg [(DATA_WIDTH*2)-1:0] Z_reg
);

	wire [(DATA_WIDTH*2)-1:0] mul_result, div_result;

	wire [DATA_WIDTH-1:0] add_result, sub_result, and_result, or_result, shr_result, shra_result, shl_result,
						  ror_result, rol_result, neg_result, not_result, pc_result;

	reg [(DATA_WIDTH*2)-1:0]  result;

	wire cout;
	
	// Block A (Add/Sub/Mul/Div)
	collective_add #(DATA_WIDTH) ADD (
		.cin(1'd0),
		.cout(cout),
		.d1(a),
		.d2(b),
		.sum(add_result)
	);

	collective_add #(DATA_WIDTH) PC (
		.cin(1'd0),
		.cout(cout),
		.d1(b),
		.d2(1),
		.sum(pc_result)
	);

	subtract #(DATA_WIDTH) SUB (
		.cin(1'd0),
		.cout(cout),
		.a(a),
		.b(b),
		.sum(sub_result)
	);

	boothMul #(DATA_WIDTH) MUL (
        .a(a),
        .b(b),
        .data_out(mul_result)
    );

	non_restore_div #(DATA_WIDTH) DIV ( // divide 
		.a(a),
		.b(b),
		.data_out(div_result)
	);

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
		.a(a),
		.b(b),
		.data_out(shr_result)
	);

	shra #(DATA_WIDTH) SHRA ( // shift right arithmetic
		.a(a),
		.b(b),
		.data_out(shra_result)
	);

	shl #(DATA_WIDTH) SHL ( // shift left
		.a(a),
		.b(b),
		.data_out(shl_result)
	);

	ror #(DATA_WIDTH) ROR ( // rotate right
		.a(a),
		.b(b),
		.data_out(ror_result)
	);

	rol #(DATA_WIDTH) ROL ( // rotate left
		.a(a),
		.b(b),
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
			5'd3:   result = {32'd0, add_result};
			5'd4:   result = {32'd0, sub_result};
			5'd5:   result = {32'd0, and_result};
			5'd6:   result = {32'd0, or_result};
			5'd7:   result = {32'd0, ror_result};
			5'd8:   result = {32'd0, rol_result};
			5'd9:   result = {32'd0, shr_result};
			5'd10:  result = {32'd0, shra_result};
			5'd11:  result = {32'd0, shl_result};
			// 5'd12:  result = {32'd0, addi_result};
			// 5'd13:  result = {32'd0, andi_result};
			// 5'd14:  result = {32'd0, ori_result};
			5'd15:  result = div_result;
			5'd16:  result = mul_result;
			5'd17:  result = {32'd0, neg_result};
			5'd18:  result = {32'd0, not_result};
			5'd19:  result = {32'd0, pc_result};
			default: result = 64'd0;
		endcase
	end

	always @(*) begin
		Z_reg = result;
	end
endmodule
