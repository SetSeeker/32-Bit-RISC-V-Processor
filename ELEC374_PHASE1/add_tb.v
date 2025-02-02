// add_tb.v file: Testbench for add R4, R3 and R7
`timescale 1ns/10ps

module add_tb;
    // Control signals
    reg PCout, Zlowout, Zhighout, MDRout, R2out, R6out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
    reg IncPC, Read, ADD, R3in, R4in, R7in;
    reg Clock;
    reg [31:0] Mdatain;

    // State encoding
    parameter Default = 4'b0000, 
              T0 = 4'b0001, 
              T1 = 4'b0010, 
              T2 = 4'b0011,
              T3 = 4'b0100, 
              T4 = 4'b0101, 
              T5 = 4'b0110, 
              T6 = 4'b0111;

    reg [3:0] Present_state = Default;

    // Instantiate the existing Datapath module
    Datapath DUT(
        PCout, Zlowout, Zhighout, MDRout, R2out, R6out, MARin, Zin, PCin, MDRin, IRin, Yin, 
        IncPC, Read, MUL, LOin, HIin, Clock, Mdatain
    );

    // Clock generation
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Finite state machine
    always @(posedge Clock) begin
        case (Present_state)
            Default     : Present_state = Reg_load1a;
            Reg_load1a  : Present_state = Reg_load1b;
            Reg_load1b  : Present_state = Reg_load2a;
            Reg_load2a  : Present_state = Reg_load2b;
            Reg_load2b  : Present_state = Reg_load3a;
            Reg_load3a  : Present_state = Reg_load3b;
            Reg_load3b  : Present_state = T0;
            T0          : Present_state = T1;
            T1          : Present_state = T2;
            T2          : Present_state = T3;
            T3          : Present_state = T4;
            T4          : Present_state = T5;
        endcase
    end

    // Test logic for each state
    always @(Present_state) begin
        case (Present_state)
            Default: begin
                // Initialize all control signals
                PCout <= 0; Zlowout <= 0; MDRout <= 0;
                R3out <= 0; R7out <= 0; MARin <= 0; Zin <= 0;
                PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
                IncPC <= 0; Read <= 0; ADD <= 0;
                R3in <= 0; R4in <= 0; R7in <= 0;
                Mdatain <= 32'h00000000;
            end

            // Load R3 with 0x22
            Reg_load1a: begin
                Mdatain <= 32'h00000022;
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load1b: begin
                MDRout <= 1; R3in <= 1;
                #15 MDRout <= 0; R3in <= 0;
            end

            // Load R7 with 0x24
            Reg_load2a: begin
                Mdatain <= 32'h00000024;
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load2b: begin
                MDRout <= 1; R7in <= 1;
                #15 MDRout <= 0; R7in <= 0;
            end

            // Load R4 with 0x28 (destination register)
            Reg_load3a: begin
                Mdatain <= 32'h00000028;
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load3b: begin
                MDRout <= 1; R4in <= 1;
                #15 MDRout <= 0; R4in <= 0;
            end

            // Instruction Fetch: Fetch the opcode for "add R4, R3, R7"
            T0: begin
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            end

            T1: begin
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
                Mdatain <= 32'h2A2A8000; // Opcode for "add R4, R3, R7"
            end

            T2: begin
                MDRout <= 1; IRin <= 1;
            end

            T3: begin
                R3out <= 1; Yin <= 1;
            end

            T4: begin
                R7out <= 1; ADD <= 1; Zin <= 1;
            end

            T5: begin
                Zlowout <= 1; R4in <= 1;
            end

        endcase
    end
endmodule
