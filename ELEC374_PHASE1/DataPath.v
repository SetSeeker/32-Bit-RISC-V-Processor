module DataPath #(parameter DATA_WIDTH = 32)(
	input Clock, Clear,
	input Zin, PCin, MDRin, IRin, Yin, MARin, LOin, HIin,
	input Read,
    input [15:0] enable,
	input [DATA_WIDTH-1:0] Mdatain,
	input [4:0] control,
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, 
          R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, 
          PCout, MDRout, HIout, LOout, Z_high_out, Z_low_out,
          In_Port_out, C_sign_extended_out
);

    wire [DATA_WIDTH-1:0] R0, R1, R2, R3, R4, 
                          R5, R6, R7, R8, R9, 
                          R10, R11, R12, R13, R14, R15,
                          HI, LO, Z_high, Z_low,

                          PC, IR, In_Port, C_sign_extended, Y,
                          BusMuxOut, BusMuxIn_MDR, MAR;
								  
	wire [(DATA_WIDTH*2)-1:0] ALU_result;


	register #(DATA_WIDTH) reg0 (
    .clock(Clock),
    .clear(Clear),
    .enable(enable[0]),
    .data_in(BusMuxOut),
    .data_out(R0)
    );

    register #(DATA_WIDTH) reg1 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[1]),
        .data_in(BusMuxOut),
        .data_out(R1)
    );

    register #(DATA_WIDTH) reg2 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[2]),
        .data_in(BusMuxOut),
        .data_out(R2)
    );

    register #(DATA_WIDTH) reg3 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[3]),
        .data_in(BusMuxOut),
        .data_out(R3)
    );

    register #(DATA_WIDTH) reg4 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[4]),
        .data_in(BusMuxOut),
        .data_out(R4)
    );

    register #(DATA_WIDTH) reg5 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[5]),
        .data_in(BusMuxOut),
        .data_out(R5)
    );

    register #(DATA_WIDTH) reg6 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[6]),
        .data_in(BusMuxOut),
        .data_out(R6)
    );

    register #(DATA_WIDTH) reg7 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[7]),
        .data_in(BusMuxOut),
        .data_out(R7)
    );

    register #(DATA_WIDTH) reg8 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[8]),
        .data_in(BusMuxOut),
        .data_out(R8)
    );

    register #(DATA_WIDTH) reg9 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[9]),
        .data_in(BusMuxOut),
        .data_out(R9)
    );

    register #(DATA_WIDTH) reg10 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[10]),
        .data_in(BusMuxOut),
        .data_out(R10)
    );

    register #(DATA_WIDTH) reg11 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[11]),
        .data_in(BusMuxOut),
        .data_out(R11)
    );

    register #(DATA_WIDTH) reg12 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[12]),
        .data_in(BusMuxOut),
        .data_out(R12)
    );

    register #(DATA_WIDTH) reg13 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[13]),
        .data_in(BusMuxOut),
        .data_out(R13)
    );

    register #(DATA_WIDTH) reg14 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[14]),
        .data_in(BusMuxOut),
        .data_out(R14)
    );

    register #(DATA_WIDTH) reg15 (
        .clock(Clock),
        .clear(Clear),
        .enable(enable[15]),
        .data_in(BusMuxOut),
        .data_out(R15)
    );

	register #(DATA_WIDTH) pc_register (
        .clock(Clock),
        .clear(Clear),
        .enable(PCin),
        .data_in(BusMuxOut),
        .data_out(PC)
    );

    register #(DATA_WIDTH) ir_register (
        .clock(Clock),
        .clear(Clear),
        .enable(IRin),
        .data_in(BusMuxOut),
        .data_out(IR)
    );

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

    // HI Register
    register #(DATA_WIDTH) hi_register (
        .clock(Clock),
        .clear(Clear),
        .enable(HIin), 
        .data_in(BusMuxOut),
        .data_out(HI)
    );

    // // LO Register
    register #(DATA_WIDTH) lo_register (
        .clock(Clock),
        .clear(Clear),
        .enable(LOin), 
        .data_in(BusMuxOut),
        .data_out(LO)
    );

    // In_Port (For I/O Operations)
    register #(DATA_WIDTH) in_port_register (
        .clock(Clock),
        .clear(Clear),
        .enable(Yin),
        .data_in(Mdatain),
        .data_out(In_Port)
    );

    // Constant Sign-Extended Register
    register #(DATA_WIDTH) c_sign_extended_register (
        .clock(Clock),
        .clear(Clear),
        .enable(C_sign_extended_out),
        .data_in(BusMuxOut),
        .data_out(C_sign_extended)
    );

    // // Constant Sign-Extended Register
    // register #(DATA_WIDTH) c_sign_extended_register (
    //     .clock(Clock),
    //     .clear(Clear),
    //     .enable(IRin),
    //     .data_in(Mdatain),
    //     .data_out(C_sign_extended)
    // );

    register #(DATA_WIDTH) y_register (
        .clock(Clock),
        .clear(Clear),
        .enable(Yin),
        .data_in(BusMuxOut),
        .data_out(Y)
    );

	// ALU
	ALU #(DATA_WIDTH) alu (
		.a(Y),
		.b(BusMuxOut),
		.control(control),
		.Z_reg(ALU_result)
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

    register #(DATA_WIDTH) mar (
        .clock(Clock),
        .clear(Clear),
        .enable(MARin),
        .data_in(BusMuxOut),
        .data_out(MAR)
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
        .R14(R14),
		.R15(R15),
		.HI(HI),
		.LO(LO),
		.Z_high(Z_high),
		.Z_low(Z_low),
		.PC(PC),
		.In_Port(In_Port),
		.C_sign_extended(C_sign_extended),
		.MDR(BusMuxIn_MDR),

        .R0out(R0out),
        .R1out(R1out),
        .R2out(R2out),
        .R3out(R3out),
        .R4out(R4out),
        .R5out(R5out),
        .R6out(R6out),
        .R7out(R7out),
        .R8out(R8out),
        .R9out(R9out),
        .R10out(R10out),
        .R11out(R11out),
        .R12out(R12out),
        .R13out(R13out),
        .R14out(R14out),
        .R15out(R15out),
        .MDRout(MDRout),
        .HIout(HIout),
        .LOout(LOout),
        .Z_high_out(Z_high_out),
        .Z_low_out(Z_low_out),
        .PC_out(PCout),
        .In_Port_out(In_Port_out),
        .C_sign_extended_out(C_sign_extended_out),

		.bus_out(BusMuxOut)
	);

endmodule