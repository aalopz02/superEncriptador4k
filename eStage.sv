module eStage #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk_i, rst_i,
	 input logic [REGI_SIZE-1:0] int_rsa_i,
	 input logic [REGI_SIZE-1:0] int_rsb_i,
	 input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_rsa_i,
	 input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_rsb_i,
     input logic [1:0] cond,
	 input logic enableAluInt,
	 input logic enableAluV,
	 input logic enableMem,
	 input logic enableJump,
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
    output logic             [REGI_SIZE-1:0] ialu_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o,
    output logic             [REGI_SIZE-1:0] iswa_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vswa_res_o,
    output logic                       [3:0] alu_flags_o
    
);

    // Scalar ALU
    alu #(REGI_SIZE) 
        fu_int_alu(.bus_a_i(int_rsa_i), 
        .bus_b_i(int_rsb_i),
        .control_i(aluOpcode),
        .bus_s_o(ialu_res_o),
        .flags_o(alu_flags_o)
        );

    // Vector ALU
    vAluBlock #(ELEM_SIZE, VECT_SIZE)
        fu_vec_alu(.clk(clk_i),
        .vectorOper1(vec_rsa_i),
        .vectorOper2(vec_rsb_i),
        .result(valu_res_o),
        .opCode(aluOpcode));
    
    // Scalar Swap
    singleSwapper fu_int_swa(.oper(ImmOut),
        .pos1(swapBitOrigin),
        .pos2(swapBitDest),
        .res(iswa_res_o)
        );
    
    // Vector Swap
    vSwapperBlock fu_vec_swa(.vOper(ImmOut),
        .dir1(swapBitOrigin),
        .dir2(swapBitDest),
        .res(vswa_res_o)
        );

    // TODO Cond Unit

    
endmodule