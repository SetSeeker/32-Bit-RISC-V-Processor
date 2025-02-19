`timescale 1ns/10ps

module mul_tb;
    // Control signals
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, 
        R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, 
        PCout, Zlowout, Zhighout, MDRout, HIout, LOout, Z_high_out,
        In_Port_out, C_sign_extended_out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg Read, MUL;
    reg IncPC;
    reg LOin, HIin; 
    reg Clock, Clear;
    reg [15:0] enable;
    reg [31:0] Mdatain;
    reg [3:0] control;

    // State encoding
    parameter
        Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
        Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
        T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101;

    reg [3:0] Present_state = Default;

    // Instantiate the existing Datapath module
    DataPath DUT(
        .Clock(Clock), .Clear(Clear), .Zin(Zin), .PCin(PCin), .MDRin(MDRin), .IRin(IRin), .Yin(Yin), .MARin(MARin), .LOin(LOin), .HIin(HIin),
        .Read(Read), .enable(enable), .Mdatain(Mdatain), .control(control), .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), 
        .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out), 
        .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out), .PCout(PCout), .MDRout(MDRout), .HIout(HIout), .LOout(LOout),
        .Z_high_out(Z_high_out), .Z_low_out(Zlowout), .In_Port_out(In_Port_out), .C_sign_extended_out(C_sign_extended_out)
    );

    // Instantiate Booth Multiplier
    wire [63:0] mul_result;  // 64-bit output
    boothMul #(32) booth_multiplier (
        .a(DUT.R2),
        .b(DUT.R6),
        .data_out(mul_result)
    );

    // Clock generation
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Finite state machine
    always @(posedge Clock) begin
        case (Present_state)
            Default: Present_state = Reg_load1a;
            Reg_load1a: Present_state = Reg_load1b;
            Reg_load1b: Present_state = Reg_load2a;
            Reg_load2a: Present_state = Reg_load2b;
            Reg_load2b: Present_state = Reg_load3a;
            Reg_load3a: Present_state = Reg_load3b;
            Reg_load3b: Present_state = T0;
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
                R0out <= 0; R1out <= 0; R2out <= 0; R3out <= 0; 
                R4out <= 0; R5out <= 0; R6out <= 0; R7out <= 0; 
                R8out <= 0; R9out <= 0; R10out <= 0; R11out <= 0; 
                R12out <= 0; R13out <= 0; R14out <= 0; R15out <= 0; 
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0; HIout <= 0; 
                LOout <= 0; Z_high_out <= 0; C_sign_extended_out <= 0;
                In_Port_out <= 0; LOin <= 0; HIin <= 0; MARin <= 0;
                IncPC <= 0; MUL <= 0;
                MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; 
                IRin <= 0; Yin <= 0;
                Read <= 0; control <= 4'd0;
                Clear <= 0;
                enable <= 16'b0; Mdatain <= 32'h00000000;
            end

            Reg_load1a: begin
                Mdatain <= 32'h00000022;
                #10 Read <= 1; MDRin <= 1;   // Increased delay for proper signal propagation
                #20 Read <= 0; MDRin <= 0;   // Ensuring proper signal deactivation
            end
            Reg_load1b: begin
                #10 MDRout <= 1; enable <= (1 << 2);
                #20 MDRout <= 0; enable <= 16'b0; // initialize R2 with the value 0x22
                $display("R2 = %h", DUT.R2);
            end

            Reg_load2a: begin
                Mdatain <= 32'h00000024;
                #10 Read <= 1; MDRin <= 1;
                #20 Read <= 0; MDRin <= 0;
            end
            Reg_load2b: begin
                #10 MDRout <= 1; enable <= (1 << 6);
                #20 MDRout <= 0; enable <= 16'd0; // initialize R6 with the value 0x24
                $display("R6 = %h", DUT.R6);
            end

            T0: begin
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
                #10 Zin <= 1;
                #15 MARin <= 0; PCout <= 0; // Give more time for propagation
                #10 Zin <= 0;
            end

            T1: begin
                Mdatain <= 32'h00062020; // Opcode: mul R2, R6
                Zlowout <= 1;
                #10 Read <= 1; PCin <= 1; MDRin <= 1;
                #15 Zlowout <= 0;
                #10 PCout <= 0; Read <= 0; PCin <= 0; MDRin <= 0;
            end

            T4: begin
                R6out <= 1; MUL <= 1; Zin <= 1;
                #15 R6out <= 0; Zin <= 0; // Allow multiplication to complete
            end

            T5: begin
                Zlowout <= 1; LOin <= 1;
                #15 Zlowout <= 0; LOin <= 0;
            end

            T6: begin
                Zhighout <= 1; HIin <= 1;
                #15 Zhighout <= 0; HIin <= 0;
            end

        endcase
    end
endmodule