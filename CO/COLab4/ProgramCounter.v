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

module ProgramCounter(
    clk_i,
	rst_i,
	pc_in_i,
	pc_write,
	pc_out_o
	);
     
//I/O ports
input           clk_i;
input	        rst_i;
input  [32-1:0] pc_in_i;
input 			pc_write;
output [32-1:0] pc_out_o;
 
//Internal Signals
reg    [32-1:0] pc_out_o;

//Parameter

    
//Main function
always @(posedge clk_i) begin
    if(~rst_i)
	    pc_out_o <= 0;
	else if(pc_write)
		pc_out_o <= pc_in_i;	// keep going
	else
	    pc_out_o <= pc_out_o;	// stall
end

endmodule



                    
                    