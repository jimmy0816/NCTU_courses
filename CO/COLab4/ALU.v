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

module ALU(
   ALUctl,
	A,
	B,
	ALUOut,
	Zero
//	shamt
	);
     
//I/O ports
input  [32-1:0]  A;
input  [32-1:0]	 B;
input  [4-1:0]   ALUctl;
//input  [5-1:0]	  shamt;

output [32-1:0]	 ALUOut;
output           Zero;

//Internal signals
reg    [32-1:0]  ALUOut;
wire             Zero;

//Parameter

//Main function
// zero is true if aluout is 0
assign Zero = (ALUOut == 0);

always @(ALUctl, A, B) begin
	case(ALUctl)
		0: 	ALUOut <= A & B;
		1: 	ALUOut <= A | B;
		2: 	ALUOut <= A + B;  // add, addi
		3:    ALUOut <= B >> A; // srlv
//		4:		ALUOut <= B >> shamt; // srl
		5:		ALUOut <= B << 16;
		6: 	ALUOut <= A - B;
		7: 	ALUOut <= A < B ? 1 : 0;
		8:		ALUOut <= A | {{16{0}},B[15:0]};	// ori
//		9:		ALUOut <= A == B;	// bne
		10:   ALUOut <= A * B;
//		11:   ALUOut <= A;
		default: ALUOut <= 0;
	endcase
end
endmodule





                    
                    