module non_restore_div #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] a,  // dividend
    input [DATA_WIDTH-1:0] b,  // divisor
    output reg [(DATA_WIDTH*2)-1:0] data_out // Quotient and remainder Concatenated
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
        dividend = {dividend, {(DATA_WIDTH){1'b0}}};  // Shifted dividend with zero padding

        // Division process
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            // Shift A and Q left one binary position
            remainder = {remainder[DATA_WIDTH-2:0], dividend[DATA_WIDTH*2-1]};  // Shift remainder
            dividend = dividend << 1;  // Shift dividend

            // If A ≥ 0, subtract M from A; otherwise, add M to A.
            if (remainder[DATA_WIDTH-1] == 0) begin
                remainder = remainder - divisor;  // Subtract divisor from remainder
            end else begin
                remainder = remainder + divisor;  // Add divisor to remainder
            end

            // If A ≥ 0, set q0 to 1; otherwise, set q0 to 0.
            if (remainder[DATA_WIDTH-1] == 0) begin
                quotient = quotient | (1 << (DATA_WIDTH-1-i));  // Set the corresponding bit in quotient to 1
            end
        end
        
        // Step 2: If A < 0, add M to A to make positive remainder
        if (remainder[DATA_WIDTH-1] == 1) begin
            remainder = remainder + divisor;  // Add divisor to remainder
        end

        // Adjust the sign of the quotient if the signs of dividend and divisor differ
        if (dividend_sign ^ divisor_sign) begin
            quotient = ~quotient + 1;  // Negate the quotient if signs differ
        end
        
        
        // might not need
        // If the dividend was negative, adjust the remainder sign accordingly
        if (dividend_sign) begin
            remainder = ~remainder + 1;  // Negate remainder if dividend was negative
        end

        // Concatenate the quotient and remainder
        data_out = {quotient, remainder};
    end

endmodule