module register #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input clear, clock, enable, 
	input [DATA_WIDTH-1:0] data_in,
	output reg [DATA_WIDTH-1:0] data_out
);

initial data_out = INIT; // default value init

always @ (posedge clock)
		begin 
			if (clear) begin
				data_out <= {DATA_WIDTH{1'b0}}; // clear
			end
			else if (enable) begin
				data_out <= data_in;	// load data
			end
		end
		
endmodule
