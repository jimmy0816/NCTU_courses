//0312236 吳意凡 0312241 李宜哲
//Subject:     CO project 4 - Pipe CPU 1
module Hazard(
	PCSrc_i, EX_MemRead_i, IFID_RSRT_i, IDEX_RT_i,
	PCWrite_o, IFIDStall_o, IFFlush_o, IDFlush_o, EXFlush_o
);

input		PCSrc_i;
input		EX_MemRead_i;
input [9:0] IFID_RSRT_i;
input [4:0] IDEX_RT_i;

output reg  PCWrite_o;
output reg  IFIDStall_o;
output reg  IFFlush_o;
output reg  IDFlush_o;
output reg  EXFlush_o;

always @(*) begin
	case(PCSrc_i)
		1:	begin	// branch taken condition, flush the instruction in if id ex
			PCWrite_o <= 1;
			IFIDStall_o <= 0;
			IFFlush_o <= 1;
			IDFlush_o <= 1;
		    EXFlush_o <= 1;
		end
		0: begin	// not branch or branch not taken
			// hazard condition, stall the pipeline
			if(EX_MemRead_i == 1 && ((IDEX_RT_i == IFID_RSRT_i[9:5]) || (IDEX_RT_i == IFID_RSRT_i[4:0]))) begin
				PCWrite_o <= 0;
				IFIDStall_o <= 1;
				IFFlush_o <= 0;
				IDFlush_o <= 1;
				EXFlush_o <= 0;
			end
			else begin		// normal
				PCWrite_o <= 1;
				IFIDStall_o <= 0;
				IFFlush_o <= 0;
				IDFlush_o <= 0;
				EXFlush_o <= 0;			
			end
		end
	endcase
end

endmodule