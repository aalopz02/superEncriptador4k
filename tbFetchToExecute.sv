module tbFetchToExecute #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
)();
    logic                 clk, rst;
    logic [REGI_SIZE-1:0] next_pc_p1, next_pc_p2, next_pc_p3;

    // Fetch Var
    logic        int_we;
    logic [REGI_SIZE-1:0] int_a_i, int_wd_i;
    logic [REGI_SIZE-1:0] int_rd_o;
    logic [REGI_SIZE-1:0] next_pc_i, next_pc_o;
    logic [REGI_SIZE-1:0] instr_o;

    // Decode Var
	logic [REGI_SIZE-1:0]             intOper1;
	logic [REGI_SIZE-1:0]             intOper2;
	logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1;
	logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper2;
	logic [1:0] cond;
	logic enableAluInt;
	logic enableAluV;
	logic enableMem;
	logic enableJump;
	logic enableSwap;
	logic flagEnd;
	logic flagNop;
	logic flagImm;
	logic [7:0] ImmOut;
	logic [2:0] aluOpcode;
	logic [9:0] jumpAddress;
	logic flagMemRead;
	logic flagMemWrite;
	logic [2:0] swapBitOrigin;
	logic [2:0] swapBitDest;

    // Execute Var
    logic             [REGI_SIZE-1:0] ialu_res_o;
    logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o;
    logic             [REGI_SIZE-1:0] iswa_res_o;
    logic [(ELEM_SIZE*VECT_SIZE)-1:0] vswa_res_o;
    logic                       [3:0] alu_flags;
    
    fStage #(REGI_BITS, REGI_SIZE) 
        dut(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_i),
            .next_pc_o(next_pc_p1),
            .instr_o(instr_p)
            );

    fPipe #(REGI_BITS, REGI_SIZE) 
        ifid_pipe(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_p1),
            .instr_i(instr_p),
            .next_pc_o(next_pc_i),
            .instr_o(instr_o)
            );

    superDecoder #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
        decoder(.clk(clk||rst), .rst(rst), 
            .instruction(instr_o),
            .intOper1(intOper1), .intOper2(intOper2),
            .next_pc_i(next_pc_o),
            .vOper1(vOper1), 
            .vOper2(vOper2), 
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
            .intRegDest(intRegDest),
            .vRegDest(vRegDest),
            .enableSwap(enableSwap),
            .aluOpcode(aluOpcode)
            );
    
    superExecute #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
        execute(.clk_i(clk), .rst_i(rst),
            .int_rsa_i(int_rsa_i), 
            .int_rsb_i(int_rsb_i),
            .vec_rsa_i(vec_rsa_i), 
            .vec_rsb_i(vec_rsb_i),
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
            .ialu_res_o(ialu_res_o),
            .valu_res_o(valu_res_o),
            .iswa_res_o(iswa_res_o),
            .vswa_res_o(vswa_res_o)
            );
    
    initial begin
        #0 
        rst <= 1;
        
        #50
        rst <= 0;
    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end
endmodule