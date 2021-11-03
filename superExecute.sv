module superExecute #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                             clk_i, rst_i,
	 input logic             [REGI_SIZE-1:0] int_rsa_i,
	 input logic             [REGI_SIZE-1:0] int_rsb_i,
     input logic [REGI_SIZE-1:0]             int_dest_i,
     input logic [VECT_BITS-1:0]             vec_dest_i,
	 input logic [(REGI_SIZE*VECT_SIZE)-1:0] vec_rsa_i,
	 input logic [(REGI_SIZE*VECT_SIZE)-1:0] vec_rsb_i,
     input logic [(REGI_SIZE*VECT_SIZE)-1:0] vec_imm_i,
     input logic [(REGI_SIZE*VECT_SIZE)-1:0] vec_cop_i,
     input logic [1:0] cond,
	 input logic enableAluInt,
	 input logic enableAluV,
	 input logic enableMem,
	 input logic enableJump,
     input logic enableReg,
	 input logic enableSwap,
	 input logic flagEnd,
	 input logic flagNop,
	 input logic flagImm,
     input logic isOper1V,
	 input logic isOper2V,
     input logic isOper1Int,
     input logic isOper2Int,
     input logic writeResultInt,
	 input logic writeResultV,
	 input logic [7:0] ImmOut,
	 input logic [2:0] aluOpcode,
	 input logic [9:0] jumpAddress,
	 input logic flagMemRead,
	 input logic flagMemWrite,
	 input logic [2:0] swapBitOrigin,
	 input logic [2:0] swapBitDest,
     input logic [REGI_BITS-1:0] intRegDest_i,
	 input logic [VECT_BITS-1:0] vecRegDest_i,
     input logic                       [1:0] alu_flags_i,
    output logic             [REGI_SIZE-1:0] ialu_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o, mem_res_o,
    output logic                             enableMem_o,
    output logic                             enableReg_o,
	output logic                             enableJump_o,
    output logic                             flagMemRead_o,
	output logic                             flagMemWrite_o,
    output logic                             isOper1V_o,
	output logic isOper2V_o,
	output logic isOper1Int_o,
	output logic isOper2Int_o,
	output logic writeResultInt_o,
	output logic writeResultV_o,
    output logic                       [1:0] alu_flags_o,
    output logic [REGI_BITS-1:0] intRegDest_o,
	output logic [VECT_BITS-1:0] vecRegDest_o
);

    logic [REGI_SIZE-1:0] ialu_res_p;
    logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_p;

    
    eStage #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        ex_stage(.clk_i(clk_i), .rst_i(rst_i),
            .int_rsa_i(int_rsa_i), 
				.int_rsb_i(int_rsb_i),
            .vec_rsa_i(vec_rsa_i), 
				.vec_rsb_i(vec_rsb_i),
            .vec_imm_i(vec_imm_i),
            .vec_cop_i(vec_cop_i),
            .alu_flags_i(alu_flags_i),
            .cond(cond),
            .enableAluInt(enableAluInt),
            .enableMem(enableMem),
            .enableSwap(enableSwap),
            .enableJump(enableJump),
            .enableAluV(enableAluV),
            .flagEnd(flagEnd),
            .flagNop(flagNop),
            .flagImm(flagImm),
				.isIntOper1(isOper1Int),
            .ImmOut(ImmOut),
            .aluOpcode(aluOpcode),
            .jumpAddress(jumpAddress),
            .swapBitOrigin(swapBitOrigin),
            .swapBitDest(swapBitDest),
            .flagMemRead(flagMemRead_p),
            .flagMemWrite(flagMemWrite_p),
            .ialu_res_o(ialu_res_p),
            .valu_res_o(valu_res_p),
            .alu_flags_o(alu_flags_o)
            );

    ePipe #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        exmen_pipe(.clk_i(clk_i), .rst_i(rst_i),
            .ialu_res_i(ialu_res_p),
            .valu_res_i(valu_res_p),
            .enableMem_i(enableMem),
            .enableReg_i(enableReg),
            .enableJump_i(enableJump),
            .flagMemRead_i(flagMemRead),
            .flagMemWrite_i(flagMemWrite),
            .isOper1V_i(isOper1V),
            .isOper2V_i(isOper2V),
            .isOper1Int_i(isOper1Int),
            .isOper2Int_i(isOper2Int),
            .writeResultInt_i(writeResultInt),
            .writeResultV_i(writeResultV),
            .ialu_res_o(ialu_res_o),
            .valu_res_o(valu_res_o),
            .enableMem_o(enableMem_o),
            .enableReg_o(enableReg_o),
            .enableJump_o(enableJump_o),
            .flagMemRead_o(flagMemRead_o),
            .flagMemWrite_o(flagMemWrite_o),
            .isOper1V_o(isOper1V_o),
            .isOper2V_o(isOper2V_o),
            .isOper1Int_o(isOper1Int_o),
            .isOper2Int_o(isOper2Int_o),
            .writeResultInt_o(writeResultInt_o),
            .writeResultV_o(writeResultV_o)
            );
             
endmodule