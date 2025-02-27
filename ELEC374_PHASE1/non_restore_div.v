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
    reg dividend_sign;  // Sign of the dividend
    reg divisor_sign;   // Sign of the divisor

    // Detect the sign of the dividend and divisor
    always @(*) begin
        // MSB - Most sig bit
        dividend_sign = a[DATA_WIDTH-1];  // MSB of the dividend
        divisor_sign = b[DATA_WIDTH-1];   // MSB of the divisor

        // Convert to 2's complement if negative
        if (dividend_sign)
            dividend = ~a + 1;
        else
            dividend = a;

        // Convert to 2's complement if negative
        if (divisor_sign)
            divisor = ~b + 1;
        else
            divisor = b;

        // Initialize the dividend to be shifted
        dividend = {dividend, {(DATA_WIDTH){1'b0}}};

        quotient = 0;
        remainder = 0;

        dividend = {dividend, {(DATA_WIDTH){1'b0}}};

        // Non-Restoring Division Algorithm
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            // Shift A and Q left one binary position
            remainder = {remainder[DATA_WIDTH-2:0], dividend[DATA_WIDTH*2-1]};  // Shift remainder
            dividend = dividend << 1;  // Shift dividend

            // If A ≥ 0, subtract M from A; otherwise, add M to A.
            if (remainder[DATA_WIDTH-1] == 0)
                remainder = remainder - divisor;
            else
                remainder = remainder + divisor;  // Add divisor to remainder

            // If A ≥ 0, set q0 to 1; otherwise, set q0 to 0.
            if (remainder[DATA_WIDTH-1] == 0)
                quotient = quotient | (1 << (DATA_WIDTH-1-i));  // Set the corresponding bit in quotient to 1
            
        end
        
        // Step 2: If A < 0, add M to A to make positive remainder
        if (remainder[DATA_WIDTH-1] == 1)
            remainder = remainder + divisor;

        // Adjust the sign of the quotient if the signs of dividend and divisor differ
        if (dividend_sign ^ divisor_sign)
            quotient = ~quotient + 1;
        
        // If the dividend was negative, adjust the remainder sign accordingly
        if (dividend_sign)
            remainder = ~remainder + 1;

        // Concatenate the quotient and remainder
        data_out = {quotient, remainder};
    end

endmodule