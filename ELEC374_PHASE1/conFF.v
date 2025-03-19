`timescale 1ns/10ps

module conFF #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] IR,
    input [DATA_WIDTH-1:0] BusMuxOut,
    input CONin,
    output reg CON
    );

reg [3:0] Ra;
reg [3:0] C2;
reg brzr, brnz, brpl, brmi;
reg BusOR;
reg sigDig;
integer i;
reg D;
reg CONout = 0;

always @ (IR, BusMuxOut) begin    
    Ra = IR[26:23];
    C2 = IR[22:19]; // C2 is a 4-bit but last 2 bits are most important
    brzr = 0;
    brnz = 0;
    brpl = 0;
    brmi = 0;
    BusOR = 0;
    
    //Decode IR
    case (C2)
        4'b0000: brzr = 1;
        4'b0001: brnz = 1;
        4'b0010: brpl = 1;
        4'b0011: brmi = 1;
    endcase
    
    //Determine input signals
    sigDig = BusMuxOut[DATA_WIDTH-1];
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin
        BusOR = BusOR | BusMuxOut[i];
    end
    
    // CONN FF Logic
    D = (brzr & ~BusOR) | (brnz & BusOR) | (brpl & ~sigDig) | (brmi & sigDig);
end

always @ (posedge CONin) begin
    #2 //System delay (bus prop delay)
    CONout = D;
    CON = CONout;
end

endmodule