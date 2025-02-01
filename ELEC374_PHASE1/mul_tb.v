// mul_tb.v file: Testbench for mul R2, R6
`timescale 1ns/10ps

module mul_tb;
    // Control signals
    reg PCout, Zlowout, Zhighout, MDRout, R2out, R6out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
    reg IncPC, Read, MUL;
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
            Default: Present_state = T0;
            T0: Present_state = T1;
            T1: Present_state = T2;
            T2: Present_state = T3;
            T3: Present_state = T4;
            T4: Present_state = T5;
            T5: Present_state = T6;
            T6: Present_state = Default; // Reset to Default after completion
        endcase
    end

    // Test logic for each state
    always @(Present_state) begin
        case (Present_state)
            Default: begin
                // Initialize all control signals to 0
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
                R2out <= 0; R6out <= 0; MARin <= 0; Zin <= 0;
                PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
                LOin <= 0; HIin <= 0; IncPC <= 0; Read <= 0; MUL <= 0;
                Mdatain <= 32'h00000000;
            end

            T0: begin
                // Step T0: PCout, MARin, IncPC, Zin
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            end

            T1: begin
                // Step T1: Zlowout, PCin, Read, Mdatain[31..0], MDRin
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
                Mdatain <= 32'h00062020; // Opcode: mul R2, R6
            end

            T2: begin
                // Step T2: MDRout, IRin
                MDRout <= 1; IRin <= 1;
            end

            T3: begin
                // Step T3: R2out, Yin
                R2out <= 1; Yin <= 1;
            end

            T4: begin
                // Step T4: R6out, MUL, Zin
                R6out <= 1;
                
                Zin <= 1;
            end

            T5: begin
                // Step T5: Zlowout, LOin
                Zlowout <= 1; LOin <= 1;
            end

            T6: begin
                // Step T6: Zhighout, HIin
                Zhighout <= 1; HIin <= 1;
            end
        endcase
    end
endmodule