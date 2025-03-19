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
        $readmemh("mem_conFF.hex", memory);
    end

    always @(*) begin
        if (write) begin
            memory[address] <= data_in;
            $display("Write: Address=%h, Data In=%h, Memory at Address=%h", address, data_in, memory[address]);
        end 
        else if (read) begin
            data_out <= memory[address];
        end
    end
endmodule