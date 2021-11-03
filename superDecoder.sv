module superDecoder#(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk, rst,
	 input logic [REGI_SIZE-1:0] instruction,
	 input logic [REGI_SIZE-1:0] next_pc_i,
	 input logic                             int_we_i, vec_we_i,
	 input logic [REGI_BITS-1:0]             int_dest_i,
	 input logic [VECT_BITS-1:0]             vec_dest_i,
	 input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_wd_i,
	 input logic [REGI_SIZE-1:0]             int_wd_i,
	 input logic                       [1:0] alu_flags_i,
	output logic [REGI_BITS-1:0]             reg_dest_o,
	output logic [VECT_BITS-1:0]             vec_dest_o,
	output logic [REGI_SIZE-1:0]             intOper1,
	output logic [REGI_SIZE-1:0]             intOper2,
	output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1,
	output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper2,
	output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOperImm, vOperCop,
	output logic [REGI_BITS-1:0] intRegDest,
	output logic [VECT_BITS-1:0] vecRegDest, 
	output logic [1:0] cond,
	output logic enableAluInt,
	output logic enableAluV,
	output logic enableMem,
	output logic enableJump,
	output logic enableSwap,
	output logic flagEnd,
	output logic flagNop,
	output logic flagImm,
	output logic [7:0] ImmOut,
	output logic [2:0] aluOpcode,
	output logic [9:0] jumpAddress,
	output logic flagMemRead,
	output logic flagMemWrite,
	output logic [2:0] swapBitOrigin,
	output logic [2:0] swapBitDest,
	output logic isOper1V,
	output logic isOper2V,
	output logic isOper1Int,
	output logic isOper2Int,
	output logic writeResultInt,
	output logic writeResultV,
	output logic [3:0] alu_flags_o
);
	logic [VECT_BITS-1:0] voper1_p, voper2_p;
	logic [REGI_BITS-1:0] ioper1_p, ioper2_p;
	logic [REGI_SIZE-1:0] ioper1_data_p, ioper2_data_p;
	logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1_data_p, vOper2_data_p, vOperImm_p, vOperCop_p, vOperCop_p1, vOperCop_p2;

	decoder  #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
		miniDecoder(.clk(clk||rst), .instruction(instruction),
			.intOper1(ioper1_p), .intOper2(ioper2_p),
			.vOper1(voper1_p), 
			.vOper2(voper2_p), 
			.intRegDest(intRegDest),//aca usa este, pero tiene declarado tambien reg_dest_o
			.vRegDest(vecRegDest),//aca usa este, pero tiene declarado tambien vec_dest_o
			.cond(cond),
			.enableAluInt(enableAluInt), 
			.enableAluV(enableAluV), 
			.enableMem(enableMem), 
			.enableJump(enableJump), 
			.flagImm(flagImm), 
			.ImmOut(ImmOut),
			.jumpAddress(jumpAddress),
			.flagEnd(flagEnd),
			.flagNop(flagNop),
			.flagMemRead(flagMemRead),
			.flagMemWrite(flagMemWrite),
			.swapBitOrigin(swapBitOrigin),
			.swapBitDest(swapBitDest),
			.enableSwap(enableSwap),
			.aluOpcode(aluOpcode),
			.isOper1V(isOper1V),
			.isOper2V(isOper2V),
			.isOper1Int(isOper1Int),
			.isOper2Int(isOper2Int),
			.writeResultInt(writeResultInt),
			.writeResultV(writeResultV)
			);

	vRegisterFile #(ELEM_SIZE, VECT_SIZE, 2**VECT_BITS)
		vec_regfile(.clk(clk),
			.wEnable(vec_we_i),
			.voper1(voper1_p), .voper2(voper2_p), .vresult(vec_dest_i),
			.dataIn(vec_wd_i),
			.oper1(vOper1_data_p), 
			.oper2(vOper2_data_p)
		);

	dRegisterFile #(REGI_BITS, REGI_SIZE)
		int_regfile(.clk(clk),
			.we3(int_we_i),
			.ra1(ioper1_p), .ra2(ioper2_p), .wa3(int_dest_i),
			.pc(next_pc_i),
			.wd3(int_wd_i),
			.rd1(ioper1_data_p),
			.rd2(ioper2_data_p)
			);

	//intToVect vectorizer_reg(ioper1_data_p, vOperCop_p1);

	intToVect vectorizer_imm(ImmOut, vOperCop_p);

	//mux2 #(ELEM_SIZE) vec_selct(vOperCop_p1, vOperCop_p2, flagImm , vOperCop_p);

	dPipe #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
		idex_pipe(.clk_i(clk), .rst_i(rst),
			.intOper1_i(ioper1_data_p), 
			.intOper2_i(ioper2_data_p),
			.vecOper1_i(vOper1_data_p), 
			.vecOper2_i(vOper2_data_p),
			.vOperCop_i(vOperCop_p),
			.vOperImm_i(vOperImm_p),
			.alu_flags_i(alu_flags_i),
			.intOper1_o(intOper1), 
			.intOper2_o(intOper2),
			.vecOper1_o(vOper1), 
			.vecOper2_o(vOper2),
			.vOperCop_o(vOperCop),
			.vOperImm_o(vOperImm),
			.alu_flags_o(alu_flags_o)
			);
endmodule