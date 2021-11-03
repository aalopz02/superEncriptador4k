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
    input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_imm_i,
    input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_cop_i,
    input logic [1:0] cond,
	 input logic enableAluInt,
	 input logic enableAluV,
	 input logic enableMem,
	 input logic enableJump,
	 input logic enableSwap,
	 input logic flagEnd,
	 input logic flagNop,
	 input logic flagImm,
	 input logic isIntOper1,
	 input logic [7:0] ImmOut,
	 input logic [2:0] aluOpcode,
	 input logic [9:0] jumpAddress,
	 input logic flagMemRead,
	 input logic flagMemWrite,
	 input logic [2:0] swapBitOrigin,
	 input logic [2:0] swapBitDest,
    input logic [1:0] alu_flags_i,
    output logic [REGI_SIZE-1:0] ialu_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o, mem_res_o,
    output logic [1:0] alu_flags_o
    
);
    logic signal_branch;
	 logic             [REGI_SIZE-1:0] int_input, iswa_res, ialu_out;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vec_input, vswa_res, valu_out;
	 
    mux2 #(REGI_SIZE) int_selector(int_rsa_i, ImmOut, flagImm, int_input);
    
    // Scalar ALU
    alu #(REGI_SIZE) 
        fu_int_alu(.bus_a_i(int_rsa_i), 
        .bus_b_i(int_input),
        .control_i(aluOpcode),
        .bus_s_o(ialu_out),
        .flags_o(alu_flags_o)
        );

	 logic [15:0] extendedImm;
	 logic [63:0] vectorOutImmConv = 64'd0;
	 //logic [63:0] vectorOutRegConv = 64'd0;
	 logic [63:0] elVOper2;
	 
	 
    intToVect immConv(extendedImm,vectorOutImmConv);
	 //intToVect regConv(int_input,vectorOutRegConv);
    //mux2 #(ELEM_SIZE) vec_selector(vec_rsb_i, ImmOut, flagImm, vec_input);
	 
    assign elVOper2 = (flagImm == 1'b1) ? vectorOutImmConv : 64'hFFFFFFFFFFFFFFFF;
	assign extendedImm[7:0] = ImmOut;
	assign extendedImm[15:8] = 8'd0;
	assign mem_res_o = vec_rsb_i;
    // Vector ALU
    vAluBlock #(ELEM_SIZE, VECT_SIZE)
        fu_vec_alu(.clk(clk_i),
        .vectorOper1(vec_rsa_i),
        .vectorOper2(elVOper2),
        .result(valu_out),
        .opCode(aluOpcode));
    
    // Scalar Swap
    singleSwapper fu_int_swa(.clk(clk_i),
        .oper(int_rsa_i),
        .pos1(swapBitOrigin),
        .pos2(swapBitDest),
        .res(iswa_res)
        );
    mux2 #(REGI_SIZE) int_selector_2(ialu_out, iswa_res, enableSwap, ialu_res_o);
	 
    // Vector Swap
    vSwapperBlock fu_vec_swa(.clk(clk_i),
        .vOper(vec_rsa_i),
        .dir1(swapBitOrigin),
        .dir2(swapBitDest),
        .res(vswa_res)
        );
    mux2 #(ELEM_SIZE*VECT_SIZE) vec_selector_2(valu_out, vswa_res, enableSwap, valu_res_o);
    
    // Cond Unit
    condUnit cond_unit(clk_i, cond, alu_flags_i, signal_branch);

    
endmodule