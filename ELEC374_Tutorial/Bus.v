module Bus (
    input [7:0] BusMuxInRZ, 
    input [7:0] BusMuxInRA, 
    input [7:0] BusMuxInRB,
    input RZout, RAout, RBout,
    output wire [7:0] BusMuxOut
);

    reg [7:0] q;

    always @ (*) begin
        if(RZout) q = BusMuxInRZ;
        else if(RAout) q = BusMuxInRA;
        else if(RBout) q = BusMuxInRB;
    end

    assign BusMuxOut = q;
endmodule