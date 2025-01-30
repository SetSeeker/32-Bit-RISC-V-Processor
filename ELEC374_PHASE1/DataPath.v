module DataPath #(parameter DATA_WIDTH = 32)(
	input Clock, Clear,
	input R3in, R4in, R7in, Zin, PCin, MDRin, IRin, Yin, MARin,
	input IncPC, Read, AND,
	input[DATA_WIDTH-1:0] Mdatain,
	//input [4:0] sel,
	//input [3:0] control,
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out,
	R11out, R12out, R13out, R14out, R15out, PCout, Zlowout, MDRout
);

//PCout, Zlowout, MDRout, R3out, R7out, MARin, Zin, PCin, MDRin, IRin, Yin, IncPC, Read, AND, R3in, R4in, R7in, Mdatain

wire [DATA_WIDTH-1:0] R3, R4, R7, alu_result;

//Devices
register #(DATA_WIDTH) reg3 (
	.clock(clock),
	.clear(clear),
	.enable(R3in),
	.data_in(Mdatain),
	.data_out(R3)
);

register #(DATA_WIDTH) reg7 (
	.clock(clock),
	.clear(clear),
	.enable(R7in),
	.data_in(Mdatain),
	.data_out(R7)
);

// ALU
ALU #(DATA_WIDTH) AND_OP (
	.a(R3),
	.b(R7),
	.control(4'd4),
	.result(alu_result)
);

register #(DATA_WIDTH) reg4 (
	.clock(clock),
	.clear(clear),
	.enable(R4in),
	.data_in(alu_result),
	.data_out(R4)
);

//Bus
Bus #(DATA_WIDTH) bus(
	.R0(R0),
	.R1(R1),
	.R2(R2),
	.R3(R3),
	.R4(R4),
	.R5(R5),
	.R6(R6),
	.R7(R7),
	.R8(R8),
	.R9(R9),
	.R10(R10),
	.R11(R11),
	.R12(R12),
	.R13(R13),
	.R15(R15),
	.bus_out(Mdatain)
);

endmodule
