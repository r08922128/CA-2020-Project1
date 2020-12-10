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
input RegWrite_i, //WB 
      MemtoReg_i, 
      MemRead_i,
      MemWrite_i, 
      RegDst_i, //EX
      //ALUOp
      ALUSrc_i;
input [1:0] ALUOp_i;
input [4:0] RSaddr_i,
	    RTaddr_i, 
	    RDaddr_i;
input [31:0] addr_i, 
	     Sign_Extend_i,
	     RSdata_i, 
	     RTdata_i;
output RegWrite_o, //WB 
       MemtoReg_o, 
       MemRead_o,
       MemWrite_o, 
       RegDst_o, //EX
       //ALUOp
       ALUSrc_o;

output [1:0] ALUOp_o;
output [4:0] RSaddr_o,
	     RTaddr_o, 
	     RDaddr_o;
output [31:0] addr_o, 
	      Sign_Extend_o, 
	      RSdata_o, 
	      RTdata_o;
reg RegWrite_o, //  output
    MemtoReg_o, 
    MemRead_o, 
    MemWrite_o, 
    RegDst_o, 
    ALUSrc_o; 
reg [1:0] ALUOp_o; // output 2
reg [4:0] RSaddr_o,
	  RTaddr_o, //output 5
	  RDaddr_o; 
reg [31:0]  addr_o, //output 32
	    Sign_Extend_o, 
	    RSdata_o, 
	    RTdata_o;


always @ ( posedge clk_i or negedge start_i) begin
    if (~start_i) begin
	RegWrite_o <= 0;
	MemtoReg_o <= 0;
	MemRead_o <= 0;
	MemWrite_o <= 0;
	RegDst_o <= 0;
	ALUSrc_o <= 0;
	ALUOp_o <= 0;
	RSaddr_o <= 0;
	RTaddr_o <= 0;
	RDaddr_o <= 0;
	addr_o <= 0;
	Sign_Extend_o <= 0;
	RSdata_o <= 0;
	RTdata_o <= 0;
    end
    else begin
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	MemRead_o <= MemRead_i;
	MemWrite_o <= MemWrite_i;
	RegDst_o <= RegDst_i;
	ALUSrc_o <= ALUSrc_i;
	ALUOp_o <= ALUOp_i;
	RSaddr_o <= RSaddr_i;
	RTaddr_o <= RTaddr_i;
	RDaddr_o <= RDaddr_i;
	addr_o <= addr_i;
	Sign_Extend_o <= Sign_Extend_i;
	RSdata_o <= RSdata_i;
	RTdata_o <= RTdata_i;
    end
end
endmodule