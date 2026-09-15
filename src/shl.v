module shl #(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] a,
    input wire [DATA_WIDTH-1:0] b,
    output wire [DATA_WIDTH-1:0] data_out
);

    wire [4:0] count = b[4:0];
    assign data_out = a << count; // Perform logical shift left

endmodule