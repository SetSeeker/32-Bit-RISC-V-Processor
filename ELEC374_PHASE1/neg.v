module neg #(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out
);

    assign data_out = -data_in;

endmodule