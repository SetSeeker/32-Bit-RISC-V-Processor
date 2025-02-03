module ror #(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [DATA_WIDTH-1:0] rotate_amount,
    output wire [DATA_WIDTH-1:0] data_out
);

    assign data_out = (data_in >> rotate_amount) | (data_in << (DATA_WIDTH-rotate_amount));

endmodule