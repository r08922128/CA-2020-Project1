module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] PC_addr;
wire zero;

MUX32 MUX_PCSrc(
    .data1_i (Add_PC.data_o),
    .data2_i (Add_Branch_addr.data_o),    
    .select_i (),  
    .data_o ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (),
    .pc_i       (Add_PC.data_o),
    .pc_o       (PC_addr_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_addr_o), 
    .instr_o    ()
);

Adder Add_PC(
    .data1_in   (PC_addr_o),
    .data2_in   (32'd4),
    .data_o     ()
);

wire [31:0] IFID_addr_o,IFID_inst_o;

IFID IFID(
    .clk_i 	    (clk_i),
    .start_i 	(start_i),
    .addr_i 	(PC_addr),
    .instr_i 	(Instruction_Memory.instr_o),
    .Flush_i	(branch),
    .Stall_i    (HazardDetection_Unit.Stall_o),
    .addr_o	    (IFID_addr_o),
    .inst_o	    (IFID_inst_o)
);

Adder Add_Branch_addr(
    .data1_in   (Sign_Extend.data_o << 1), 
    .data2_in   (IFID_addr_o),
    .data_o     ()
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (IFID_inst_o[19:15]),
    .RS2addr_i      (IFID_inst_o[24:20]),
    .RDaddr_i       (), 
    .RDdata_i       (),
    .RegWrite_i     (), 
    .RS1data_o      (), 
    .RS2data_o      () 
);

Control Control(
    .Op_i       (IFID_inst_o[6:0]),
	.RegWrite_o (),
	.MemtoReg_o (),
	.MemRead_o  (),
	.MemWrite_o (),
	.ALUOp_o    (),
	.ALUSrc_o   (),
    .Branch_o   (),
);


ImmGen ImmGen(
    .clk_i          (clk_i),
    .data_i         (IFID_inst_o),
    .data_o         ()
);

IDEX IDEX(
    .clk_i (clk_i), 
    .start_i (start_i), 
    .RegWrite_i (Control.RegWrite_o), 
    .MemtoReg_i (Control.MemtoReg_o),  
    .MemRead_i (Control.MemRead_o), 
    .MemWrite_i (Control.MemWrite_o), 
    .ALUOp_i (Control.ALUOp_o), 
    .ALUSrc_i (Control.ALUSrc_o),
    .RS1data_i (Registers.RS1data_o), 
    .RS2data_i (Registers.RS2data_o), 
    .ImmGen_i (ImmGen.data_o),
    .funct_7_3_i ({IFID_inst_o[31:25],IFID_inst_o[14:12]),
    .RS1addr_i (IFID_inst_o[19:15]),
    .RS2addr_i (IFID_inst_o[24:20]),
    .RDaddr_i (IFID_inst_o[11:7]), 
    .RegWrite_o (), 
    .MemtoReg_o (),  
    .MemRead_o (), 
    .MemWrite_o (), 
    .ALUOp_o (), 
    .ALUSrc_o (),
    .RS1data_o (), 
    .RS2data_o (), 
    .ImmGen_o (),
    .funct_7_3_o (),
    .RS1addr_o (),
    .RS2addr_o (),
    .RDaddr_o (), 
);

MUX32_4Input MUX_ALUSrc_RS1(
    .data1_i    (),
    .data2_i    (),
    .data3_i    (),
    .select_i   (),
    .data_o     ()
);

MUX32_4Input MUX_ALUSrc_RS2(
    .data1_i    (),
    .data2_i    (),
    .data3_i    (),
    .select_i   (),
    .data_o     ()
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RS2data_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     (ALU.data2_i)
);


ALU ALU(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (Registers.RDdata_i),
    .Zero_o     (zero)
);


ALU_Control ALU_Control(
    .funct_i    ({inst[31:25],inst[14:12]}),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

EXMEM EXMEM (
    .clk_i (clk_i),
    .start_i (start_i),
    .RegWrite_i (IDEX.RegWrite_o),
    .MemtoReg_i (IDEX.MemtoReg_o),
    .MemRead_i (MemRead_out),
    .MemWrite_i (IDEX.MemWrite_o),
    .ALUdata_i (ALU.data_o),
    .RegWaddr_i (MUX_RegDst.data_o), 
    .MemWdata_i (ALURtSrc),
    .RegWrite_o (EXMEMRegWrite_o),
    .MemtoReg_o (),
    .MemRead_o (),
    .MemWrite_o (),
    .ALUzero_o (),
    .ALUdata_o (ALUresult),
    .RegWaddr_o (EXMEM_RDaddr),
    .MemWdata_o ()

);

Data_Memory Data_Memory(
    .clk_i      (), 
    .addr_i     (), 
    .MemRead_i  (),
    .MemWrite_i (),
    .data_i     (),
    .data_o     ()
);

MEMWB MEMWB(
	.clk_i (clk_i),
	.start_i (start_i),
	.RegWrite_i (EXMEMRegWrite_o),
	.MemtoReg_i (EXMEM.MemtoReg_o),
	.ReadData_i (Data_Memory.data_o),
	.ALUdata_i (ALUresult),
	.RegWaddr_i (EXMEM_RDaddr),
	.RegWrite_o (MEMWBRegWrite_o),
	.MemtoReg_o (),
	.ReadData_o (),
	.ALUdata_o (),
	.RegWaddr_o (MEMWB_RDaddr)
);

MUX32 MUX_MemtoReg(
    .data1_i    (MEMWB.ALUdata_o),
    .data2_i    (MEMWB.ReadData_o),
    .select_i   (MEMWB.MemtoReg_o),
    .data_o     (MEMWB.RegSrc)
);




endmodule

