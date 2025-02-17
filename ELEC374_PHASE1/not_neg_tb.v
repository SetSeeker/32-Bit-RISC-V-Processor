`timescale 1ns/10ps
module datapath_tb;
	reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, 
        R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, 
        PCout, Zlowout, MDRout, HIout, LOout, Z_high_out,
        In_Port_out, C_sign_extended_out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read;
    reg LOin, HIin; 
    reg Clock, Clear;
    reg [15:0] enable_reg;
    reg [31:0] Mdatain;
    reg [3:0] control;
    parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
              Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
              T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
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

        .LOin(LOin),
        .HIin(HIin),
        .MARin(MARin),
        .Zin(Zin),
        .PCin(PCin),
        .MDRin(MDRin),
        .IRin(IRin),
        .Yin(Yin),
        .IncPC(IncPC), 
        .Read(Read),
        .control(control),
        .enable(enable_reg),
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
		Default : Present_state = Reg_load1a;
		Reg_load1a : Present_state = Reg_load1b;
		Reg_load1b : Present_state = Reg_load2a;
		Reg_load2a : Present_state = Reg_load2b;
		Reg_load2b : Present_state = Reg_load3a;
		Reg_load3a : Present_state = Reg_load3b;
		Reg_load3b : Present_state = T0;
		T0 : Present_state = T1;
		T1 : Present_state = T2;
		T2 : Present_state = T3;
		T3 : Present_state = T4;
		T4 : Present_state = T5;
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
			In_Port_out <= 0; LOin <= 0; HIin <= 0;

			 MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; 
			 IRin <= 0; Yin <= 0;
			 IncPC <= 0; Read <= 0; control <= 4'd0;
			 Clear <= 0;
			 enable_reg <= 16'b0; Mdatain <= 32'h00000000;
		end
		Reg_load1a: begin
			 Mdatain <= 32'b00000000000000000000000000001010;
			 #5 Read <= 1; MDRin <= 1; // Took out #10 for '1', as it may not be needed
			 #15 Read <= 0; MDRin <= 0; // for your current implementation
		end
		Reg_load1b: begin
			 #5 MDRout <= 1; enable_reg <= (1 << 3);
			 #15 MDRout <= 0; enable_reg <= 16'b0; // initialize R3 with the value 0x22
		end
		Reg_load2a: begin
			 Mdatain <= 3;
			 #5 Read <= 1; MDRin <= 1; 
			 #15 Read <= 0; MDRin <= 0;
		end
		Reg_load2b: begin
			 #5 MDRout <= 1; enable_reg <= (1 << 7);
			 #15 MDRout <= 0; enable_reg <= 16'd0; // initialize R7 with the value 0x24
		end
		Reg_load3a: begin
			 Mdatain <= 32'h0000001;
			 #5 Read <= 1; MDRin <= 1;
			 #15 Read <= 0; MDRin <= 0;
		end
		Reg_load3b: begin
			 MDRout <= 1; enable_reg <= (1 << 4);
			 #15 MDRout <= 0; enable_reg <= 16'b0; // initialize R4 with the value 0x28
		end
		T0: begin // see if you need to de-assert these signals
			  PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
			 #15 PCout <= 0;
		end
		T1: begin
			 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
			 Mdatain <= 32'h2A2B8000; // opcode for “and R4, R3, R7”
			 #15 Zlowout <= 0; PCout <= 0; MDRin <= 0;
		end
		T2: begin
			 MDRout <= 1; IRin <= 1;
			 #15  MDRout <= 0; Read <= 0;
		end
		T3: begin
			R3out <= 1; Yin <= 1;
			#15 R3out <= 0; Yin <= 0;
		end
		T4: begin
			R7out <= 1; control <= 4'd4; Zin <= 1;
			#15 R7out <= 0; Zin <= 0;
		end
		T5: begin
		    enable_reg <= (1 << 4);
			#15 Zlowout <= 1; LOin <= 1;
			#25 Zlowout <= 0; LOin <= 0;
		end
	endcase
  end
// MAC code for simulations
	initial begin
        $dumpfile("datapath_tb.vcd"); // GTKWave
        $dumpvars();
    end
initial begin
    #300;  // Run for 1000 time units
    $display("Simulation complete.");
    $finish;
end
endmodule 