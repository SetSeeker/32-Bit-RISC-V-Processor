module RAM #(parameter DATA_WIDTH = 32)(
    input read,
    input write,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    input [DATA_WIDTH/4:0] address
);

    parameter size = 2**(9);
    reg [DATA_WIDTH-1:0] memory [0:size-1];

    initial begin
        data_out = 32'b0;
        $readmemh("mem_init.hex", memory);
    end

    always @(*) begin
        if (write) begin
            memory[address] <= data_in;
        end 
        else if (read) begin
            data_out <= memory[address];
        end
    end
endmodule