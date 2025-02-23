module non_restoring_div #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] a,  // a (signed)
    input [DATA_WIDTH-1:0] b,   // b (signed)
    input clk,
    input rst,
    input start,
    output reg [DATA_WIDTH-1:0] quotient,  // Quotient (signed)
    output reg [DATA_WIDTH-1:0] remainder, // Remainder (signed)
    output reg done
    output reg [(DATA_WIDTH*2)-1:0] data_out
);

    // Internal signals
    reg [DATA_WIDTH-1:0] a_twos, b_twos; // 2's complement representation
    reg [DATA_WIDTH:0] A, M;                          // Accumulator and b (with sign bit)
    reg [DATA_WIDTH-1:0] Q;                           // a
    reg result_sign;                                  // Final sign of the result
    reg a_is_negative, b_is_negative;    // Sign flags
    reg [5:0] count;                                  // Loop counter
    reg state;

    parameter IDLE = 1'b0, EXECUTE = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            M <= 0;
            Q <= 0;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Determine sign of inputs (MSB check)
                        a_is_negative = a[DATA_WIDTH-1]; 
                        b_is_negative = b[DATA_WIDTH-1]; 

                        // Convert to 2's complement if negative
                        if (a_is_negative)
                            a_twos = ~a + 1; 
                        else
                            a_twos = a;

                        if (b_is_negative)
                            b_twos = ~b + 1; 
                        else
                            b_twos = b;

                        // Initialize non-restoring division algorithm
                        A <= 0;
                        M <= {b_twos[DATA_WIDTH-1], b_twos}; // Sign-extend b
                        Q <= a_twos;
                        count <= DATA_WIDTH;
                        done <= 0;
                        state <= EXECUTE;
                    end
                end
                EXECUTE: begin
                    if (count > 0) begin
                        // Shift left
                        A <= {A[DATA_WIDTH-1:0], Q[DATA_WIDTH-1]};
                        Q <= {Q[DATA_WIDTH-2:0], 1'b0};

                        // Conditional add or subtract
                        if (A[DATA_WIDTH] == 1'b0) begin
                            A <= A - M;
                        end else begin
                            A <= A + M;
                        end

                        // Update Q based on the result of addition/subtraction
                        if (A[DATA_WIDTH] == 1'b0) begin
                            Q[0] <= 1'b1;
                        end else begin
                            Q[0] <= 1'b0;
                        end

                        count <= count - 1;
                    end else begin
                        // Final correction if necessary
                        if (A[DATA_WIDTH] == 1'b1) begin
                            A <= A + M;
                        end
                        quotient <= Q;
                        remainder <= A[DATA_WIDTH-1:0];
                        done <= 1'b1;
                        state <= IDLE;
                        data_out <= {quotient, remainder};
                    end
                end
            endcase
        end
    end

endmodule