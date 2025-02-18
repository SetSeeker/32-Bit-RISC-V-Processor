`timescale 1ns/10ps

module mul_tb;
    // Control signals
    reg PCout, Zlowout, Zhighout, MDRout, R2out, R6out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
    reg IncPC, Read, MUL;
    reg Clock;
    reg [31:0] Mdatain;
    reg [15:0] enable_reg;

    // State encoding
    parameter
        Default = 4'b0001,
        Reg_load1a = 4'b0010, Reg_load1b = 4'b0011, Reg_load2a = 4'b0100, Reg_load2b = 4'b0101, Reg_load3a = 4'b0110, Reg_load3b = 4'b0111,
        T0 = 4'b1000, T1 = 4'b1001, T2 = 4'b1010, T3 = 4'b1011, T4 = 4'b1100, T5 = 4'b1101, T6 = 4'b1110;

    reg [3:0] Present_state = Default;

    // Instantiate the existing Datapath module
    Datapath DUT(
        .PCout(PCout), .Zlowout(Zlowout), .Zhighout(Zhighout), .MDRout(MDRout), 
        .R2(R2out), .R6(R6out), .MARin(MARin), .Zin(Zin), .PCin(PCin), 
        .MDRin(MDRin), .IRin(IRin), .Yin(Yin), .IncPC(IncPC), .Read(Read), 
        .MUL(MUL), .LOin(LOin), .HIin(HIin), .Clock(Clock), .Mdatain(Mdatain)
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
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
                R2out <= 0; R6out <= 0; MARin <= 0; Zin <= 0;
                PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
                LOin <= 0; HIin <= 0; IncPC <= 0; Read <= 0; MUL <= 0;
                Mdatain <= 32'h00000000;
            end

            Reg_load1a: begin
                Mdatain <= 32'h00000022;
                #5 Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load1b: begin
                #5 MDRout <= 1; enable_reg <= (1 << 2);
                #15 MDRout <= 0; enable_reg <= 16'b0; // initialize R2 with the value 0x22
            end

            Reg_load2a: begin
                Mdatain <= 32'h00000024;
                #5 Read <= 1; MDRin <= 1; 
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load2b: begin
                #5 MDRout <= 1; enable_reg <= (1 << 6);
                #15 MDRout <= 0; enable_reg <= 16'b0; // initialize R6 with the value 0x24
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
                MUL <= 1;
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