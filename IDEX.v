module IDEX 
(
    clk_i, 
    start_i,
    RegWrite_i,
    MemtoReg_i, 
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i, 
    RS2data_i,
    ImmGen_i,
    funct_7_3_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o, 
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    ImmGen_o,
    funct_7_3_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o,
);

input clk_i, start_i;
input RegWrite_i,
      MemtoReg_i, 
      MemRead_i,
      MemWrite_i, 
      ALUSrc_i;
input [1:0] ALUOp_i;
input [31:0] RS1data_i,
             RS2data_i,
             ImmGen_i;
input [9:0] funct_7_3_i;
input [4:0] RS1addr_i,
            RS2addr_i,
            RDaddr_i;

output RegWrite_o,
       MemtoReg_o, 
       MemRead_o,
       MemWrite_o, 
       ALUSrc_o;
output [1:0] ALUOp_o;
output [31:0] RS1data_o,
             RS2data_o,
             ImmGen_o;
output [9:0] funct_7_3_o;
output [4:0] RS1addr_o,
            RS2addr_o,
            RDaddr_o;

reg         RegWrite_o,
            MemtoReg_o, 
            MemRead_o,
            MemWrite_o, 
            ALUSrc_o;
reg [1:0]   ALUOp_o;
reg [31:0]  RS1data_o,
            RS2data_o,
            ImmGen_o;
reg [9:0]   funct_7_3_o;
reg [4:0]   RS1addr_o,
            RS2addr_o,
            RDaddr_o;


always @ ( posedge clk_i or negedge start_i) begin
    if (~start_i) begin
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUSrc_o <= 0;
        ALUOp_o <= 0;
        RS1data_o <= 0;
        RS2data_o <= 0;
        ImmGen_o <= 0;
        funct_7_3_o <= 0;
        RS1addr_o <= 0;
        RS2addr_o <= 0;
        RDaddr_o <= 0;
    end
    else begin
    if (~start_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUSrc_o <= ALUSrc_i;
        ALUOp_o <= ALUOp_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        ImmGen_o <= ImmGen_i;
        funct_7_3_o <= funct_7_3_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        RDaddr_o <= RDaddr_i;
    end
end
endmodule