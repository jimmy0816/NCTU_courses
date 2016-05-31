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
module Pipe_Reg_IFID(
                    clk_i,
					rst_i,
					IFIDWrite_i,
					IFFlush_i,
					data_i,
					data_o
					);
					
parameter size = 0;

input               clk_i;		  
input				rst_i;
input               IFIDWrite_i;
input               IFFlush_i;
input      [size-1: 0] data_i;
output reg [size-1: 0] data_o;
	  
always @(posedge clk_i) begin
    if(~rst_i || IFFlush_i == 1'b1)	// IF.Flush, zero the instruction field
        data_o <= 0;
	else if(IFIDWrite_i == 1'b1)	// stall a clock cycle, same ifid registers
		data_o <= data_o;
    else
        data_o <= data_i;
/*		
	if(~rst_i)	// IF.Flush, zero the instruction field
        data_o <= 0;
    else
        data_o <= data_i;
		
*/
end

endmodule	