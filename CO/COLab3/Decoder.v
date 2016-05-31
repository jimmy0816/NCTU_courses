//0312236 ³æ0312241 Žå
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
   instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemToReg_o,
	MemWrite_o,
	MemRead_o,
	Jump_o,
	JalSelect_o,
	funct_i,
	Branch_type_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input	 [6-1:0] funct_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output [2-1:0]	MemToReg_o;
output			MemWrite_o;
output			MemRead_o;
output 			Jump_o;
output			JalSelect_o;
output [1:0]   Branch_type_o;

 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg	 [2-1:0] MemToReg_o;
reg				MemWrite_o;
reg				MemRead_o;
reg 				Jump_o;
reg				JalSelect_o;
reg	 [1:0]	Branch_type_o;

always@(*) begin
    case (instr_op_i)
        6'b000000: begin	// R-type jr
				RegWrite_o <= (funct_i == 6'b001000)? 0 : 1;
				ALU_op_o <= 3'b100;	// 4
				ALUSrc_o <= 0;
				RegDst_o <= 1;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= (funct_i == 6'b001000)? 1 : 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
        6'b001000: begin	// addi
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;	// 0
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
        6'b001010: begin	// slti
				RegWrite_o <= 1;
				ALU_op_o <= 3'b100;	
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
        6'b000100: begin 	// beq
				RegWrite_o <= 0;	// no need
				ALU_op_o <= 3'b001;	// 1
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b001111: begin 	// lui
				RegWrite_o <= 1;
				ALU_op_o <= 3'b010;	// 2
				ALUSrc_o <= 1;
				Branch_o <= 0;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b001101: begin   // ori
				RegWrite_o <= 1;
				ALU_op_o <= 3'b011;	// 3
				ALUSrc_o <= 1;
				Branch_o <= 0;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b000101: begin	// bne bnez
				RegWrite_o <= 0;
				ALU_op_o <= 3'b101;	// 5
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b100011: begin	// lw
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;	// 
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 1;
				MemWrite_o <= 0;
				MemRead_o <= 1;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b101011: begin	//sw
				RegWrite_o <= 0;
				ALU_op_o <= 3'b000;
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 1;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b000010: begin	// jump
				RegWrite_o <= 0;
				ALU_op_o <= 3'b000;	
				ALUSrc_o <= 0;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 1;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b00;
		  end
		  6'b000011: begin	// jal
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;
				ALUSrc_o <= 0;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 2'b00;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 1;
				JalSelect_o <= 1;
				Branch_type_o <= 2'b00;
		  end
		  6'b000110: begin  // blt
				RegWrite_o <= 0;	
				ALU_op_o <= 3'b110;	// 6
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
				Branch_type_o <= 2'b10;	// 2
		  end
        6'b000001: begin   // bgez
				RegWrite_o <= 0;
				ALU_op_o <= 3'b110;	
				ALUSrc_o <= 0;
				RegDst_o <= 1;
				Branch_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;	
				JalSelect_o <= 0;
				Branch_type_o <= 2'b01;	// 1				
		  end
    endcase
end


//Main function

endmodule





                    
                    