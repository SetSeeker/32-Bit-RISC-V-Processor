module Select_Encode #(parameter DATA_WIDTH = 32)(
    input  wire [DATA_WIDTH-1:0] IR,
    input  wire Gra, Grb, Grc,
    input  wire Rin, Rout, BAout, Cout,
    output reg [15:0] Rin_out, Rout_out,
    output reg [DATA_WIDTH-1:0] C_sign_extended
);

    reg [3:0] reg_to_enable;

    always @(*) begin
        Rin_out = 16'd0;
        Rout_out = 16'd0;
        reg_to_enable = 4'd0;
        C_sign_extended = 32'd0;

        case(IR[31:27])
            5'b00000, 5'b00001, 5'b00010: begin
                if (Gra) reg_to_enable = IR[26:23];
                if (Grb) reg_to_enable = IR[22:19];
                if (Cout) C_sign_extended = {{13{IR[18]}}, IR[18:0]};
                if (Rin)  Rin_out = (1 << reg_to_enable);
                if (BAout) begin
                    if (IR[22:19] == 4'd0)
                       Rout_out = 16'd1; 
                    else
                        Rout_out = (1 << IR[22:19]);
                end else if (Rout) begin
                        Rout_out = (1 << reg_to_enable);
                end
            end

            5'b00011, 5'b00100, 5'b00101, 5'b00110, 5'b00111,
            5'b01000, 5'b01001, 5'b01010, 5'b01011: begin // add, sub, and, or, ror, rol, shr, shra, shl
                if (Gra) reg_to_enable = IR[26:23];
                if (Grb) reg_to_enable = IR[22:19];
                if (Grc) reg_to_enable = IR[18:15];

                if (Rin)  Rin_out = (1 << reg_to_enable); 
                if (Rout) Rout_out = (1 << reg_to_enable);
            end

            5'b01100, 5'b01101, 5'b01110: begin // addi, andi, ori
                if (Gra) reg_to_enable = IR[26:23];
                if (Grb) reg_to_enable = IR[22:19];
                if (Cout) C_sign_extended = {{13{IR[18]}}, IR[18:0]};

                if (Rin)  Rin_out = (1 << reg_to_enable); 
                if (Rout) Rout_out = (1 << reg_to_enable);
            end

            5'b01111, 5'b10000, 5'b10001, 5'b10010: begin // div, mul, neg, not
                if (Gra) reg_to_enable = IR[26:23];
                if (Grb) reg_to_enable = IR[22:19];

                if (Rin)  Rin_out = (1 << reg_to_enable); 
                if (Rout) Rout_out = (1 << reg_to_enable);
            end

            5'b10011: begin // brzr, brnz, brmi, brpl
                if (Gra) reg_to_enable = IR[26:23];

                if (Rin)  Rin_out = (1 << reg_to_enable); 
                if (Rout) Rout_out = (1 << reg_to_enable);
            end

            5'b10100, 5'b10101: begin // jal, jr
                if (Gra) reg_to_enable = IR[26:23];

                if (Rin)  Rin_out = (1 << reg_to_enable); 
                if (Rout) Rout_out = (1 << reg_to_enable);
            end

            5'b10110, 5'b10111, 5'b11000, 5'b11001: begin // in, out, mflo, mfhi
                if (Gra) reg_to_enable = IR[26:23];

                if (Rin)  Rin_out = (1 << reg_to_enable); 
                if (Rout) Rout_out = (1 << reg_to_enable);
            end

            default: reg_to_enable = 4'b0000;
        endcase
    end
endmodule