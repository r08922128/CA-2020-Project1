module MUX32_4Input(
    data1_i,
    data2_i,
    data3_i,
    select_i,
    data_o
);

input [31:0] data1_i;
input [31:0] data2_i;
input [31:0] data3_i;
input [1:0] select_i;
output [31:0] data_o;

reg [31:0] data_reg;

assign data_o = data_reg;

// select_i will be 00, 01, 10 depends on Forward A and Forward B

always @(data1_i or data2_i or data3_i or select_i)begin
    case(select_i)
        2'b00: data_reg=data1_1;
        2'b01: data_reg=data1_2;
        2'b10: data_reg=data1_3;
    endcase
end

endmodule