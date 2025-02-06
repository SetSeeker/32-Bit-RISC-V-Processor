module DataPath #(parameter DATA_WIDTH = 32)(
	input Clock, Clear,
	input R3in, R4in, R7in, Zin, PCin, MDRin, IRin, Yin, MARin,
	input IncPC, Read,
	input [DATA_WIDTH-1:0] Mdatain,
	input [3:0] control,
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, 
          R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, 
          PCout, Zlowout, MDRout, HIout, LOout, Z_high_out, Z_low_out,
          In_Port_out, C_sign_extended_out
);

	wire [DATA_WIDTH-1:0] R0, R1, R2, R3, R4, 
                          R5, R6, R7, R8, R9, 
                          R10, R11, R12, R13, R14, R15,
                          HI, LO, Z_high, Z_low,
                          PC, In_Port, C_sign_extended,
                          BusMuxOut, BusMuxIn_MDR;
	wire [(DATA_WIDTH*2)-1:0] ALU_result;

	//Devices
	register #(DATA_WIDTH) reg2 (
		.clock(Clock),
		.clear(Clear),
		.enable(R3in),
		.data_in(Mdatain),
		.data_out(R2)
	);

	register #(DATA_WIDTH) reg3 (
		.clock(Clock),
		.clear(Clear),
		.enable(R3in),
		.data_in(Mdatain),
		.data_out(R3)
	);

	register #(DATA_WIDTH) reg6 (
		.clock(Clock),
		.clear(Clear),
		.enable(R3in),
		.data_in(Mdatain),
		.data_out(R6)
	);

	register #(DATA_WIDTH) reg7 (
		.clock(Clock),
		.clear(Clear),
		.enable(R7in),
		.data_in(Mdatain),
		.data_out(R7)
	);

	register #(DATA_WIDTH) pc_register (
        .clock(Clock),
        .clear(Clear),
        .enable(PCin),
        .data_in(Mdatain),
        .data_out(PC)
    );

    // HI Register
    register #(DATA_WIDTH) hi_register (
        .clock(Clock),
        .clear(Clear),
        .enable(Zin), 
        .data_in(Z_high),
        .data_out(HI)
    );

    // // LO Register
    // register #(DATA_WIDTH) lo_register (
    //     .clock(Clock),
    //     .clear(Clear),
    //     .enable(Zin), 
    //     .data_in(alu_result),
    //     .data_out(LO)
    // );

    // Z High and Z Low Registers

	register #(DATA_WIDTH) z_low_register (
        .clock(Clock),
        .clear(Clear),
        .enable(Zin),
        .data_in(ALU_result[31:0]),
        .data_out(Z_low)
    );

    register #(DATA_WIDTH) z_high_register (
        .clock(Clock),
        .clear(Clear),
        .enable(Zin),
        .data_in(ALU_result[63:32]),
        .data_out(Z_high)
    );

    // In_Port (For I/O Operations)
    register #(DATA_WIDTH) in_port_register (
        .clock(Clock),
        .clear(Clear),
        .enable(Yin),
        .data_in(Mdatain),
        .data_out(In_Port)
    );

    // // Constant Sign-Extended Register
    // register #(DATA_WIDTH) c_sign_extended_register (
    //     .clock(Clock),
    //     .clear(Clear),
    //     .enable(IRin),
    //     .data_in(Mdatain),
    //     .data_out(C_sign_extended)
    // );

	// ALU
	ALU #(DATA_WIDTH) alu (
		.a(R3),
		.b(R7),
		.control(control),
		.Z_reg(ALU_result)
	);

	register #(DATA_WIDTH) reg4 (
		.clock(clock),
		.clear(clear),
		.enable(R4in),
		.data_in(Z_low),
		.data_out(R4)
	);

	// MDR
	MDR #(DATA_WIDTH) mdr (
		.Clock(Clock),
		.Clear(Clear),
		.Read(Read),
		.BusMuxOut(BusMuxOut),
		.MDRin(MDRin),
		.BusMuxIn_MDR(BusMuxIn_MDR),
		.Mdatain(Mdatain)
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
		.MDR(BusMuxIn_MDR),
		.bus_out(BusMuxOut)
	);

endmodule
