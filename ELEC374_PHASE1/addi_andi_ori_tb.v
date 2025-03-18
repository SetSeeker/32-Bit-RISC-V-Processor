`timescale 1ns/10ps
module addi_andi_ori_tb;
	reg PCout, Zlowout, MDRout, HIout, LOout, Z_high_out,
        In_Port_out, Cout;
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg Read, Write;
    reg RAM_read, RAM_write;
    reg LOin, HIin; 
    reg Clock, Clear;
    reg Gra, Grb, Grc, Rin, Rout, BAout, PC_tb_enable;
    reg [15:0] in_enable;
    reg [15:0] out_enable;
    reg [31:0] Mdatain, PC;
    reg [4:0] control;
    
    parameter Default = 4'b0000, Reg_load = 4'b0001, T0 = 4'b0010,
              T1 = 4'b0011, T2 = 4'b0100, T3 = 4'b0101, T4_add = 4'b0110, T4_and = 4'b0111, T4_or = 4'b1000, T5 = 4'b1001;
    reg [3:0] Present_state = Default;

    DataPath DUT (
        .Clock(Clock),
        .Clear(Clear), 
        .PCout(PCout), 
        .MDRout(MDRout), 
        .HIout(HIout), 
        .LOout(LOout),
        .Z_high_out(Z_high_out), 
        .Z_low_out(Zlowout), 
        .In_Port_out(In_Port_out), 
        .Cout(Cout),
        .Gra(Gra), 
        .Grb(Grb), 
        .Grc(Grc), 
        .Rin(Rin), 
        .Rout(Rout), 
        .BAout(BAout),
        .PC_tb_value(PC), 
        .PC_tb_enable(PC_tb_enable),
        .LOin(LOin), 
        .HIin(HIin), 
        .MARin(MARin), 
        .Zin(Zin), 
        .PCin(PCin),
        .MDRin(MDRin), 
        .IRin(IRin), 
        .Yin(Yin), 
        .Read(Read), 
        .RAM_read(RAM_read),
        .RAM_write(RAM_write), 
        .control(control), 
        .Mdatain(Mdatain)
    );

initial begin
	Clock = 0;
	forever #10 Clock = ~ Clock;
end

always @(posedge Clock) begin
	case (Present_state)
        Default : Present_state = Reg_load;
        Reg_load : Present_state = T0;
		T0 : Present_state = T1;
		T1 : Present_state = T2;
		T2 : Present_state = T3;
		T3 : Present_state = T4;
		T4 : Present_state = T5;
	endcase
end

always @(Present_state) begin
	case (Present_state)
		Default: begin // Reset all signals
			PCout <= 0; Zlowout <= 0; MDRout <= 0; HIout <= 0; LOout <= 0; Z_high_out <= 0; Cout <= 0;
			In_Port_out <= 0; LOin <= 0; HIin <= 0; MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
			Read <= 0; Write <= 0; control <= 5'd0; Clear <= 0; RAM_read <= 0; RAM_write <= 0; PC_tb_enable <= 0;
			Gra <= 0; Grb <= 0; Grc <= 0; Rin <= 0; Rout <= 0; BAout <= 0;
			in_enable <= 16'b0; out_enable <= 16'b0; Mdatain <= 32'h00000000; PC <= 32'h0;
		end
		Reg_load: begin // Load initial values
			PC <= 32'b0; PC_tb_enable <= 1; PCout <= 1;
			#5 Zin <= 1; MARin <= 1;
			#10 PCout <= 0; PC_tb_enable <= 0;
			#5 Zin <= 0; MARin <= 0;
		end
		T0: begin // Instruction Fetch
			PCout <= 1; MARin <= 1;
			#5 Zin <= 1;
			#10 PCout <= 0; MARin <= 0; Zin <= 0;
		end
		T1: begin // Memory Read
			RAM_read <= 1; Read <= 1; Zlowout <= 1;
			#5 PCin <= 1; MDRin <= 1;
			#10 Zlowout <= 0; RAM_read <= 0; Read <= 0; PCin <= 0; MDRin <= 0;
		end
		T2: begin // Decode
			MDRout <= 1;
			#5 IRin <= 1;
			#10 MDRout <= 0; IRin <= 0;
		end
		T3: begin // Operand Fetch
			Grb <= 1; Rout <= 1;
			#5 Yin <= 1;
			#10 Grb <= 0; Rout <= 0; Yin <= 0;
		end
		T4_add: begin // ADD Immediate (addi)
			Cout <= 1; control <= 5'd12; // ADD control signal
			#5 Zin <= 1;
			#15 Zin <= 0; Cout <= 0;
		end

		T5: begin // Store result in destination register
			Zlowout <= 1; Gra <= 1; Rin <= 1;
			#10 Zlowout <= 0; Rin <= 0; Gra <= 0;
		end
	endcase
end
endmodule
