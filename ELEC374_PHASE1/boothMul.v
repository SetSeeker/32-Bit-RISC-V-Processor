module boothMul #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] a,      // Multiplier (2's complement)
    input [DATA_WIDTH-1:0] b,      // Multiplicand (2's complement)
    output reg [(DATA_WIDTH*2)-1:0] data_out  // Product
);

    // Internal signals for Booth's algorithm
    reg [DATA_WIDTH-1:0] A, Q, M, Q_1;  // A, Q, M, Q-1
    reg [DATA_WIDTH-1:0] negative_M;     // Negative of M
    integer i;

    // Initialize values for Booth's algorithm
    always @(*) begin
        // Booth's algorithm initialization
        A = 0;                    // A is initialized to 0
        Q = b;                    // Q is initialized to multiplicand
        Q_1 = 0;                  // Q-1 is initialized to 0
        M = a;                    // M is initialized to multiplier
        negative_M = -a;         // Negative of M for subtraction

        // Perform Booth's algorithm
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: begin  // Add M to A
                    A = A + M;
                end
                2'b10: begin  // Subtract M from A
                    A = A + negative_M;
                end
                2'b00, 2'b11: begin
                    // Do nothing
                end
            endcase

            // Arithmetic right shift (Q, A, Q-1)
            Q_1 = Q[0];
            Q = {A[0], Q[DATA_WIDTH-1:1]};  // Right shift Q
            A = {A[DATA_WIDTH-1], A[DATA_WIDTH-1:1]}; // Arithmetic right shift A
        end

        // Concatenate A and Q to form the product
        data_out = {A, Q};
    end
endmodule
