`timescale 1ns / 10ps

module shl_tb;
    parameter DATA_WIDTH = 32;

    reg [DATA_WIDTH-1:0] data_in;
    reg [$clog2(DATA_WIDTH)-1:0] shift_amount;
    wire [DATA_WIDTH-1:0] data_out;

    // Instantiate the SHL module
    shl #(DATA_WIDTH) uut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    initial begin
        $display("\n=====================================");
        $display(" SHIFT LEFT OPERATION TEST RESULTS ");
        $display("=====================================");
        $display(" Input (bin)            | Shift | Output (bin)           | Input (dec) | Output (dec)");
        $display("------------------------|-------|------------------------|------------|------------");

        // Test 1: Shift Left by 1
        data_in = 32'b00000000000000000000000000001111; shift_amount = 1; #10;
        $display("%b | %2d    | %b | %10d | %10d", data_in, shift_amount, data_out, data_in, data_out);

        // Test 2: Shift Left by 2
        data_in = 32'b111111111111111111111111111111111; shift_amount = 2; #10;
        $display("%b | %2d    | %b | %10d | %10d", data_in, shift_amount, data_out, data_in, data_out);

        // Test 3: Shift Left by 8
        data_in = 32'b10101010101010101010101010101010; shift_amount = 8; #10;
        $display("%b | %2d    | %b | %10d | %10d", data_in, shift_amount, data_out, data_in, data_out);

        // Test 4: Shift Left by 16
        data_in = 32'b00000000111100001111000011110000; shift_amount = 16; #10;
        $display("%b | %2d    | %b | %10d | %10d", data_in, shift_amount, data_out, data_in, data_out);

        // Test 5: Shift Left by 0 (No change)
        data_in = 32'b11001100110011001100110011001100; shift_amount = 0; #10;
        $display("%b | %2d    | %b | %10d | %10d", data_in, shift_amount, data_out, data_in, data_out);

        // Test 6: Maximum shift (DATA_WIDTH-1) = 31
        data_in = 32'b00000000000000000000000000000001; shift_amount = 31; #10;
        $display("%b | %2d    | %b | %10d | %10d", data_in, shift_amount, data_out, data_in, data_out);

        $display("=====================================");
    end

    initial begin
        $dumpfile("shl_tb.vcd");
        $dumpvars(0, shl_tb);
    end

    initial begin
        #75;
        $display("Simulation complete.");
        #10;
        $finish;
    end
endmodule
