module PC #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
	input clear, clock, enable, 
	input [DATA_WIDTH-1:0] data_in,
    input [DATA_WIDTH-1:0] PC_tb_value,
	output wire [DATA_WIDTH-1:0] data_out
);

reg [DATA_WIDTH-1:0] q;
reg [DATA_WIDTH-1:0] tb_int;
reg [DATA_WIDTH-1:0] first_iteration_done;

initial begin
q = INIT; // default value init
tb_int = INIT;
first_iteration_done = INIT;
end


    always @(posedge clock) begin
        if (first_iteration_done == 32'h0) begin
            tb_int <= 32'h1; // set NEW_VALUE as needed after the first iteration
            first_iteration_done <= 0;
        end else begin
            tb_int <= 32'h0;
        end
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
    assign data_out = (tb_int == 32'h1) ? PC_tb_value : q;

endmodule
