module boothMul #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] a,  // Multiplier (signed)
    input [DATA_WIDTH-1:0] b,  // Multiplicand (signed)
    output reg [(DATA_WIDTH*2)-1:0] data_out // Product
);

    // Internal signals declared at the module level
    reg [DATA_WIDTH-1:0] a_twos, b_twos;      // 2's complement representation
    reg [(DATA_WIDTH*2)-1:0] unsigned_result; // Unsigned result of Booth's algorithm
    reg [(DATA_WIDTH*2):0] A;                 // Accumulator (with sign bit)
    reg [DATA_WIDTH-1:0] Q;                   // Multiplicand
    reg Q_1;                                  // Q-1 for Booth's algorithm
    reg [(DATA_WIDTH):0] M;                   // Sign-extended multiplier
    reg result_sign;                          // Final sign of the result
    reg a_is_negative, b_is_negative;         // Sign flags
    integer i;                                // Loop counter

    always @(*) begin
        // Determine sign of inputs (MSB check)
        a_is_negative = a[DATA_WIDTH-1]; // MSB of 'a' indicates its sign
        b_is_negative = b[DATA_WIDTH-1]; // MSB of 'b' indicates its sign

        // Convert to 2's complement if negative
        if (a_is_negative)
            a_twos = ~a + 1; // 2's complement of 'a'
        else
            a_twos = a;

        if (b_is_negative)
            b_twos = ~b + 1; // 2's complement of 'b'
        else
            b_twos = b;

        // Initialize Booth's algorithm
        A = 0;
        Q = b_twos;
        Q_1 = 0;
        M = {a_twos[DATA_WIDTH-1], a_twos}; // Sign-extend 'a'

        // Perform Booth's algorithm
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: A = A + M;                     // Add M
                2'b10: A = A - M;                     // Subtract M
                default: A = A;                       // Do nothing
            endcase

            // Arithmetic right shift (A and Q)
            Q_1 = Q[0];
            Q = {A[0], Q[DATA_WIDTH-1:1]}; // Shift Q
            A = {A[DATA_WIDTH], A[(DATA_WIDTH*2):1]}; // Shift A with sign extension
        end

        // Concatenate A and Q to form the unsigned product
        unsigned_result = {A[(DATA_WIDTH*2)-1:0], Q};

        // Determine final sign of the result
        result_sign = a_is_negative ^ b_is_negative; // XOR the signs

        // Adjust the result based on its sign
        if (result_sign)
            data_out = ~unsigned_result + 1; // Convert to negative
        else
            data_out = unsigned_result;      // Keep as positive
    end
endmodule