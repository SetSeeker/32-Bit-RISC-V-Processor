module booth_multiplier #(parameter DATA_WIDTH = 32) (
    input [DATA_WIDTH-1:0] a, // Multiplicand
    input [DATA_WIDTH-1:0] b,   // Multiplier
    output [2*DATA_WIDTH-1:0] data_out    //product
);
    reg [DATA_WIDTH-1:0] A, Q;      // Accumulator and Multiplier
    reg [DATA_WIDTH-1:0] M;         // Multiplicand
    reg Q_1;                        // Previous Q bit
    
    always @(*) begin
        A = 0;
        Q = b;
        M = a;
        Q_1 = 0;
    end

    // Excute Booth's algorithm logic
    always @(*) begin
        case ({Q[0], Q_1})  // Booth’s recoding based on current bit pair
            2'b00: begin
                // No operation, just shift
                A = A << 1;
                Q = {A[31], Q[31:1]};
                Q_1 = Q[0];
            end
            2'b01: begin
                // Add multiplicand
                A = (A + M) << 1;
                Q = {A[31], Q[31:1]};
                Q_1 = Q[0];
            end
            2'b10: begin
                // Subtract multiplicand
                A = (A - M) << 1;
                Q = {A[31], Q[31:1]};
                Q_1 = Q[0];
            end
            2'b11: begin
                // No operation, just shift
                A = A << 1;
                Q = {A[31], Q[31:1]};
                Q_1 = Q[0];
            end
        endcase
    end

    // Concatenate A and Q to form the final product
    assign data_out = {A, Q};

endmodule
