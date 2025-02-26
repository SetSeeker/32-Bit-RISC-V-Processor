module boothMul #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] a,  // Multiplier
    input [DATA_WIDTH-1:0] b,  // Multiplicand
    output reg [(DATA_WIDTH*2)-1:0] data_out // Product
);

    // Internal signals declared at the module level
    reg [DATA_WIDTH-1:0] a_twos, b_twos;      // 2's complement of 'a' and 'b'
    reg [(DATA_WIDTH*2)-1:0] unsigned_result; // Unsigned result of Booth's algorithm
    reg [(DATA_WIDTH*2):0] A;                 // Accumulator
    reg [DATA_WIDTH-1:0] Q;                   // Multiplicand
    reg Q_1;                                  // Q-1 for Booth's algorithm
    reg [(DATA_WIDTH):0] M;                   // Multiplier
    reg result_sign;                          // Final sign of the result
    reg a_is_negative, b_is_negative;         // Sign flags
    integer i;                                

    always @(*) begin
        // MSB - Most Sig Bit
        a_is_negative = a[DATA_WIDTH-1]; // MSB of 'a' indicates its sign
        b_is_negative = b[DATA_WIDTH-1]; // MSB of 'b' indicates its sign

        // Convert to 2's complement if negative
        if (a_is_negative)
            a_twos = ~a + 1;
        else
            a_twos = a;

        // Convert to 2's complement if negative
        if (b_is_negative)
            b_twos = ~b + 1;
        else
            b_twos = b;

        // Initialize Booth's algorithm key variables
        A = 0;
        Q = b_twos;
        Q_1 = 0;    // Determines the operation to be performed for multiplier
        M = a_twos;

        // Booth's algorithm
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: A = A + M;                     // Add M (+1)
                2'b10: A = A - M;                     // Subtract M (-1)
                default: A = A;                       // Do nothing (0)
            endcase

            // Arithmetic right shift (A and Q)
            Q_1 = Q[0];
            Q = {A[0], Q[DATA_WIDTH-1:1]}; // Shift Q
            A = {A[DATA_WIDTH], A[(DATA_WIDTH*2):1]}; // Shift A with sign extension
        end

        // Concatenate A and Q to form the unsigned product
        unsigned_result = {A[(DATA_WIDTH*2)-1:0], Q};

        // Determine final sign of the result (XOR)
        result_sign = a_is_negative ^ b_is_negative;

        // Adjust the result based on its sign
        if (result_sign)
            data_out = ~unsigned_result + 1;
        else
            data_out = unsigned_result;
    end
endmodule