module PC #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input clear, clock, enable, PC_tb_enable,
	input [DATA_WIDTH-1:0] data_in,
    input [DATA_WIDTH-1:0] PC_tb_value,
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
			else if (enable) begin
				q <= data_in;	// load data
			end
		end
    assign data_out = (PC_tb_enable) ? PC_tb_value : q;

endmodule
