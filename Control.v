module Control
(
    Op_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,
	ALUSrc_o,
    Branch_o,
);

input [6:0] Op_i;
output [1:0] ALUOp_o;
output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
reg [1:0] ALUOp_o;

always@(Op_i)begin
    case(Op_i)
        7'b0110011:begin //R-type
            RegWrite_o <= 1'b1;
            MemtoReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b0;
            ALUOp_o <= 2'b10;
            ALUSrc_o <= 1'b0;
            Branch_o <= 1'b0;    
        end
        7'b0010011:begin //addi,srai
            RegWrite_o <= 1'b1;
            MemtoReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b0;
            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1'b1;   
            Branch_o <= 1'b0;       
        end
        7'b0000011:begin //lw
            RegWrite_o <= 1'b1;
            MemtoReg_o <= 1'b1;
            MemRead_o <= 1'b1;
            MemWrite_o <= 1'b0;
            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1'b1;   
            Branch_o <= 1'b0;       
        end
        7'b0100011:begin //sw
            RegWrite_o <= 1'b0;
            MemtoReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b1;
            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1'b1;   
            Branch_o <= 1'b0;       
        end
        7'b1100011:begin //beq
            RegWrite_o <= 1'b0;
            MemtoReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b0;
            ALUOp_o <= 2'b01;
            ALUSrc_o <= 1'b0;  
            Branch_o <= 1'b1;        
        end
end

endmodule

