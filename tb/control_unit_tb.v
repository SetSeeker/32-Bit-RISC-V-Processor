`timescale 1ns/10ps
module control_unit_tb;

reg Clock;
reg Clear, stop;
wire [31:0] output_port_unit, MuxOut;
reg [31:0] input_port_unit;

DataPath DUT(
	.Clock(Clock),
    .stop(stop),
	.Clear(Clear),
	.input_port_unit(input_port_unit)
);

initial begin
   stop = 0;
  Clear = 1;      // Assert reset at time 0
  #20 Clear = 0;  // Deassert reset after 20 ns
end

initial begin
  Clock = 0;
  input_port_unit <= 32'hC0;
  forever #10 Clock = ~Clock;
end

    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars;
    end

    initial begin
        #127500;  
        $display("Simulation complete.");
        $finish;
    end
endmodule