module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input signed [31:0] data1_i,data2_i;
input [3:0] ALUCtrl_i;
output [31:0] data_o;
output Zero_o;

reg [31:0] data_o;

assign Zero_o=(data1_i==data2_i)? 0:1;

always @(data1_i or data2_i or ALUCtrl_i)begin
    case(ALUCtrl_i)
        4'b0000: data_o=data1_i&data2_i;
        4'b0001: data_o=data1_i^data2_i;
        4'b0010: data_o=data1_i<<data2_i;
        4'b0011: data_o=data1_i+data2_i;
        4'b0100: data_o=data1_i-data2_i;
        4'b0101: data_o=data1_i*data2_i;
        4'b0110: data_o=data1_i+data2_i;
        4'b0111: data_o=data1_i>>>data2_i[4:0];
        4'b1000: data_o=data1_i+data2_i;
        4'b1001: data_o=data1_i-data2_i;
    endcase
end

// assign data_o=(ALUCtrl_i==3'b000)? data1_i&data2_i:
//             (ALUCtrl_i==3'b001)? data1_i^data2_i:
//             (ALUCtrl_i==3'b010)? data1_i<<data2_i:
//             (ALUCtrl_i==3'b011)? data1_i+data2_i:
//             (ALUCtrl_i==3'b100)? data1_i-data2_i:
//             (ALUCtrl_i==3'b101)? data1_i*data2_i:
//             (ALUCtrl_i==3'b111)? $signed(data1_i)>>>data2_i[4:0]:
//             data1_i+data2_i;
    
endmodule

