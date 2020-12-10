module Sign_Extend(
    clk_i,
    data_i,
    data_o
);

input           clk_i;
input [31:0]    data_i;
output [31:0]   data_o;

reg [31:0] data_o;
wire [6:0] opcode;

assign opcode=data_i[6:0];

always@(posedge clk_i) begin
    if(opcode==7'b0100011)begin//sw
        data_o={{20{data_i[31]}},data_i[31:25],data_i[11:7]};
    end
    else if (opcode==7'b1100011) begin//beq
        data_o={{19{data_i[31]}},data_i[31],data_i[7],data_i[30:25],data_i[11:8],0};
    end
    else begin//addi,srai,lw
        data_o={{20{data_i[31]}},data_i[31:20]};
    end
end

//assign data_o={{20{data_i[11]}},data_i};

endmodule