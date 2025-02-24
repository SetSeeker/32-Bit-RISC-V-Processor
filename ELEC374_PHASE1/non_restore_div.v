module non_restore_div #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] a,  // dividend
    input [DATA_WIDTH-1:0] b,  // divisor
    output reg [(DATA_WIDTH*2)-1:0] data_out // Quotient and remainder concatenated
);

    integer i;
    reg [DATA_WIDTH-1:0] quotient;
    reg [DATA_WIDTH-1:0] remainder;
    reg [DATA_WIDTH-1:0] divisor;
    reg [DATA_WIDTH*2-1:0] dividend;
    reg dividend_sign;
    reg divisor_sign;

    // Detect the sign of the dividend and divisor
    always @(*) begin
        dividend_sign = a[DATA_WIDTH-1];  // MSB of the dividend
        divisor_sign = b[DATA_WIDTH-1];   // MSB of the divisor

        // Take the absolute value of dividend and divisor (unsigned equivalent)
        dividend = (dividend_sign) ? (~a + 1) : a;
        divisor = (divisor_sign) ? (~b + 1) : b;
        
        quotient = 0;
        remainder = 0;

        // Initialize the dividend to be shifted
        dividend = dividend << DATA_WIDTH;

        // Division process
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            remainder = {remainder[DATA_WIDTH-2:0], dividend[DATA_WIDTH*2-1]};
            dividend = dividend << 1;

            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient = quotient | (1 << (DATA_WIDTH-1-i));
            end
        end
        
        // Adjust the sign of the quotient if the signs of dividend and divisor differ
        if (dividend_sign ^ divisor_sign) begin
            quotient = ~quotient + 1;  // Negate the quotient if signs differ
        end

        // If the dividend was negative, adjust the remainder sign accordingly
        if (dividend_sign) begin
            remainder = ~remainder + 1;  // Negate remainder if dividend was negative
        end

        // Concatenate the quotient and remainder
        data_out = {quotient, remainder};
    end

    endmodule