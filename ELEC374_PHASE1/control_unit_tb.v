`timescale 1ns/10ps
module control_unit_tb;

reg Clock;
reg Clear, stop;
wire [31:0] input_port_unit, out_port_data_out, MuxOut;

DataPath DUT(
	.Clock(Clock),
    .stop(stop),
	.Clear(Clear),
	.input_port_unit(input_port_unit)
	//.out_port_data_out(out_port_data_out),
);

initial begin
   stop = 0;
  Clear = 1;      // Assert reset at time 0
  #20 Clear = 0;  // Deassert reset after 20 ns
end

initial begin
  Clock = 0;
  forever #10 Clock = ~Clock;  // 10 ns period (5 ns high, 5 ns low)
end

	// Waveform dump for simulation viewing (e.g., GTKWave)
    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars;
    end

    // End simulation after sufficient time.
    initial begin
        #12000;  
        $display("Simulation complete.");
        $finish;
    end
endmodule