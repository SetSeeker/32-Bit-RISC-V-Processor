module Bus (
	//Mux
	input [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2,
				BusMuxInR3, BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7,
				BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11, BusMuxInR12,
				BusMuxInR13, BusMuxInR14, BusMuxInR15, BusMuxInRZ, BusMuxInRY, 
				BusMuxInRHI, BusMuxInRLO, BusMuxInRPC, BusMuxInRIR, BusMuxInRMAR,
				BusMuxInRZHI, BusMuxInRZLO,
	//Encoder
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out,
				  R9out, R10out, R11out, R12out, R13out, R14out, R15out, RZHIout,
				  RZLOout, RYout, RHIout, RLOout, RPCout, RIRout, RMARout,

	output wire [31:0]BusMuxOut
);

reg [31:0]q;

always @ (*) begin
	//if(RZout) q = BusMuxInRZ;
	//if(RAout) q = BusMuxInRA;
	//if(RBout) q = BusMuxInRB;
end
assign BusMuxOut = q;
endmodule
