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

always @(*) begin // needs "else if" ask TA
	if(R0out) q = R0;
	if(R1out) q = R1;
	if(R2out) q = R2;
	if(R3out) q = R3;
	if(R4out) q = R4;
	if(R5out) q = R5;
	if(R6out) q = R6;
	if(R7out) q = R7;
	if(R8out) q = R8;
	if(R9out) q = R9;
	if(R10out) q = R10;
	if(R11out) q = R11;
	if(R12out) q = R12;
	if(R13out) q = R13;
	if(R14out) q = R14;
	if(R15out) q = R15;
	if(MDRout) q = MDR;
	if(HIout) q = HI;
	if(LOout) q = LO;
	if(Z_high_out) q = Z_high;
	if(Z_low_out) q = Z_low;
	if(PC_out) q = PC;
	if(In_Port_out) q = In_Port;
	if(C_sign_extended_out) q = C_sign_extended;
end 

assign bus_out = q;

endmodule