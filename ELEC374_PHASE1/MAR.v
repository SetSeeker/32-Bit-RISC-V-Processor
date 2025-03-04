module MAR #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input clear, clock, enable, 
	input [DATA_WIDTH-1:0] data_in,
	output wire [DATA_WIDTH/4:0] data_out
);

reg [DATA_WIDTH-1:0] q;
initial q = INIT; // default value init

always @ (posedge clock)
		begin 
			if (clear) begin
				q <= {DATA_WIDTH{1'b0}}; // clear
			end
			else if (enable) begin
				q <= data_in;	// load data
			end
		end
	assign	data_out = q[DATA_WIDTH/4:0];
endmodule
