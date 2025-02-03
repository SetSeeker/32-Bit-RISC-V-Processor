`timescale 1ns / 1ps

module alu_tb;
    parameter DATA_WIDTH = 32;

    // Testbench signals
    reg [DATA_WIDTH-1:0] a, b;          // Inputs to the ALU
    reg [3:0] control;                  // Control signal to select ALU operation
    wire [DATA_WIDTH-1:0] result;       // Output from the ALU

    // Instantiate the ALU
    ALU #(DATA_WIDTH) DUT (
        .a(a),
        .b(b),
        .control(control),
        .Z_reg(result)                     // Ensure this matches the ALU output port
    );

    initial begin
        $display("Starting ALU Testbench...");
        
        // ADD Operation (control = 0)
        a = 32'd25; 
        b = 32'd17;
        control = 4'd0;
        #10;
        $display("ADD Operation: A=%d, B=%d, Result=%d", a, b, result);

        // SUB Operation (control = 1)
        control = 4'd1;
        #10;
        $display("SUB Operation: A=%d, B=%d, Result=%d", a, b, result);

        // MUL Operation (control = 2)
        control = 4'd2;
        #10;
        $display("MUL Operation: A=%d, B=%d, Result=%d", a, b, result);

        // DIV Operation (control = 3)
        control = 4'd3;
        #10;
        $display("DIV Operation: A=%d, B=%d, Result=%d", a, b, result);

        // AND Operation (control = 4)
        a = 32'h0F0F0F0F; 
        b = 32'h00FF00FF;
        control = 4'd4;
        #10;
        $display("AND Operation: A=%h, B=%h, Result=%h", a, b, result);

        // OR Operation (control = 5)
        control = 4'd5;
        #10;
        $display("OR Operation: A=%h, B=%h, Result=%h", a, b, result);

        // SHR Operation (Shift Right, control = 6)
        a = 32'b10011000; 
        b = 32'd2;
        control = 4'd6;
        #10;
        $display("SHR Operation: A=%b, Shift=%d, Result=%b", a, b, result);

        // SHRA Operation (Arithmetic Shift Right, control = 7)
        a = -32'd8; 
        b = 32'd1;
        control = 4'd7;
        #10;
        $display("SHRA Operation: A=%d, Shift=%d, Result=%d", a, b, result);

        // SHL Operation (Shift Left, control = 8)
        a = 32'b00011001;
        b = 32'd2;
        control = 4'd8;
        #10;
        $display("SHL Operation: A=%b, Shift=%d, Result=%b", a, b, result);

        // ROR Operation (Rotate Right, control = 9)
        a = 32'b10011001;
        b = 32'd3;
        control = 4'd9;
        #10;
        $display("ROR Operation: A=%b, Rotate=%d, Result=%b", a, b, result);

        // ROL Operation (Rotate Left, control = 10)
        control = 4'd10;
        #10;
        $display("ROL Operation: A=%b, Rotate=%d, Result=%b", a, b, result);

        // NEG Operation (Negate, control = 11)
        a = 32'd15;
        control = 4'd11;
        #10;
        $display("NEG Operation: A=%d, Result=%d", a, result);

        // NOT Operation (Bitwise NOT, control = 12)
        a = 32'hFFFF0000;
        control = 4'd12;
        #10;
        $display("NOT Operation: A=%h, Result=%h", a, result);

        // Finish the simulation
        $display("ALU Testbench Complete.");
        $finish;
    end

    // // Dump waveform for GTKWave
    // initial begin
    //     $dumpfile("alu_tb.vcd");
    //     $dumpvars(0, alu_tb);
    // end
endmodule
