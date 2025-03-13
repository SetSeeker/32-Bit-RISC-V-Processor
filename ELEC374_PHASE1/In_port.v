module In_port #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input clear, clock,
	input [DATA_WIDTH-1:0] data_in,
	output wire [DATA_WIDTH-1:0] data_out
);

reg [DATA_WIDTH-1:0] q;

initial begin
q = INIT; // default value init
end

always @ (posedge clock)
		begin 
			if (clear) begin
				q <= {DATA_WIDTH{1'b0}}; // clear
			end
			else
				q <= data_in;	// load data (If not clear isn't active)
		end
    assign data_out = q;

endmodule
