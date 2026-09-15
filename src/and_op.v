module and_op #(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] a, b,
    output wire [DATA_WIDTH-1:0] data_out
);

    assign data_out = a & b;

endmodule