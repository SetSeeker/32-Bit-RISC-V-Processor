`timescale 1ns/10ps
module de_tb;
	reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, 
        R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, 
        PCout, Zlowout, MDRout, HIout, LOout, Z_high_out,
        In_Port_out, C_sign_extended_out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg Read, Write;
    reg RAM_read, RAM_write;
    reg LOin, HIin; 
    reg Clock, Clear;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    reg [15:0] in_enable;
    reg [15:0] out_enable;
    reg [31:0] Mdatain, PC;
    reg [4:0] control;
    parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
              Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
              T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101,
              T7 = 4'b1110;
    reg [3:0] Present_state = Default;

    DataPath DUT (
        .Clock(Clock),
        .Clear(Clear), 

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
		.PCout(PCout),
		.MDRout(MDRout),
		.HIout(HIout),
		.LOout(LOout),
		.Z_high_out(Z_high_out),
		.Z_low_out(Zlowout),
		.In_Port_out(In_Port_out),
		.C_sign_extended_out(C_sign_extended_out),

        .Gra(Gra),
        .Grb(Grb),
        .Grc(Grc),
        .Rin(Rin),
        .Rout(Rout),
        .BAout(BAout),
        .PC_tb_value(PC),

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
        .in_enable(in_enable),
        .out_enable(out_enable),
        .Mdatain(Mdatain)
    );
// add test logic here
initial
 begin
	Clock = 0;
	forever #10 Clock = ~ Clock;
end
always @(posedge Clock) // finite state machine; if clock rising-edge
 begin
	case (Present_state)
		Default : Present_state = T0;
		T0 : Present_state = T1;
		T1 : Present_state = T2;
		T2 : Present_state = T3;
		T3 : Present_state = T4;
		T4 : Present_state = T5;
        T5 : Present_state = T6;
        T6 : Present_state = T7;
	endcase
 end

always @(Present_state) // do the required job in each state
begin
	case (Present_state) // assert the required signals in each clock cycle
		Default: begin
			R0out <= 0; R1out <= 0; R2out <= 0; R3out <= 0; 
			R4out <= 0; R5out <= 0; R6out <= 0; R7out <= 0; 
			R8out <= 0; R9out <= 0; R10out <= 0; R11out <= 0; 
			R12out <= 0; R13out <= 0; R14out <= 0; R15out <= 0; 
			PCout <= 0; Zlowout <= 0; MDRout <= 0; HIout <= 0; 
			LOout <= 0; Z_high_out <= 0; C_sign_extended_out <= 0;
			In_Port_out <= 0; LOin <= 0; HIin <= 0; MARin <= 0;

			 MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; 
			 IRin <= 0; Yin <= 0;
			 Read <= 0; Write <= 0; control <= 5'd0;
			 Clear <= 0; RAM_read <= 0; RAM_write <= 0;

             Gra <= 0; Grb <= 0; Grc <= 0; Rin <= 0; Rout <= 0; BAout <= 0;
			 in_enable <= 16'b0; out_enable <= 16'b0; Mdatain <= 32'h00000000;
             PC <= 32'h0;
		end
		T0: begin
			 PC <= 32'h54; PCout <= 1; control <= 5'd19;
			 #5 Zin <= 1; MARin <= 1;
			 #10 PCout <= 0;//Zin <= 1;
			 #5 Zin <= 0; control <= 5'd0; MARin <= 0;
		end
		T1: begin
			 RAM_read <= 1; Zlowout <= 1;
			 #5 Read <= 1; PCin <= 1; MDRin <= 1;
			 #5 //MDRin <= 1;
			 #5 Zlowout <= 0; RAM_read <= 0;
			 #5 PCout <= 0; Read <= 0; PCin <= 0; MDRin <= 0;
		end
        T2: begin
			 MDRout <= 1;
			 #5 MARin <= 1; IRin <= 1; 
			 #10 MDRout <= 0;
			 #5  MARin <= 0; IRin <= 0;
        end
        T3: begin
            #5 Grb <= 1; Rout <= 1; Yin <= 1;
			#15 Grb <= 0; Rout <= 0; Yin <= 0;
        end
        T4: begin
            
        end
        T5: begin
            
        end
        T6: begin
            
        end
        T7: begin
            
        end
        endcase
    end

    // Waveform dump for simulation viewing (e.g., GTKWave)
    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars;
    end

    // End simulation after sufficient time.
    initial begin
        #500;  
        $display("Simulation complete.");
        $finish;
    end
endmodule