module Bus #(parameter DATA_WIDTH = 32)(
	//Mux
	input [DATA_WIDTH-1:0] R0, R1, R2, R3, R4,
								  R5,	R6, R7, R8,	R9,
								  R10, R11, R12, R13, R14,
								  R15,
	input [4:0] sel, // checks which register connects to the bus at any given time
	output reg [DATA_WIDTH-1:0] bus_out
	
);

always @(*) begin
	case(sel)
		5'd0: bus_out = R0; // 00000
		5'd1: bus_out = R1; // 00001
		5'd2: bus_out = R2; // 00011
		5'd3: bus_out = R3; // 00100
		5'd4: bus_out = R4; // 00101
		5'd5: bus_out = R5; // 00110
		5'd6: bus_out = R6; // 00111
		5'd7: bus_out = R7; // 01000
		5'd8: bus_out = R8; // 01001
		5'd9: bus_out = R9; // 01010
		5'd10: bus_out = R10; // 01011
		5'd11: bus_out = R11; // 01100
		5'd12: bus_out = R12; // 01101
		5'd13: bus_out = R13; // 01110
		5'd14: bus_out = R14; // 01111
		5'd15: bus_out = R15; // 10000
		default: bus_out = 0;
	endcase
end

endmodule
