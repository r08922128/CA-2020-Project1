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

wire [31:0] inst,addr;
wire zero;

MUX32 MUX_PCSrc(
    .data1_i (),
    .data2_i (),    
    .select_i (),  
    .data_o ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (),
    .pc_i       (Add_PC.data_o),
    .pc_o       (addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (addr), 
    .inst_o     (inst)
);

Adder Add_PC(
    .data1_in   (addr),
    .data2_in   (32'd4),
    .data_o     (MUX_PCSrc.data1_i)
);

IFID IFID(
    .clk_i 	    (clk_i),
    .start_i 	(start_i),
    .addr_i 	(addpc_out),
    .instr_i 	(Instruction_Memory.instr_o),
    .Flush_i	(branch | jump),
    .Stall_i    (HazardDetection_Unit.Stall_o),
    .addr_o	    (IFIDaddr_o),
    .inst_o	    (inst)
);

Adder Add_Branch_addr(
    .data1_in (IFIDaddr_o), 
    .data2_in (Sign_Extend.data_o << 1),
    .data_o (MUX_PCSrc.data2_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (inst[19:15]),
    .RS2addr_i   (inst[24:20]),
    .RDaddr_i   (inst[11:7]), 
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o), 
    .RS1data_o   (ALU.data1_i), 
    .RS2data_o   (MUX_ALUSrc.data1_i) 
);

Control Control(
    .Op_i       (inst[6:0]),
	.RegWrite_o (Registers.RegWrite_i),
	.MemtoReg_o (),
	.MemRead_o  (),
	.MemWrite_o (),
	.ALUOp_o    (ALU_Control.ALUOp_i),
	.ALUSrc_o   (MUX_ALUSrc.select_i),
    .Branch_o   (),
);


Sign_Extend Sign_Extend(
    .data_i     (inst[31:20]),
    .data_o     (MUX_ALUSrc.data2_i)
);

IDEX IDEX(
    .clk_i (clk_i), 
    .start_i (start_i), 
    .RegWrite_i (MUX8.data_o[7:7]), 
    .MemtoReg_i (MUX8.data_o[6:6]),  
    .MemRead_i (MUX8.data_o[5:5]), 
    .MemWrite_i (MUX8.data_o[4:4]), 
    .RegDst_i (MUX8.data_o[3:3]), 
    .ALUOp_i (MUX8.data_o[2:1]), 
    .ALUSrc_i (MUX8.data_o[0:0]), 
    .addr_i (IFIDaddr_o), 
    .RSdata_i (Registers.RSdata_o), 
    .RTdata_i (Registers.RTdata_o), 
    .Sign_Extend_i (Sign_Extend.data_o), 
    .Sign_Extend_o (IOperand),
    .RSaddr_i (inst[25:21]),
    .RTaddr_i (inst[20:16]), 
    .RDaddr_i (inst[15:11]), 
    .RegWrite_o (), 
    .MemtoReg_o (), 
    .MemRead_o (MemRead_out), 
    .MemWrite_o (), 
    .RegDst_o (), 
    .ALUOp_o (), 
    .ALUSrc_o (), 
    .addr_o (), 
    .RSdata_o (), 
    .RTdata_o (),
    .RSaddr_o	(),
    .RTaddr_o (IDEX_RTaddr), 
    .RDaddr_o ()
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

