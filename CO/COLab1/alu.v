//0312236_0312241
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 02/25/2016
// Design Name:
// Module Name:    alu
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

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		 //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire    [32-1:0] result;
//reg	   [31:0]   result_tmp;
wire            zero;
wire             cout;
wire             overflow;

wire 			cin;
wire			set_less;
wire	[31:0]	cout_tmp;

assign cin = ALU_control[3] ^ ALU_control[2]; // cin_init
assign cout = (cout_tmp != 0 && ALU_control != 4'b0111) ? 1 : 0;	// cout_init
assign set_less = (src1[31]^(~src2[31])^cout_tmp[30]);	// less
assign zero = (result == 0) ? 1 : 0;				// zero
assign overflow = cout_tmp[31] ^ cout_tmp[30]; 	// overflow

alu_top alu_0(.src1(src1[0]), .src2(src2[0]), .less(set_less), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cin), .operation(ALU_control[1:0]), .result(result[0]), .cout(cout_tmp[0]));
alu_top alu_1(.src1(src1[1]), .src2(src2[1]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[0]), .operation(ALU_control[1:0]), .result(result[1]), .cout(cout_tmp[1]));
alu_top alu_2(.src1(src1[2]), .src2(src2[2]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[1]), .operation(ALU_control[1:0]), .result(result[2]), .cout(cout_tmp[2]));
alu_top alu_3(.src1(src1[3]), .src2(src2[3]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[2]), .operation(ALU_control[1:0]), .result(result[3]), .cout(cout_tmp[3]));
alu_top alu_4(.src1(src1[4]), .src2(src2[4]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[3]), .operation(ALU_control[1:0]), .result(result[4]), .cout(cout_tmp[4]));
alu_top alu_5(.src1(src1[5]), .src2(src2[5]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[4]), .operation(ALU_control[1:0]), .result(result[5]), .cout(cout_tmp[5]));
alu_top alu_6(.src1(src1[6]), .src2(src2[6]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[5]), .operation(ALU_control[1:0]), .result(result[6]), .cout(cout_tmp[6]));
alu_top alu_7(.src1(src1[7]), .src2(src2[7]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[6]), .operation(ALU_control[1:0]), .result(result[7]), .cout(cout_tmp[7]));
alu_top alu_8(.src1(src1[8]), .src2(src2[8]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[7]), .operation(ALU_control[1:0]), .result(result[8]), .cout(cout_tmp[8]));
alu_top alu_9(.src1(src1[9]), .src2(src2[9]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[8]), .operation(ALU_control[1:0]), .result(result[9]), .cout(cout_tmp[9]));
alu_top alu_10(.src1(src1[10]), .src2(src2[10]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[9]), .operation(ALU_control[1:0]), .result(result[10]), .cout(cout_tmp[10]));
alu_top alu_11(.src1(src1[11]), .src2(src2[11]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[10]), .operation(ALU_control[1:0]), .result(result[11]), .cout(cout_tmp[11]));
alu_top alu_12(.src1(src1[12]), .src2(src2[12]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[11]), .operation(ALU_control[1:0]), .result(result[12]), .cout(cout_tmp[12]));
alu_top alu_13(.src1(src1[13]), .src2(src2[13]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[12]), .operation(ALU_control[1:0]), .result(result[13]), .cout(cout_tmp[13]));
alu_top alu_14(.src1(src1[14]), .src2(src2[14]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[13]), .operation(ALU_control[1:0]), .result(result[14]), .cout(cout_tmp[14]));
alu_top alu_15(.src1(src1[15]), .src2(src2[15]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[14]), .operation(ALU_control[1:0]), .result(result[15]), .cout(cout_tmp[15]));
alu_top alu_16(.src1(src1[16]), .src2(src2[16]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[15]), .operation(ALU_control[1:0]), .result(result[16]), .cout(cout_tmp[16]));
alu_top alu_17(.src1(src1[17]), .src2(src2[17]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[16]), .operation(ALU_control[1:0]), .result(result[17]), .cout(cout_tmp[17]));
alu_top alu_18(.src1(src1[18]), .src2(src2[18]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[17]), .operation(ALU_control[1:0]), .result(result[18]), .cout(cout_tmp[18]));
alu_top alu_19(.src1(src1[19]), .src2(src2[19]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[18]), .operation(ALU_control[1:0]), .result(result[19]), .cout(cout_tmp[19]));
alu_top alu_20(.src1(src1[20]), .src2(src2[20]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[19]), .operation(ALU_control[1:0]), .result(result[20]), .cout(cout_tmp[20]));
alu_top alu_21(.src1(src1[21]), .src2(src2[21]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[20]), .operation(ALU_control[1:0]), .result(result[21]), .cout(cout_tmp[21]));
alu_top alu_22(.src1(src1[22]), .src2(src2[22]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[21]), .operation(ALU_control[1:0]), .result(result[22]), .cout(cout_tmp[22]));
alu_top alu_23(.src1(src1[23]), .src2(src2[23]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[22]), .operation(ALU_control[1:0]), .result(result[23]), .cout(cout_tmp[23]));
alu_top alu_24(.src1(src1[24]), .src2(src2[24]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[23]), .operation(ALU_control[1:0]), .result(result[24]), .cout(cout_tmp[24]));
alu_top alu_25(.src1(src1[25]), .src2(src2[25]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[24]), .operation(ALU_control[1:0]), .result(result[25]), .cout(cout_tmp[25]));
alu_top alu_26(.src1(src1[26]), .src2(src2[26]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[25]), .operation(ALU_control[1:0]), .result(result[26]), .cout(cout_tmp[26]));
alu_top alu_27(.src1(src1[27]), .src2(src2[27]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[26]), .operation(ALU_control[1:0]), .result(result[27]), .cout(cout_tmp[27]));
alu_top alu_28(.src1(src1[28]), .src2(src2[28]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[27]), .operation(ALU_control[1:0]), .result(result[28]), .cout(cout_tmp[28]));
alu_top alu_29(.src1(src1[29]), .src2(src2[29]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[28]), .operation(ALU_control[1:0]), .result(result[29]), .cout(cout_tmp[29]));
alu_top alu_30(.src1(src1[30]), .src2(src2[30]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[29]), .operation(ALU_control[1:0]), .result(result[30]), .cout(cout_tmp[30]));
alu_top alu_31(.src1(src1[31]), .src2(src2[31]), .less(0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_tmp[30]), .operation(ALU_control[1:0]), .result(result[31]), .cout(cout_tmp[31]));


endmodule
