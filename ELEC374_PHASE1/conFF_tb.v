`timescale 1ns/10ps
// Conditional branch instructions
module conFF_tb;
	reg PCout, Zlowout, MDRout, HIout, LOout, Z_high_out,
        In_Port_out, Cout;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, CONin, CON;
    // reg CON; should be in Datapath
    reg Read, Write;
    reg RAM_read, RAM_write;
    reg LOin, HIin; 
    reg Clock, Clear;
    reg Gra, Grb, Grc, Rin, Rout, BAout, PC_tb_enable;
    reg [15:0] in_enable;
    reg [15:0] out_enable;
    reg [31:0] Mdatain, PC;
    reg [4:0] control;
    parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load1c = 4'b0011,
              Reg_load1d = 4'b0100, Reg_load1e = 4'b0101, Reg_load1f = 4'b0110, T0 = 4'b0111,
              T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101,
				  T7 = 4'b1110;
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
        .Mdatain(Mdatain),
		  .CON(CON),
		  .CONin(CONin)
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
			Reg_load1b : Present_state = Reg_load1c;
         Reg_load1c : Present_state = Reg_load1d;
         Reg_load1d : Present_state = Reg_load1e;
         Reg_load1e : Present_state = Reg_load1f;
         Reg_load1f : Present_state = T0;
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
			PCout <= 0; Zlowout <= 0; MDRout <= 0; HIout <= 0; 
			LOout <= 0; Z_high_out <= 0; Cout <= 0;
			In_Port_out <= 0; LOin <= 0; HIin <= 0; MARin <= 0;

			 MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; 
			 IRin <= 0; Yin <= 0; CONin <= 0; CON <= 0;
			 Read <= 0; Write <= 0; control <= 5'd0;
			 Clear <= 0; RAM_read <= 0; RAM_write <= 0; PC_tb_enable <= 0;

             Gra <= 0; Grb <= 0; Grc <= 0; Rin <= 0; Rout <= 0; BAout <= 0;
			 in_enable <= 16'b0; out_enable <= 16'b0; Mdatain <= 32'h00000000;
             PC <= 32'h0;
		end
        Reg_load1a: begin
             PC <= 32'b0; PC_tb_enable <= 1; PCout <= 1; control <= 5'd19;
			 #5 Zin <= 1; MARin <= 1;
			 #10 PCout <= 0; PC_tb_enable <= 0;//Zin <= 1;
			 #5 Zin <= 0; control <= 5'd0; MARin <= 0;
		end
		Reg_load1b: begin
			 Read <= 1; Zlowout <= 1;
			 #5 RAM_read <= 1; PCin <= 1; MDRin <= 1;
			 #5 //MDRin <= 1;
			 #5 Zlowout <= 0; RAM_read <= 0;
			 #5 PCout <= 0; Read <= 0; PCin <= 0; MDRin <= 0;
		end
        Reg_load1c: begin
			 MDRout <= 1;
			 #5  IRin <= 1; 
			 #10 MDRout <= 0;
			 #5  IRin <= 0;
        end
        Reg_load1d: begin
            Grb <= 1; BAout <= 1;
            #5 Yin <= 1;
			#10 Grb <= 0; BAout <= 0;
            #5 Yin <= 0;
        end
        Reg_load1e: begin
            Cout <= 1; control <= 5'd3;
            #5 Zin <= 1;
            #15 Zin <= 0; Cout <= 0;
        end
        Reg_load1f: begin
            Zlowout <= 1;
			#5 Rin <= 1; Gra <= 1;
			#10 Zlowout <= 0;
			#5 Rin <= 0; Gra <= 0;
        end
		T0: begin
			 PCout <= 1; control <= 5'd19; MARin <= 1;
			 #5 Zin <= 1; MARin <= 1;
			 #10 PCout <= 0;
			 #5 MARin <= 0; Zin <= 0; control <= 5'd0;
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
            Gra <= 1; Rout <= 1;
            #5 CONin <= 1;
			#5 Gra <= 0;
            #10 CONin <= 0; Rout <= 0;
        end
        T4: begin
            PCout <= 1;
            #5 Yin <= 1;
            #15 PCout <= 0; Yin <= 0;
        end
        T5: begin
            Cout <= 1; control <= 5'd3;
            #5 Zin <= 1;
            #15 Cout <= 0; Zin <= 0;
        end
        T6: begin
            Zlowout <= 1; control <= 5'd19;
            #5 Zin <= 1; 
            #15 Cout <= 0; Zin <= 0;
        end
        T7: begin
            Zlowout <= 1;
            #5 if (CON) begin
                PCin <= 1;
            end
            #10 Zlowout <= 0;
            #5 PCin <= 0;
        end
        endcase
    end
	 
endmodule
