//0312236 吳意凡 0312241 李宜哲
//Subject:     CO project 2 - Simple Single CPU
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

wire [31:0] RS_data;
wire [31:0] RT_data;

wire [3:0]  ALU_ctl;
wire [2:0]  ALUOp;
wire 		   ALUSrc;
wire [31:0] ALU_src2;
	
wire [31:0] i_type;


wire 			zero;
wire			cout;
wire [31:0] ALU_result;
wire [31:0] shift2;
wire [4:0]  Write_Reg1;

wire 			RegDst;
wire 			RegWrite;
wire 			Branch;



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
        .pc_addr_i(pc),
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
        .RDaddr_i(Write_Reg1),
        .RDdata_i(ALU_result),
        .RegWrite_i (RegWrite),
        .RSdata_o(RS_data),
        .RTdata_o(RT_data)
        );

Decoder Decoder(
        .instr_op_i(inst_w[31:26]),	// op, 6 bit
        .RegWrite_o(RegWrite),
        .ALU_op_o(ALUOp),
        .ALUSrc_o(ALUSrc),
        .RegDst_o(RegDst),
        .Branch_o(Branch)
        );

ALU_Ctrl AC(
        .funct_i(inst_w[5:0]),	// 6 bit
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALU_ctl)
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

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next_ins),
        .data1_i(pc_back_pre),
        .select_i(Branch & Zero),
        .data_o(pc_back)
        );

endmodule
		  


