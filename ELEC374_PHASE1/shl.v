module shl #(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [DATA_WIDTH/8:0] shift_amount,
    output wire [DATA_WIDTH-1:0] data_out
);

    assign data_out = data_in << shift_amount; // Perform logical shift left

endmodule