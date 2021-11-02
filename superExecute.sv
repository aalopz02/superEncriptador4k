module superExecute #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk_i, rst_i,
	 input logic             [REGI_SIZE-1:0] int_rsa_i,
	 input logic             [REGI_SIZE-1:0] int_rsb_i,
	 input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_rsa_i,
	 input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_rsb_i,
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
	 input logic [7:0] ImmOut,
	 input logic [2:0] aluOpcode,
	 input logic [9:0] jumpAddress,
	 input logic flagMemRead,
	 input logic flagMemWrite,
	 input logic [2:0] swapBitOrigin,
	 input logic [2:0] swapBitDest,
     input logic                       [3:0] alu_flags_i,
    output logic             [REGI_SIZE-1:0] ialu_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o,
    output logic             [REGI_SIZE-1:0] iswa_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vswa_res_o,
    output logic                             enableMem_o,
    output logic                             enableReg_o,
	output logic                             enableJump_o,
    output logic                             flagMemRead_o,
	output logic                             flagMemWrite_o,
    output logic                       [3:0] alu_flags_o
);

    logic [REGI_SIZE-1:0] ialu_res_p, iswa_res_p;
    logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_p, vswa_res_p;
    logic                             enableMem_p;
    logic                             enableReg_p;
    logic                             enableJump_p;
    logic                             flagMemRead_p;
	logic                             flagMemWrite_p;

    eStage #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        ex_stage(.clk_i(clk_i), .rst_i(rst_i),
            .int_rsa_i(int_rsa_i), .int_rsb_i(int_rsb_i),
            .vec_rsa_i(vec_rsa_i), .vec_rsb_i(vec_rsb_i),
            .cond(cond),
            .aluOpcode(aluOpcode),
            .ialu_res_o(ialu_res_p),
            .valu_res_o(valu_res_p),
            .iswa_res_o(iswa_res_p),
            .vswa_res_o(vswa_res_p),
            .alu_flags_o(alu_flags_o)
            );

    ePipe #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        exmen_pipe(.clk_i(clk_i), .rst_i(rst_i),
            .ialu_res_i(ialu_res_p),
            .valu_res_i(valu_res_p),
            .iswa_res_i(iswa_res_p),
            .vswa_res_i(vswa_res_p),
            .enableMem_i(enableMem_p),
            .enableReg_i(enableReg_p),
            .enableJump_i(enableJump_p),
            .flagMemRead_i(flagMemRead_p),
            .flagMemWrite_i(flagMemWrite_p),
            .ialu_res_o(ialu_res_o),
            .valu_res_o(valu_res_o),
            .iswa_res_o(iswa_res_o),
            .vswa_res_o(vswa_res_o),
            .enableMem_o(enableMem_o),
            .enableReg_o(enableReg_o),
            .enableJump_o(enableJump_o),
            .flagMemRead_o(flagMemRead_o),
            .flagMemWrite_o(flagMemWrite_o)
            );
             
endmodule