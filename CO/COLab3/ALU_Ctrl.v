//0312236 ³æ0312241 Žå
//Subject:     CO project 3 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
//			 JrSelect_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
//output		  		 JrSelect_o;
//Internal Signals
reg        [4-1:0] ALUCtrl_o;



//Parameter
/*
add 0010 2
sub 0110 6
and 0000 0
or  0001 1
slt 0111 7
addi 0010 2
slti 0111 7
beq 0110 6
SRL 0100 4
SRLV 0011 3
mul 1010 10
*/

//assign JrSelect = (ALUOp_i == 3'b100 && funct_i == 6'b001000) ? 1 : 0;

always@(*) begin
    case (ALUOp_i)
        3'b100:	// R-type
            case (funct_i)	// add sub and or slt
					6'b100000: ALUCtrl_o <= 4'b0010;	// add    
					6'b100010: ALUCtrl_o <= 4'b0110; // sub
               6'b100100: ALUCtrl_o <= 4'b0000; // and   
               6'b100101: ALUCtrl_o <= 4'b0001; // or   
               6'b101010: ALUCtrl_o <= 4'b0111; // slt
					6'b000010: ALUCtrl_o <= 4'b0100; // srl
					6'b000110: ALUCtrl_o <= 4'b0011; // srlv
					6'b011000: ALUCtrl_o <= 4'b1010; // mul
					6'b001000: ALUCtrl_o <= 4'b1011; // jr
               default:   ALUCtrl_o <= 4'bxxxx;
            endcase
        3'b000:   // addi
				ALUCtrl_o <= 4'b0010;                   
		  3'b001:	// beq  
				ALUCtrl_o <= 4'b0110;
		  3'b010:	// lui
				ALUCtrl_o <= 4'b0101;
		  3'b011:	// ori
				ALUCtrl_o <= 4'b1000;
		  3'b101:	// bne bnez 
				ALUCtrl_o <= 4'b1001;
		  3'b110:	// blt bgez
				ALUCtrl_o <= 4'b0110;	// sub
        default: ALUCtrl_o <= 4'bxxxx;
    endcase
end




       
//Select exact operation

endmodule     





                    
                    