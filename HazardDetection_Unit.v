module HazardDetection_Unit(
    IFID_RS1_i,
    IFID_RS2_i,
    IDEX_MemRead_i,
    IDEX_RD_i,
    PCWrite_o,
    Stall_o,
    NoOp_o
);

input IDEX_MemRead_i;
input [4:0] IFID_RS1_i, IFID_RS2_i, IDEX_RD_i;
output PCWrite_o, Stall_o, NoOp_o;
reg PCWrite_o, Stall_o, NoOp_o;

always @(IFID_RS1_i or IFID_RS2_i or IDEX_MemRead_i or IDEX_RD_i) begin
    if (IDEX_MemRead_i && IDEX_RD_i == IFID_RS1_i) begin
        PCWrite_o <= 1'b1;
        Stall_o <= 1'b1;
        NoOp_o <= 1'b1;
    end
    else if (IDEX_MemRead_i && IDEX_RD_i == IFID_RS2_i) begin
        PCWrite_o <= 1'b1;
        Stall_o <= 1'b1;
        NoOp_o <= 1'b1;
    end
    else begin
        PCWrite_o <= 1'b0;
        Stall_o <= 1'b0;
        NoOp_o <= 1'b0;
    end
end

endmodule