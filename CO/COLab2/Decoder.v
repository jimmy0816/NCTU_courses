//0312236 吳意凡 0312241 李宜哲
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
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;

 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter

// 000000 -> ADD, AUB, ADN, OR, SLT, 
// 001000 -> ADDI
// 001010 -> SLTI
// 000100 -> BEQ
// 000011

always@(*) begin
    case (instr_op_i)
        6'b000000: begin	// R-type
				RegWrite_o <= 1;
				ALU_op_o <= 3'b100;
				ALUSrc_o <= 0;
				RegDst_o <= 1;
				Branch_o <= 0;
		  end
        6'b001000: begin	// addi
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
		  end
        6'b001010: begin	// slti
				RegWrite_o <= 1;
				ALU_op_o <= 3'b100;
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
		  end
        6'b000100: begin 	// beq
				RegWrite_o <= 0;	// no need
				ALU_op_o <= 3'b001;
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
		  end
		  6'b001111: begin 	// lui
				RegWrite_o <= 1;
				ALU_op_o <= 3'b010;
				ALUSrc_o <= 1;
				Branch_o <= 0;
				RegDst_o <= 0;
		  end
		  6'b001101: begin   // ori
				RegWrite_o <= 1;
				ALU_op_o <= 3'b011;
				ALUSrc_o <= 1;
				Branch_o <= 0;
				RegDst_o <= 0;
		  end
		  6'b000101: begin	// bne
				RegWrite_o <= 0;
				ALU_op_o <= 3'b101;
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
		  end
    endcase
end


//Main function

endmodule





                    
                    