// 0312236_0312241
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 02/25/2016
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
			   );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output  reg   result;
output  reg   cout;

wire 		   A;
wire	      B;

assign A = (A_invert == 1) ? ~src1 : src1;
assign B = (B_invert == 1) ? ~src2 : src2;

always@( * )begin

	case(operation[1:0]) 
	4'b00: begin result = A & B;
				 cout = 0;
			 end
	4'b01: begin result = A | B;
				 cout = 0;
			 end
	4'b10: begin result = A ^ B ^ cin;
				 cout = (A&cin) | (B&cin) | (A&B);
			 end
	4'b11: begin result = less;
		         cout = (A&cin) | (B&cin) | (A&B);
			 end
	endcase
	
end

endmodule
