//0312236 吳意凡 0312241 李宜哲
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/

wire [31:0] pc_back;
wire [31:0] pc;
wire [31:0] pc_next_ins;
wire [31:0] inst_w;

/**** ID stage ****/

wire [31:0] ifid_pcnext;
wire [31:0] ifid_ins;
wire [31:0] id_itype;
wire [31:0] id_rs_o;
wire [31:0] id_rt_o;

wire 	    id_regwrite;
wire		id_jump;
wire		id_branch;
wire		id_memread;
wire 		id_memtoreg;
wire		id_memwrite;
wire 	    id_regdst;
wire [2:0]  id_aluop;
wire 	    id_alusrc;
wire [10:0] id_signal;
// hazard unit
wire IF_Flush;
wire ID_Flush;
wire EX_Flush;
wire IFID_Write;
wire PCWrite;

/**** EX stage ****/

wire [31:0] idex_itype;
wire [31:0] idex_pcnext;
wire [31:0] idex_rs_o;
wire [31:0] idex_rt_o;
wire [4:0]	idex_rt;
wire [4:0]  idex_rd;
wire [4:0]  idex_rs;
wire [31:0] ex_pcback;
wire [4:0]  ex_rd;
wire [31:0] ex_ALU_result;
wire 		ex_zero;
wire [31:0] ALU_i2;
wire [31:0] shift2;
wire [3:0]  ALU_ctl;
wire [31:0] fa_o;
wire [31:0] fb_o;

wire 	    ex_regwrite;
wire		ex_jump;
wire		ex_branch;
wire		ex_memread;
wire 		ex_memtoreg;
wire		ex_memwrite;
wire 	    RegDst;
wire [2:0]  ALUOp;
wire 	    ALUSrc;
wire [1:0]  ex_wbsignal;
wire [3:0]  ex_memsignal;



/**** MEM stage ****/

wire [31:0] exmem_pcback;
wire [31:0] exmem_ALU_result;
wire [31:0] exmem_rt_o;
wire [4:0]  exmem_rd;
wire 		exmem_zero;
wire [31:0] mem_mdata;

wire mem_regwrite;
wire mem_memtoreg;
wire Branch;
wire Jump;
wire MemWrite;
wire MemRead;
wire PCSrc;
wire [1:0] FowardA;
wire [1:0] FowardB;

/**** WB stage ****/
wire [31:0]	memwb_mdata;
wire [31:0] memwb_ALU_result;
wire [4:0]	memwb_wreg;
wire [31:0] mem_wdata;

wire RegWrite;
wire MemToReg;




/****************************************
Instnatiate modules
****************************************/
// * * *Instantiate the components in IF stage
ProgramCounter PC(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.pc_in_i(pc_back),
		.pc_write(PCWrite),
		.pc_out_o(pc)
        );
		
MUX_2to1 #(.size(32)) Mux1_pc(
		.data0_i(pc_next_ins),
		.data1_i(exmem_pcback),
		.select_i(PCSrc),
		.data_o(pc_back)
        );

Instruction_Memory IM(
        .addr_i(pc),
        .instr_o(inst_w)
	    );
			
Adder Add_pc(
        .src1_i(pc),
        .src2_i(32'd4),
        .sum_o(pc_next_ins)
		);

		
Pipe_Reg_IFID #(.size(64)) IF_ID(       //N is the total length of input/output
		.clk_i(clk_i),  
		.rst_i(rst_i), 
		.IFIDWrite_i(IFID_Write),
		.IFFlush_i(IF_Flush),
		.data_i({pc_next_ins,inst_w}),
		.data_o({ifid_pcnext,ifid_ins})
		);
		
// * * *Instantiate the components in ID stage
Hazard Hazard_Detection(
        .PCSrc_i(PCSrc),
		.EX_MemRead_i(ex_memread),
		.IFID_RSRT_i(ifid_ins[25:16]),
		.IDEX_RT_i(idex_rt),
		.PCWrite_o(PCWrite),
		.IFIDStall_o(IFID_Write), 
		.IFFlush_o(IF_Flush), 
		.IDFlush_o(ID_Flush),
		.EXFlush_o(EX_Flush)
		);
		
Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .RSaddr_i(ifid_ins[25:21]),	// rs
        .RTaddr_i(ifid_ins[20:16]),   // rt
        .RDaddr_i(memwb_wreg),
        .RDdata_i(mem_wdata),
        .RegWrite_i(RegWrite),
        .RSdata_o(id_rs_o),
        .RTdata_o(id_rt_o)
		);

Decoder Control(
        .instr_op_i(ifid_ins[31:26]),	// op, 6 bit
        .RegWrite_o(id_regwrite),
        .ALU_op_o(id_aluop),
        .ALUSrc_o(id_alusrc),
        .RegDst_o(id_regdst),
        .Branch_o(id_branch),
		.MemToReg_o(id_memtoreg),
		.MemRead_o(id_memread),
		.MemWrite_o(id_memwrite),
		.Jump_o(id_jump)
		);
		
MUX_2to1 #(.size(11)) Mux2_IDFlush(
		.data0_i({id_regwrite, id_memtoreg,
				  id_jump, id_branch, id_memread, id_memwrite,
				  id_regdst, id_aluop, id_alusrc}),
		.data1_i(11'd0),
		.select_i(ID_Flush),
		.data_o(id_signal)
        );
		
Sign_Extend Sign_Extend(
        .data_i(ifid_ins[15:0]),	
        .data_o(id_itype)
		);	

	// basic: 11 + 128 + 10 = 149
	// advance: 11 + 128 + 15 = 154
Pipe_Reg #(.size(154)) ID_EX(	
		.clk_i(clk_i),  
		.rst_i(rst_i), 
		.data_i({id_signal,
				 ifid_pcnext, id_rs_o, id_rt_o, id_itype, ifid_ins[25:21], ifid_ins[20:16], ifid_ins[15:11]}),
		.data_o({ex_regwrite, ex_memtoreg,
				 ex_jump, ex_branch, ex_memread, ex_memwrite,
				 RegDst, ALUOp, ALUSrc,
				 idex_pcnext, idex_rs_o, idex_rt_o, idex_itype, idex_rs, idex_rt, idex_rd})
		);
		
// * * *Instantiate the components in EX stage	
Adder Add_pc2(
        .src1_i(idex_pcnext),
        .src2_i(shift2),
        .sum_o(ex_pcback)
		);
		
Shift_Left_Two_32 Shifter(
        .data_i(idex_itype),
        .data_o(shift2)
        );
		
ALU ALU(
		.ALUctl(ALU_ctl),
        .A(fa_o),
	    .B(ALU_i2),
	    .ALUOut(ex_ALU_result),
		.Zero(ex_zero)
//		.shamt(inst_w[10:6])
		);
		
ALU_Ctrl ALU_Control(
        .funct_i(idex_itype[5:0]),	
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALU_ctl)
		);
	
MUX_3to1 #(.size(32)) Mux3_FA(
		.data0_i(idex_rs_o),
		.data1_i(mem_wdata),
		.data2_i(exmem_ALU_result),
		.select_i(FowardA),
		.data_o(fa_o)
        );
		
MUX_3to1 #(.size(32)) Mux4_FB(
		.data0_i(idex_rt_o),
		.data1_i(mem_wdata),
		.data2_i(exmem_ALU_result),
		.select_i(FowardB),
		.data_o(fb_o)
        );
		
MUX_2to1 #(.size(32)) Mux5_ALUsrc(
		.data0_i(fb_o),
		.data1_i(idex_itype),
		.select_i(ALUSrc),
		.data_o(ALU_i2)
        );
		
MUX_2to1 #(.size(5)) Mux6_RD(
		.data0_i(idex_rt),
		.data1_i(idex_rd),
		.select_i(RegDst),
		.data_o(ex_rd)
        );

MUX_2to1 #(.size(4)) Mux7_MEMsignal(
		.data0_i({ex_jump, ex_branch, ex_memread, ex_memwrite}),
		.data1_i(4'd0),
		.select_i(EX_Flush),
		.data_o(ex_memsignal)
        );

MUX_2to1 #(.size(2)) Mux8_WBsignal(
		.data0_i({ex_regwrite,ex_memtoreg}),
		.data1_i(2'd0),
		.select_i(EX_Flush),
		.data_o(ex_wbsignal)
        );


Fowarding Fowarding_Unit(
		.IDEX_RS_i(idex_rs),
		.IDEX_RT_i(idex_rt),
		.EXMEM_RD_i(exmem_rd),
		.MEMWB_RD_i(memwb_wreg),
		.EXMEM_RegWrite(mem_regwrite),
		.MEMWB_RegWrite(RegWrite),
		.FowardA_o(FowardA),
		.FowardB_o(FowardB)
		);

	// basic: 6 + 32 + 1 + 32 + 32 + 5 = 108
	// advance: 6 + 32 + 1 + 32 + 32 + 5 = 108
Pipe_Reg #(.size(108)) EX_MEM(
		.clk_i(clk_i),  
		.rst_i(rst_i), 
		.data_i({ex_wbsignal, ex_memsignal,
				 ex_pcback, ex_zero, ex_ALU_result, fb_o, ex_rd}),
		.data_o({mem_regwrite, mem_memtoreg,
				 Jump, Branch, MemRead, MemWrite, 
				 exmem_pcback, exmem_zero, exmem_ALU_result, exmem_rt_o, exmem_rd})
		);
			   
// * * *Instantiate the components in MEM stage
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(exmem_ALU_result),
		.data_i(exmem_rt_o),
		.MemRead_i(MemRead),
		.MemWrite_i(MemWrite),
		.data_o(mem_mdata)
	    );

	// basic: 2 + 32 + 32 + 5 = 71
	// advance: 2 + 32 + 32 + 5 = 71
Pipe_Reg #(.size(71)) MEM_WB(
  		.clk_i(clk_i),  
		.rst_i(rst_i), 
		.data_i({mem_regwrite, mem_memtoreg,
				 mem_mdata, exmem_ALU_result, exmem_rd}),
		.data_o({RegWrite, MemToReg,
				 memwb_mdata, memwb_ALU_result, memwb_wreg})      
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux9_Memory(
		.data0_i(memwb_ALU_result),
		.data1_i(memwb_mdata),
		.select_i(MemToReg),
		.data_o(mem_wdata)
        );

/****************************************
signal assignment
****************************************/	
assign PCSrc = Branch & exmem_zero;

endmodule

