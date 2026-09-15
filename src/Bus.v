module Bus #(parameter DATA_WIDTH = 32)(
	//Mux
	input [DATA_WIDTH-1:0] R0, R1, R2, R3, R4,
						   R5, R6, R7, R8,	R9,
						   R10, R11, R12, R13, R14,
						   R15, MDR, HI, LO, Z_high, Z_low,
						   PC, In_Port, C_sign_extended,
								  
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out,
		  R11out, R12out, R13out, R14out, R15out, MDRout, HIout, LOout, Z_high_out, 
		  Z_low_out, PC_out, In_Port_out, C_sign_extended_out,

	
	output wire [DATA_WIDTH-1:0] bus_out
	
);

	reg [DATA_WIDTH-1:0] q;
	
	initial begin
		q = 32'b0;
	end

	always @(*) begin 
		if (R0out) q = R0;
		else if (R1out) q = R1;
		else if (R2out) q = R2;
		else if (R3out) q = R3;
		else if (R4out) q = R4;
		else if (R5out) q = R5;
		else if (R6out) q = R6;
		else if (R7out) q = R7;
		else if (R8out) q = R8;
		else if (R9out) q = R9;
		else if (R10out) q = R10;
		else if (R11out) q = R11;
		else if (R12out) q = R12;
		else if (R13out) q = R13;
		else if (R14out) q = R14;
		else if (R15out) q = R15;
		else if (MDRout) q = MDR;
		else if (HIout) q = HI;
		else if (LOout) q = LO;
		else if (Z_high_out) q = Z_high;
		else if (Z_low_out) q = Z_low;
		else if (PC_out) q = PC;
		else if (In_Port_out) q = In_Port;
		else if (C_sign_extended_out) q = C_sign_extended;
	end 

	assign bus_out = q;

endmodule