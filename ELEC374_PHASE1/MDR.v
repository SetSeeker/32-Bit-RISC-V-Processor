module MDR #(parameter DATA_WIDTH = 32) (
	input[DATA_WIDTH-1:0] BusMuxOut, Mdatain,
	input Clock, Clear, MDRin, Read,
	output reg[DATA_WIDTH-1:0] BusMuxIn_MDR
);

	reg[DATA_WIDTH-1:0] MDMuxout;

	initial begin
    BusMuxIn_MDR = 32'b0;
	end

	// MDMux
	always @(*) begin
		case(Read)
			1'd0: MDMuxout = BusMuxOut; // 0
			1'd1: MDMuxout = Mdatain; // 1
		endcase
	end

	//MDR
	always @ (posedge Clock)
		begin 
			if (Clear) begin
				BusMuxIn_MDR <= 32'b0; // clear
			end
			else if (MDRin) begin
				BusMuxIn_MDR <= MDMuxout;	// load data
			end
	end
endmodule