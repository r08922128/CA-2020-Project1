module Forward
(
    IDEX_RS1_i,
    IDEX_RS2_i,
    EXMEM_RegWrite_i,
    EXMEM_Rd_i,
    MEMWB_RegWrite_i,
    MEMWB_Rd_i,
    ForwardA_o,
    ForwardB_o,
);

input [4:0] IDEX_RS1_i;
input [4:0] IDEX_RS2_i;
input [4:0] EXMEM_Rd_i;
input [4:0] MEMWB_Rd_i;
input EXMEM_RegWrite_i;
input MEMWB_RegWrite_i;

output [1:0] ForwardA_o;
output [1:0] ForwardB_o;

reg [1:0] ForwardA_reg;
reg [1:0] ForwardB_reg;

assign ForwardA_o = ForwardA_reg;
assign ForwardB_o = ForwardB_reg;

always @(IDEX_RS1_i or IDEX_RS2_i or EXMEM_Rd_i or EXMEM_RegWrite_i or MEMWB_Rd_i or MEMWB_RegWrite_i)begin
    ForwardA_reg <= 2'b00;
    ForwardB_reg <= 2'b00;

    if (EXMEM_RegWrite_i && (EXMEM_Rd_i != 5'b00000) && (EXMEM_Rd_i == IDEX_RS1_i))
        ForwardA_reg <= 2'b10;
    else if(MEMWB_RegWrite_i && (MEMWB_Rd_i != 5'b00000) && !(EXMEM_RegWrite_i && (EXMEM_Rd_i != 5'b00000) && (EXMEM_Rd_i == IDEX_RS1_i) && (MEMWB_Rd_i == IDEX_RS1_i)))
		ForwardA_reg <= 2'b01;

    if (EXMEM_RegWrite_i && (EXMEM_Rd_i != 5'b00000) && (EXMEM_Rd_i == IDEX_RS2_i))
        ForwardB_reg <= 2'b10;
    else if(MEMWB_RegWrite_i && (MEMWB_Rd_i != 5'b00000) && !(EXMEM_RegWrite_i && (EXMEM_Rd_i != 5'b00000) && (EXMEM_Rd_i == IDEX_RS2_i) && (MEMWB_Rd_i == IDEX_RS2_i)))
		ForwardB_reg <= 2'b01;

end


endmodule