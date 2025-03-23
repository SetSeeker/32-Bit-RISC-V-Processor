`timescale 1ns/10ps
module non_restore_div #(parameter DATA_WIDTH = 32)(
    input  [DATA_WIDTH-1:0] a,
    input  [DATA_WIDTH-1:0] b,
    output reg [(DATA_WIDTH*2)-1:0] data_out
);

    integer i;
    reg [DATA_WIDTH-1:0] quotient;
    reg [DATA_WIDTH-1:0] remainder;
    reg [DATA_WIDTH-1:0] divisor;
    reg [DATA_WIDTH*2-1:0] dividend;
    reg dividend_sign;
    reg divisor_sign;

    always @(*) begin
        dividend_sign = a[DATA_WIDTH-1];
        divisor_sign  = b[DATA_WIDTH-1];

        if (dividend_sign)
            dividend = ~a + 1;
        else
            dividend = a;
        if (divisor_sign)
            divisor = ~b + 1;
        else
            divisor = b;
        
        dividend = {dividend, {(DATA_WIDTH){1'b0}}};

        quotient  = 0;
        remainder = 0;

        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            remainder = {remainder[DATA_WIDTH-2:0], dividend[DATA_WIDTH*2-1]};
            dividend = dividend << 1;

            if (remainder[DATA_WIDTH-1] == 0)
                remainder = remainder - divisor;
            else
                remainder = remainder + divisor;

            if (remainder[DATA_WIDTH-1] == 0)
                quotient = quotient | (1 << (DATA_WIDTH-1-i));
        end

        if (remainder[DATA_WIDTH-1] == 1)
            remainder = remainder + divisor;

        if (dividend_sign ^ divisor_sign)
            quotient = ~quotient + 1;
        
        if (dividend_sign)
            remainder = ~remainder + 1;

        data_out = {remainder, quotient};
    end

endmodule
