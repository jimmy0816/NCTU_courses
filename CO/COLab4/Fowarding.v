//0312236 吳意凡 0312241 李宜哲
//Subject:     CO project 4 - Pipe CPU 1
module Fowarding(
	IDEX_RS_i, IDEX_RT_i, EXMEM_RD_i, MEMWB_RD_i, EXMEM_RegWrite, MEMWB_RegWrite,
	FowardA_o, FowardB_o
);

input [4:0] IDEX_RS_i; 
input [4:0] IDEX_RT_i; 
input [4:0] EXMEM_RD_i;
input [4:0] MEMWB_RD_i;
input 		EXMEM_RegWrite; 
input		MEMWB_RegWrite;

output reg [1:0] FowardA_o;
output reg [1:0] FowardB_o;

always @(*) begin
	// EX hazard
	if(EXMEM_RegWrite && (EXMEM_RD_i != 0) && (EXMEM_RD_i == IDEX_RS_i)) begin
		FowardA_o <= 2'b10;
		FowardB_o <= 2'b00;
	end
	else if(EXMEM_RegWrite && (EXMEM_RD_i != 0) && (EXMEM_RD_i == IDEX_RT_i)) begin
		FowardA_o <= 2'b00;
		FowardB_o <= 2'b10;
	end
	// MEM hazard
	else if(MEMWB_RegWrite && (MEMWB_RD_i != 0) && (EXMEM_RD_i != IDEX_RS_i) && (MEMWB_RD_i == IDEX_RS_i)) begin
		FowardA_o <= 2'b01;
		FowardB_o <= 2'b00;
	end
	else if(MEMWB_RegWrite && (MEMWB_RD_i != 0) && (EXMEM_RD_i != IDEX_RT_i) && (MEMWB_RD_i == IDEX_RT_i)) begin
		FowardA_o <= 2'b00;
		FowardB_o <= 2'b01;
	end
	else begin
		FowardA_o <= 2'b00;
		FowardB_o <= 2'b00;
	end
end

endmodule