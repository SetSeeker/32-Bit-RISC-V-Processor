`timescale 1ns/10ps
module control_unit (
  output reg  PCout, Z_high_out, MDRout, MARin, PCin, MDRin, IRin, Yin,
              Read, HIin, LOin, HIout, LOout, Zin, Cout, RAM_write,
              Gra, Grb, Grc, Rin, Rout, BAout, CONin, output_port_in,
              in_port_out, Run, Zlowout, RAM_read,
  output CON,
  input [31:0] IR,
  output reg[4:0] control,
  input clk, clr, stop
  );

  // State Definitions – each state lasts one clock cycle
  parameter reset_state = 8'b00000000,
            fetch0 = 8'b00000001,
            fetch1 = 8'b00000010,
            fetch2 = 8'b00000011,
            add3 = 8'b00000100, 
            add4 = 8'b00000101, 
            add5 = 8'b00000110, 
            sub3 = 8'b00000111, 
            sub4 = 8'b00001000, 
            sub5 = 8'b00001001,
            mul3 = 8'b00001010, 
            mul4 = 8'b00001011, 
            mul5 = 8'b00001100, 
            mul6 = 8'b00001101, 
            div3 = 8'b00001110, 
            div4 = 8'b00001111,
            div5 = 8'b00010000, 
            div6 = 8'b00010001, 
            or3 = 8'b00010010, 
            or4 = 8'b00010011, 
            or5 = 8'b00010100, 
            and3 = 8'b00010101, 
            and4 = 8'b00010110, 
            and5 = 8'b00010111, 
            shl3 = 8'b00011000, 
            shl4 = 8'b00011001, 
            shl5 = 8'b00011010, 
            shr3 = 8'b00011011,
            shr4 = 8'b00011100, 
            shr5 = 8'b00011101, 
            rol3 = 8'b00011110, 
            rol4 = 8'b00011111, 
            rol5 = 8'b00100000, 
            ror3 = 8'b00100001,
            ror4 = 8'b00100010, 
            ror5 = 8'b00100011, 
            neg3 = 8'b00100100, 
            neg4 = 8'b00100101, 
            not3 = 8'b00100111,
            not4 = 8'b00101000, 
            ld3 = 8'b00101010, 
            ld4 = 8'b00101011, 
            ld5 = 8'b00101100, 
            ld6 = 8'b00101101, 
            ld7 = 8'b00101110,
            ldi3 = 8'b00101111, 
            ldi4 = 8'b00110000, 
            ldi5 = 8'b00110001, 
            st3 = 8'b00110010, 
            st4 = 8'b00110011,
            st5 = 8'b00110100, 
            st6 = 8'b00110101, 
            st7 = 8'b00110110, 
            addi3 = 8'b00110111, 
            addi4 = 8'b00111000, 
            addi5 = 8'b00111001,
            andi3 = 8'b00111010, 
            andi4 = 8'b00111011, 
            andi5 = 8'b00111100, 
            ori3 = 8'b00111101, 
            ori4 = 8'b00111110, 
            ori5 = 8'b00111111,
            br3 = 8'b01000000, 
            br4 = 8'b01000001, 
            br5 = 8'b01000010, 
            br6 = 8'b01000011, 
            br7 = 8'b11111111, 
            jr3 = 8'b01000100, 
            jal3 = 8'b01000101, 
            jal4 = 8'b01000110, 
            mfhi3 = 8'b01000111, 
            mflo3 = 8'b01001000, 
            in3 = 8'b01001001, 
            out3 = 8'b01001010, 
            nop3 = 8'b01001011, 
            halt3 = 8'b01001100;

  reg [7:0] present_state, next_state;

    initial begin
    present_state = reset_state;
  end
  
  always @(posedge clk or posedge clr or posedge stop) begin
    if (clr)
      present_state <= reset_state;
    else if (stop)
      present_state <= halt3;
    else
      present_state <= next_state;
  end
  
  // Next-state combinational logic
  always @(posedge clk, posedge clr, posedge stop) begin
    next_state = present_state; // default: hold state
    case (present_state)
      reset_state: next_state = fetch0;
      fetch0:      next_state = fetch1;
      fetch1:      next_state = fetch2;
      fetch2: begin
        case(IR[31:27])
            5'b00000 : begin
              next_state = ld3;
            end
            5'b00001: begin
              next_state = ldi3;
            end
            5'b10011: begin
              next_state = br3;
            end
            5'b00011 : begin
              next_state = add3;	
            end
            5'b00100 : begin
              next_state = sub3;
            end
            5'b10000 : begin
              next_state = mul3;
            end
            5'b01111 : begin
              next_state = div3;
            end
            5'b01001 : begin
              next_state = shr3;
            end
            5'b01011 : begin
              next_state = shl3;
            end
            5'b00111 : begin
              next_state = ror3;
            end
            5'b01000 : begin
              next_state = rol3;
            end
            5'b00101 : begin
              next_state = and3;
            end
            5'b00110 : begin
              next_state = or3;
            end
            5'b10001 : begin
              next_state = neg3;
            end
            5'b10010 : begin
              next_state = not3;
            end
            5'b01010 : begin // SHRA
              next_state = shr3;
            end 
            5'b01100 : begin
              next_state = addi3; // ADD immidiate
            end
            5'b01101 : begin
              next_state = andi3; //AND Immidiate
            end
            5'b01110 : begin
              next_state = ori3;
            end

            5'b00010 : begin
              next_state = st3;
            end
            5'b10101 : begin
              next_state = jr3; 
            end
            5'b10100 : begin
              next_state = jal3;
            end
            5'b11001 : begin
              next_state = mfhi3;
            end
            5'b11000 : begin
              next_state = mflo3;
            end
            5'b10110 : begin
              next_state = in3;
            end
            5'b10111 : begin
              next_state = out3;
            end
            5'b11010 : begin
              next_state = nop3;
            end
            5'b11011 : begin
              next_state = halt3;
            end
        endcase
      end

      in3:       next_state = fetch0;
      
      out3:      next_state = fetch0;

      ldi3:      next_state = ldi4;
      ldi4:      next_state = ldi5;
      ldi5:      next_state = fetch0;

      ld3:      next_state = ld4;
      ld4:      next_state = ld5;
      ld5:      next_state = ld6;
      ld6:      next_state = ld7;
      ld7:      next_state = fetch0;

      br3:      next_state = br4;
      br4:      next_state = br5;
      br5:      next_state = br6;
      br6:      next_state = fetch0;
      
      add3:      next_state = add4;
      add4:      next_state = add5;
      add5:      next_state = fetch0; 

      sub3:      next_state = sub4;
      sub4:      next_state = sub5;
      sub5:      next_state = fetch0;     

      mul3:      next_state = mul4;
      mul4:      next_state = mul5;
      mul5:      next_state = mul6;
      mul6:      next_state = fetch0;  
      
      div3:      next_state = div4;
      div4:      next_state = div5;
      div5:      next_state = div6;
      div6:      next_state = fetch0;  

      or3:      next_state = or4;
      or4:      next_state = or5;
      or5:      next_state = fetch0;

      addi3:      next_state = addi4;
      addi4:      next_state = addi5;
      addi5:      next_state = fetch0;

      andi3:      next_state = andi4;
      andi4:      next_state = andi5;
      andi5:      next_state = fetch0;

      and3:      next_state = and4;
      and4:      next_state = and5;
      and5:      next_state = fetch0;

      neg3:      next_state = neg4;
      neg4:      next_state = fetch0;

      not3:      next_state = not4;
      not4:      next_state = fetch0;

      jal3:      next_state = jal4;
      jal4:      next_state = fetch0;

      jr3:       next_state = fetch0;

      ror3:      next_state = ror4;
      ror4:      next_state = ror5;
      ror5:      next_state = fetch0;

      ori3:      next_state = ori4;
      ori4:      next_state = ori5;
      ori5:      next_state = fetch0;

      shr3:      next_state = shr4;
      shr4:      next_state = shr5;
      shr5:      next_state = fetch0;

      st3:      next_state = st4;
      st4:      next_state = st5;
      st5:      next_state = st6;
      st6:      next_state = st7;
      st7:      next_state = fetch0;

      rol3:      next_state = rol4;
      rol4:      next_state = rol5;
      rol5:      next_state = fetch0;

      shl3:      next_state = shl4;
      shl4:      next_state = shl5;
      shl5:      next_state = fetch0;

      mfhi3:      next_state = fetch0;
      mflo3:      next_state = fetch0;

      nop3:     next_state = fetch0;


      halt3: next_state = halt3;
      default:   next_state = reset_state;
    endcase
  end

  // Combinational output logic: default all signals to 0, then override as needed.
  always @(*) begin
    case (present_state)
      reset_state: begin
        // Default assignments (deassert all control signals)
        PCout = 0; Z_high_out = 0; MDRout = 0; MARin = 0; PCin = 0; 
        MDRin = 0; IRin = 0; Yin = 0; Read = 0;
        HIin = 0; LOin = 0; HIout = 0; LOout = 0; Zin = 0;
        Cout = 0; RAM_write = 0; Gra = 0; Grb = 0; Grc = 0;
        Rin = 0; Rout = 0; BAout = 0; CONin = 0;
        output_port_in = 0; in_port_out = 0; Run = 1; Zlowout = 0; Yin <= 0;
        control <= 5'd0; RAM_read <= 0;
      end
      
      fetch0: begin
			 PCout <= 1; control <= 5'd19; MARin <= 1;
			 #5 Zin <= 1;
			 #10 PCout <= 0;
			 #5 MARin <= 0; Zin <= 0; control <= 5'd0;
      end
      
      fetch1: begin
			 RAM_read <= 1; Zlowout <= 1;
			 #5 Read <= 1; PCin <= 1; MDRin <= 1;
			 #5 
			 #5 Zlowout <= 0; RAM_read <= 0;
			 #5 PCout <= 0; Read <= 0; PCin <= 0; MDRin <= 0;
      end
      
      fetch2: begin
			 MDRout <= 1;
			 #5 MARin <= 1; IRin <= 1; 
			 #10 MDRout <= 0;
			 #5  MARin <= 0; IRin <= 0;
      end
      
      // ldi operation sequence:
      ldi3: begin
            Grb <= 1; BAout <= 1;
            #5 Yin <= 1;
			      #5 Grb <= 0;
            #10 Yin <= 0; BAout <= 0;
      end
      
      ldi4: begin
            Cout <= 1; control <= 5'd3;
            #5 Zin <= 1;
            #15 Cout <= 0; Zin <= 0;
      end
      
      ldi5: begin
            Zlowout <= 1;
            #5 Rin <= 1; Gra <= 1; Zlowout <= 0;
            #10 Zlowout <= 0;
            #5 Rin <= 0; Gra <= 0;
      end

      // ld operation sequence:
      ld3: begin
           Grb <= 1; BAout <= 1; 
            #5 Yin <= 1;
			      #5 Grb <= 0;
            #10 Yin <= 0; BAout <= 0;
      end
      ld4: begin
            Cout <= 1; control <= 5'd3;
            #5 Zin <= 1;
            #15 Cout <= 0; Zin <= 0;
      end
      ld5: begin
            #5 Zlowout <= 1; MARin <= 1;
            #15 Zlowout <= 0; MARin <= 0;
      end
      ld6: begin
            #5 Read <= 1; RAM_read <= 1; MDRin <= 1;
            #15 Read <= 0; RAM_read <= 0; MDRin <= 0;
      end
      ld7: begin
            #5 MDRout <= 1; Gra <=1; Rin <= 1;
            #15 MDRout <= 0; Gra <=0; Rin <= 0;
      end

      // br operation

      br3: begin
            Gra <= 1;
            #5 Rout <= 1; CONin <= 1;
			      #10 
            #5 Gra <= 0; CONin <= 0; Rout <= 0;
      end
      br4: begin
            PCout <= 1;
            #5 Yin <= 1;
            #15 PCout <= 0; Yin <= 0;
      end
      br5: begin
            Cout <= 1; control <= 5'd3;
            #10 Zin <= 1; 
            #10 Cout <= 0; Zin <= 0; control <= 5'd0;
      end
      br6: begin
            #5 Zlowout <= 1;
            #5 if (CON) begin
                PCin <= 1;
            end
            #5 Zlowout <= 0;
            #5 PCin <= 0; Zin <= 0; 
      end

      in3: begin
            #5 in_port_out <= 1; Gra <= 1; Rin <= 1;
            #5 
            #10 in_port_out <= 0; Gra <= 0; Rin <= 0;
      end

      out3: begin
            #5 output_port_in <= 1; Gra <= 1; Rout <= 1;
            #5 
            #10 output_port_in <= 0; Gra <= 0; Rout <= 0;
      end

      // ADD instruction

      add3: begin
            #5 Grb <= 1; Rout <= 1; Yin  <= 1;
            #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  add4: begin
              Grc <= 1; Rout <= 1; control <= 5'd3; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  add5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // SUB instruction

      sub3: begin
            #5 Grb <= 1; Rout <= 1; Yin  <= 1;
            #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  sub4: begin
              Grc <= 1; Rout <= 1; control <= 5'd4; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  sub5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end


      // MUL instruction

      mul3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
      end
      mul4: begin
              Gra <= 1; Rout   <= 1; control <= 5'd16;
              #5  Zin <= 1;
              #10 Gra <= 0;  Rout <= 0;
              #5  Zin <= 0;
      end
      mul5: begin
              #5 Zlowout <= 1; LOin <= 1;
              #15 Zlowout <= 0; LOin <= 0;
      end
      mul6: begin
              #5 Z_high_out <= 1; HIin <= 1;
              #15 Z_high_out <= 0; HIin <= 0;
      end

      // DIV instruction

      div3: begin
              #5 Gra <= 1; Rout <= 1; Yin  <= 1;
              #15 Gra <= 0; Rout <= 0; Yin <= 0;
      end
      div4: begin
              Grb <= 1; Rout <= 1; control <= 5'd15;
              #5  Zin <= 1;
              #10 Grb <= 0;  Rout <= 0;
              #5  Zin <= 0;
      end
      div5: begin
              #5 Zlowout <= 1; LOin <= 1;
              #15 Zlowout <= 0; LOin <= 0;
      end
      div6: begin
              #5 Z_high_out <= 1; HIin <= 1;
              #15 Z_high_out <= 0; HIin <= 0;
      end

      // OR instruction

      or3: begin
            #5 Grb <= 1; Rout <= 1; Yin  <= 1;
            #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  or4: begin
              Grc <= 1; Rout <= 1; control <= 5'd6; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  or5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // AND instruction

      and3: begin
            #5 Grb <= 1; Rout <= 1; Yin  <= 1;
            #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  and4: begin
              Grc <= 1; Rout <= 1; control <= 5'd5; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  and5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // ORI operation

      ori3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  ori4: begin
              Cout <= 1; control <= 5'd6; 
              #5 Zin <= 1;
              #10 Cout <= 0;
              #5 Zin <= 0;
		  end
		  ori5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // ADDI operation

      addi3: begin
            #5 Grb <= 1; Rout <= 1; Yin  <= 1;
            #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  addi4: begin
              Cout <= 1; control <= 5'd3; 
              #5  Zin <= 1;
              #10 Cout <= 0;
              #5  Zin <= 0;
		  end 
		  addi5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // NEG operation
      neg3: begin
              Grb <= 1; Rout <= 1; control <= 5'd17; 
              #5 Zin <= 1;
              #10 Grb <= 0; Rout <= 0;
              #5 Zin <= 0;
		  end
		  neg4: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // NOT operation
      not3: begin
              Grb <= 1; Rout <= 1; control <= 5'd18; 
              #5 Zin <= 1;
              #10 Grb <= 0; Rout <= 0;
              #5 Zin <= 0;
		  end
		  not4: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // ANDI operation

      andi3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  andi4: begin
              Cout <= 1; control <= 5'd5; 
              #5 Zin <= 1;
              #10 Cout <= 0;
              #5 Zin <= 0;
		  end
		  andi5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // ROR operation

      ror3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  ror4: begin
              Grc <= 1; Rout <= 1; control <= 5'd7; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  ror5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // ROL operation

      rol3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  rol4: begin
              Grc <= 1; Rout <= 1; control <= 5'd8; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  rol5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end
      
      // SHL operation

      shl3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  shl4: begin
              Grc <= 1; Rout <= 1; control <= 5'd11; 
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  shl5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // SHR and SHRA operation

      shr3: begin
              #5 Grb <= 1; Rout <= 1; Yin  <= 1;
              #15 Grb <= 0; Rout <= 0; Yin <= 0;
		  end
		  shr4: begin
              Grc <= 1; Rout <= 1; 
              if(IR[31:27] == 5'b01010) begin
                control <= 5'd10; 
              end else if (IR[31:27] == 5'b01001)begin
                control <= 5'd9; 
              end
              #5  Zin <= 1;
              #10 Grc <= 0;  Rout <= 0;
              #5  Zin <= 0;
		  end
		  shr5: begin
              Zlowout <= 1;
              #10 Gra <= 1; Rin <= 1; LOin <= 1;
              #10 Gra <= 0;  Rin <= 0; Zlowout <= 0; LOin <= 0;
		  end

      // LD instruction

      st3: begin
            Grb <= 1; BAout <= 1;
            #5 Yin <= 1;
			      #5 Grb <= 0;
            #10 Yin <= 0; BAout <= 0;
      end
      st4: begin
            Cout <= 1; control <= 5'd3;
            #5 Zin <= 1;
            #15 Cout <= 0; Zin <= 0;
      end
      st5: begin
            #5 Zlowout <= 1; MARin <= 1;
            #15 Zlowout <= 0; MARin <= 0;
      end
      st6: begin
            #5 Gra <= 1; Rout <= 1; MDRin <= 1;
            #15 Gra <= 0; Rout <= 0; MDRin <= 0;
      end
      st7: begin
            #5 MDRout <= 1; RAM_write <= 1;
            #15 MDRout <= 0; RAM_write <= 0;
      end

      // MFHI instruction

      mfhi3: begin
            #5 HIout <= 1; Gra <= 1;
            #5 Rin <= 1;
            #5
            #5 HIout <= 0; Gra <= 0; Rin <= 0;
      end

      // MFLO instruction

      mflo3: begin
            #5 LOout <= 1; Gra <= 1;
            #5 Rin <= 1;
            #5
            #5 LOout <= 0; Gra <= 0; Rin <= 0;
      end

      // JAL instruction

      jal3: begin
            PCout <= 1;
            #5 Gra <= 1; Rin <= 1;
            #15 PCout <= 0;  Gra <= 0; Rin <= 0;
      end

      jal4: begin
            Grb <= 1; Rout <= 1;
            #5 PCin <= 1;
            #15  Grb <= 0; Rout <= 0; PCin <= 0;
      end

       // jr instruction

      jr3: begin
            Gra <= 1; Rout <= 1;
            #10 PCin <= 1;
			      #5
            #5 Gra <= 0; Rout <= 0; PCin <= 0;
        end

      nop3: begin
        // do nothing
      end
      
      halt3: begin
         Run = 0;
      end
      
      default: begin
      end
    endcase
  end

endmodule
