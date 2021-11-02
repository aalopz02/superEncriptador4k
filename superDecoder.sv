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
	 input logic [REGI_SIZE-1:0]             int_wd_i,
	 input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_wd_i,
	output logic [REGI_SIZE-1:0]             intOper1,
	output logic [REGI_SIZE-1:0]             intOper2,
	output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1,
	output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper2,
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
	output logic [2:0] swapBitDest
);
	logic [VECT_BITS-1:0] voper1_p, voper2_p;
	logic [REGI_BITS-1:0] ioper1_p, ioper2_p;
	logic [REGI_SIZE-1:0] ioper1_data_p, ioper2_data_p;
	logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1_data_p, vOper2_data_p;

	decoder  #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
		miniDecoder(.clk(clk||rst), .instruction(instruction),
			.intOper1(ioper1_p), .intOper2(ioper2_p),
			.vOper1(voper1_p), 
			.vOper2(voper2_p), 
			.intRegDest(intRegDest),
			.vRegDest(vecRegDest),
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
			.aluOpcode(aluOpcode)
			);

	vRegisterFile #(ELEM_SIZE, VECT_SIZE, 2**VECT_BITS)
		vec_regfile(.clk(clk),
			.wEnable(vec_we_i),
			.voper1(voper1_p), 
			.voper2(voper2_p),
			.vresult(vecRegDest),
			.dataIn(vec_wd_i),
			.oper1(vOper1_data_p), 
			.oper2(vOper2_data_p)
		);

	dRegisterFile #(REGI_BITS, REGI_SIZE)
		int_regfile(.clk(clk),
			.we3(int_we_i),
			.ra1(ioper1_p), .ra2(ioper2_p), .wa3(intRegDest),
			.pc(next_pc_i),
			.wd3(int_wd_i),
			.rd1(ioper1_data_p),
			.rd2(ioper2_data_p)
			);

	dPipe #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
		idex_pipe(.clk_i(clk), .rst_i(rst),
			.intOper1_i(ioper1_data_p), 
			.intOper2_i(ioper2_data_p),
			.vecOper1_i(vOper1_data_p), 
			.vecOper2_i(vOper2_data_p),
			.intOper1_o(intOper1), 
			.intOper2_o(intOper2),
			.vecOper1_o(vOper1), 
			.vecOper2_o(vOper2)
			);
endmodule