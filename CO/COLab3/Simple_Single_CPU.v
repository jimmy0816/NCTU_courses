//0312236§d·N¤Z_0312241§õ©y­õ
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
      clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles


wire [31:0] pc;
wire [31:0] inst_w;
wire [31:0] pc_next_ins;
wire [31:0] pc_back_pre;
wire [31:0] pc_back;
wire [31:0] pc1;

wire [31:0] RS_data;
wire [31:0] RT_data;
wire [31:0] mdata;
wire [31:0] wdata;
wire [3:0]  ALU_ctl;
wire [31:0] ALU_src2;
	
wire [31:0] i_type;


wire 			Zero;
wire			Zero2;
wire			cout;
wire [31:0] ALU_result;
wire [31:0] shift2;
wire [31:0] top_shift;
wire [4:0]  Write_Reg1;

wire 	RegDst;
wire 			RegWrite;
wire 			branch;
wire [1:0]  branch_type;
wire [2-1:0]	mtreg;
wire			jump;
wire		   mread;
wire			mwrite;
wire [2:0]  ALUOp;
wire 		   ALUSrc;
wire			jal;
wire			jr;

wire [31:0] jal_addr;
wire [4:0]  jal_result;
wire [31:0] jr_result;

//Greate componentes

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i (rst_i),
    .pc_in_i(pc_back),
    .pc_out_o(pc)
    );

Adder Adder1(
        .src1_i(32'd4),
        .src2_i(pc),
        .sum_o(pc_next_ins)
        );

Instr_Memory IM(
        .addr_i(pc),
        .instr_o(inst_w)
        );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(inst_w[20:16]),
        .data1_i(inst_w[15:11]),
        .select_i(RegDst),
        .data_o(Write_Reg1)
        );

Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .RSaddr_i(inst_w[25:21]),	// rs
        .RTaddr_i(inst_w[20:16]),   // rt
        .RDaddr_i(jal_result),
        .RDdata_i(wdata),
        .RegWrite_i(RegWrite),
        .RSdata_o(RS_data),
        .RTdata_o(RT_data)
        );

Decoder Decoder(
        .instr_op_i(inst_w[31:26]),	// op, 6 bit
        .RegWrite_o(RegWrite),
        .ALU_op_o(ALUOp),
        .ALUSrc_o(ALUSrc),
        .RegDst_o(RegDst),
        .Branch_o(branch),
		  .MemToReg_o(mtreg),
		  .MemRead_o(mread),
		  .MemWrite_o(mwrite),
		  .Jump_o(jump),
		  .JalSelect_o(jal),
		  .funct_i(inst_w[5:0]),
		  .Branch_type_o(branch_type)
        );

ALU_Ctrl AC(
        .funct_i(inst_w[5:0]),	// 6 bit
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALU_ctl)
//		  .JrSelect_o(jr)
        );

Sign_Extend SE(
        .data_i(inst_w[15:0]),	// constant or address 16 bit
        .data_o(i_type)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RT_data),
        .data1_i(i_type),
        .select_i(ALUSrc),
        .data_o(ALU_src2)
        );

ALU ALU(
		  .ALUctl(ALU_ctl),
        .A(RS_data),
	     .B(ALU_src2),
	     .ALUOut(ALU_result),
		  .Zero(Zero),
		  .shamt(inst_w[10:6])
	    );
		  
Adder Adder2(
        .src1_i(pc_next_ins),
        .src2_i(shift2),
        .sum_o(pc_back_pre)
        );

Shift_Left_Two_32 Shifter(
        .data_i(i_type),
        .data_o(shift2)
        );

MUX_2to1 #(.size(32)) PC_Source_Mux(
        .data0_i(pc_next_ins),
        .data1_i(pc_back_pre),
        .select_i(branch & Zero2),
        .data_o(pc1)
        );

Shift_Left_Two_32 Top_shift(
		  .data_i({6'b000000,inst_w[25:0]}),
		  .data_o(top_shift)
		  );
		  
Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(ALU_result),
    .data_i(RT_data),
    .MemRead_i(mread),
    .MemWrite_i(mwrite),
    .data_o(mdata)
    );

MUX_4to1 #(.size(1)) Result_Zero_Mux(
        .data3_i(~Zero),
		  .data2_i(ALU_result[31]),
        .data1_i(~(Zero | ALU_result[31])),
        .data0_i(Zero),
        .select_i(branch_type),
        .data_o(Zero2)
        );

MUX_3to1 #(.size(32)) WReg_Src_Mux(
        .data0_i(jal_addr),
        .data1_i(mdata),
        .data2_i(i_type),
        .select_i(mtreg),
        .data_o(wdata)
        );

MUX_2to1 #(.size(32)) Jump_Mux(
//        .data1_i({pc_next_ins[31:28],top_shift[27:0]}),
		  .data1_i(jr_result),
        .data0_i(pc1),
        .select_i(jump),
        .data_o(pc_back)
        );

MUX_2to1 #(.size(32)) Mux_jal_addr(
        .data0_i(ALU_result),
        .data1_i(pc_next_ins),
        .select_i(jal),
        .data_o(jal_addr)
        );	
		  
MUX_2to1 #(.size(32)) Mux_jr(
        .data0_i({pc_next_ins[31:28],top_shift[27:0]}),
        .data1_i(RS_data),
        .select_i(jr),
        .data_o(jr_result)
        );
		  
MUX_2to1 #(.size(5)) Mux_jal_reg(
        .data0_i(Write_Reg1),
        .data1_i(5'd31),
        .select_i(jal),
        .data_o(jal_result)
		  );
		  
assign jump = ({inst_w[31:26], inst_w[5:0]} == {6'b000000, 6'b001000})? 1 :
				  (inst_w[31:26] == 6'b000010) ? 1 :
				  (inst_w[31:26] == 6'b000011)? 1: 
				  0;
				  
assign jr = ({inst_w[31:26], inst_w[5:0]} == {6'b000000, 6'b001000})? 1: 0;

/*
assign jal = (inst_w[31:26] == 6'b000011)? 1: 0;

*/
/*
MUX_2to1 #(.size(5)) MUX_RF_RSaddr(
        .data0_i(inst_w[25:21]),
        .data1_i(5'd29),
        .select_i(jal),
        .data_o(RS_data)
        );

MUX_2to1 #(.size(5)) MUX_RF_RTaddr(
        .data0_i(inst_w[20:16]),
        .data1_i(5'd31),
        .select_i(jal),
        .data_o(RT_data)
        );
*/
endmodule
		  


