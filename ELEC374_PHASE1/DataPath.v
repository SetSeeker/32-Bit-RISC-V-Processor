module DataPath #(parameter DATA_WIDTH = 32)(
	input clock, clear,
	input RAout, RBout,
	input RZin, R4in,
	input [4:0] sel,
	input [3:0] control,
	output [DATA_WIDTH-1:0] bus_out
);

wire [DATA_WIDTH-1:0] R3, R4, R7, alu_result;
wire [DATA_WIDTH-1:0] Zregin;

//Devices
register #(DATA_WIDTH) reg3 (
	.clock(clock),
	.clear(clear),
	.enable(1'b0),
	.data_in(bus_out),
	.data_out(R3)
);

register #(DATA_WIDTH) reg4 (
	.clock(clock),
	.clear(clear),
	.enable(R4in),
	.data_in(alu_result),
	.data_out(R4)
);

register #(DATA_WIDTH) reg7 (
	.clock(clock),
	.clear(clear),
	.enable(1'b0),
	.data_in(bus_out),
	.data_out(R7)
);

// ALU
ALU #(DATA_WIDTH) add (
	.a(R3),
	.b(R7),
	.control(4'd0),
	.result(alu_result)
);

//Bus
Bus #(DATA_WIDTH) bus(
	.R3(R3),
	.R4(R4),
	.R5(R7),
	.sel(sel), // control logic of the multiplexer
	.bus_out(bus_out)
);

endmodule
