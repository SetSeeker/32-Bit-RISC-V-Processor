module DataPath #(parameter DATA_WIDTH = 32)(
	input Clock, Clear,
	input Zin, PCin, MDRin, IRin, Yin, MARin, LOin, HIin,
	input Read,
//    input [15:0] in_enable, out_enable,
	input [DATA_WIDTH-1:0] Mdatain,
	input [4:0] control,
	input PCout, MDRout, HIout, LOout, Z_high_out, Z_low_out,
          In_Port_out, Cout, RAM_read, RAM_write,
          Gra, Grb, Grc, Rin, Rout, BAout, PC_tb_enable,
    input [DATA_WIDTH-1:0] PC_tb_value
);

    wire [DATA_WIDTH-1:0] R0, R1, R2, R3, R4, 
                          R5, R6, R7, R8, R9, 
                          R10, R11, R12, R13, R14, R15,
                          HI, LO, Z_high, Z_low,

                          IR, In_Port, C_sign_extended, Y,
                          PC, BusMuxOut, BusMuxIn_MDR, Data;
    
    wire [DATA_WIDTH/4:0] MAR_address_out;

	wire [(DATA_WIDTH*2)-1:0] ALU_result;
	
	wire [15:0] in_enable, out_enable;

    Select_Encode #(DATA_WIDTH) select_encode (
    .IR(IR),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .Rin(Rin),
    .Rout(Rout),
    .BAout(BAout),
    .Rin_out(in_enable),
    .Rout_out(out_enable),
    .Cout(Cout),
    .C_sign_extended(C_sign_extended)
    );

	R0 #(DATA_WIDTH) reg0 (
    .clock(Clock),
    .clear(Clear),
    .BAout(BAout),
    .enable(in_enable[0]),
    .data_in(BusMuxOut),
    .data_out(R0)
    );

    register #(DATA_WIDTH) reg1 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[1]),
        .data_in(BusMuxOut),
        .data_out(R1)
    );

    register #(DATA_WIDTH) reg2 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[2]),
        .data_in(BusMuxOut),
        .data_out(R2)
    );

    register #(DATA_WIDTH) reg3 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[3]),
        .data_in(BusMuxOut),
        .data_out(R3)
    );

    register #(DATA_WIDTH) reg4 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[4]),
        .data_in(BusMuxOut),
        .data_out(R4)
    );

    register #(DATA_WIDTH) reg5 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[5]),
        .data_in(BusMuxOut),
        .data_out(R5)
    );

    register #(DATA_WIDTH) reg6 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[6]),
        .data_in(BusMuxOut),
        .data_out(R6)
    );

    register #(DATA_WIDTH) reg7 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[7]),
        .data_in(BusMuxOut),
        .data_out(R7)
    );

    register #(DATA_WIDTH) reg8 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[8]),
        .data_in(BusMuxOut),
        .data_out(R8)
    );

    register #(DATA_WIDTH) reg9 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[9]),
        .data_in(BusMuxOut),
        .data_out(R9)
    );

    register #(DATA_WIDTH) reg10 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[10]),
        .data_in(BusMuxOut),
        .data_out(R10)
    );

    register #(DATA_WIDTH) reg11 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[11]),
        .data_in(BusMuxOut),
        .data_out(R11)
    );

    register #(DATA_WIDTH) reg12 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[12]),
        .data_in(BusMuxOut),
        .data_out(R12)
    );

    register #(DATA_WIDTH) reg13 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[13]),
        .data_in(BusMuxOut),
        .data_out(R13)
    );

    register #(DATA_WIDTH) reg14 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[14]),
        .data_in(BusMuxOut),
        .data_out(R14)
    );

    register #(DATA_WIDTH) reg15 (
        .clock(Clock),
        .clear(Clear),
        .enable(in_enable[15]),
        .data_in(BusMuxOut),
        .data_out(R15)
    );

	PC #(DATA_WIDTH) pc_register (
        .clock(Clock),
        .clear(Clear),
        .enable(PCin),
        .PC_tb_enable(PC_tb_enable),
        .PC_tb_value(PC_tb_value),
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
		.Mdatain(Data)
	);

    MAR #(DATA_WIDTH) mar (
        .clock(Clock),
        .clear(Clear),
        .enable(MARin),
        .data_in(BusMuxOut),
        .data_out(MAR_address_out)
    );

    RAM #(DATA_WIDTH) ram (
        .read(RAM_read),
        .write(RAM_write),
        .data_in(BusMuxIn_MDR),
        .data_out(Data),
        .address(MAR_address_out)
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

        .R0out(out_enable[0]),
        .R1out(out_enable[1]),
        .R2out(out_enable[2]),
        .R3out(out_enable[3]),
        .R4out(out_enable[4]),
        .R5out(out_enable[5]),
        .R6out(out_enable[6]),
        .R7out(out_enable[7]),
        .R8out(out_enable[8]),
        .R9out(out_enable[9]),
        .R10out(out_enable[10]),
        .R11out(out_enable[11]),
        .R12out(out_enable[12]),
        .R13out(out_enable[13]),
        .R14out(out_enable[14]),
        .R15out(out_enable[15]),
        .MDRout(MDRout),
        .HIout(HIout),
        .LOout(LOout),
        .Z_high_out(Z_high_out),
        .Z_low_out(Z_low_out),
        .PC_out(PCout),
        .In_Port_out(In_Port_out),
        .C_sign_extended_out(Cout),

		.bus_out(BusMuxOut)
	);

endmodule