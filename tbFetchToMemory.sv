module tbFetchToMemory #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
)();
    logic                 clk, rst;
    logic [REGI_SIZE-1:0] next_pc_p1;

    // Fetch Var
    logic        int_we;
    logic [REGI_SIZE-1:0] int_a_i, int_wd_i;
    logic [REGI_SIZE-1:0] int_rd_o;
    logic [REGI_SIZE-1:0] next_pc_i, next_pc_o;
    logic [REGI_SIZE-1:0] instr_p, instr_o;

    // Decode Var
	 logic [REGI_BITS-1:0]             reg_dest_o;
	 logic [VECT_BITS-1:0]             vec_dest_o;
	 logic [REGI_SIZE-1:0]             intOper1;
	 logic [REGI_SIZE-1:0]             intOper2;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper2;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOperImm, vOperCop;
	 logic [REGI_BITS-1:0] intRegDest;
	 logic [VECT_BITS-1:0] vecRegDest; 
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
	 logic isOper1V;
	 logic isOper2V;
	 logic isOper1Int;
	 logic isOper2Int;
	 logic writeResultInt;
	 logic writeResultV;
	 logic [3:0] alu_flags_to_dec, alu_flags_to_exe;

    // Execute Var
     logic             [ELEM_SIZE-1:0] ialu_res_o;
     logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o;
     logic                             enableMem_o;
     logic                             enableReg_o;
	 logic                             enableJump_o;
     logic                             flagMemRead_o;
	 logic                             flagMemWrite_o;
     logic                             isOper1V_o;
	 logic isOper2V_o;
	 logic isOper1Int_o;
	 logic isOper2Int_o;
	 logic writeResultInt_o;
	 logic writeResultV_o;
     logic [REGI_BITS-1:0] intRegDest_o;
	 logic [VECT_BITS-1:0] vecRegDest_o, memo_res_o;

         // Memory Var
     logic                 enableReg_f;
	 logic                 enableJump_f;
     logic                 flagMemRead_f;
     logic                 flagEnd_f;
	 logic                 flagNop_f;
     logic           [9:0] jumpAddress_f;
     logic                 writeResultInt_f;
	 logic                 writeResultV_f;
     logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_rd_f;
     logic [REGI_BITS-1:0] intRegDest_f;
	 logic [VECT_BITS-1:0] vecRegDest_f, memo_res_f;
    

    fStage #(REGI_BITS, REGI_SIZE) 
        dut(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_o),
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
            .next_pc_i(next_pc_i),
            .int_dest_i(intRegDest_f),
            .vec_dest_i(vecRegDest_f),
            .int_we_i(writeResultInt_f),
            .vec_we_i(writeResultV_f),
            .reg_dest_o(reg_dest_o),
            .vec_dest_o(vec_dest_o),
            .vOper1(vOper1), 
            .vOper2(vOper2),
            .intOper1(intOper1), 
            .intOper2(intOper2), 
            .vOperImm(vOperImm), 
            .vOperCop(vOperCop),
            .alu_flags_i(alu_flags_to_dec),
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
            //.vRegDest(vRegDest),
            .enableSwap(enableSwap),
            .aluOpcode(aluOpcode),
            .isOper1V(isOper1V),
	        .isOper2V(isOper2V),
            .isOper1Int(isOper1Int),
            .isOper2Int(isOper2Int),
            .writeResultInt(writeResultInt),
            .writeResultV(writeResultV),
            .alu_flags_o(alu_flags_to_exe)
            );
    

    
    superExecute #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
        execute(.clk_i(clk), .rst_i(rst),
            .int_rsa_i(intOper1), 
            .int_rsb_i(intOper2),
            .vec_rsa_i(vOper1), 
            .vec_rsb_i(vOper2),
            .alu_flags_i(alu_flags_to_exe),
            .writeResultInt(writeResultInt),
            .writeResultV(writeResultV),
            .intRegDest_i(intRegDest),
            .vecRegDest_i(vecRegDest),

            .cond(cond),
            .enableAluInt(enableAluInt), 
            .enableAluV(enableAluV), 
            .enableMem(enableMem), 
            .enableJump(enableJump), 
            .enableReg(enableReg),
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
            .enableMem_o(enableMem_o),
            .enableReg_o(enableReg_o), 
            .enableJump_o(enableJump_o), 
            .flagMemRead_o(flagMemRead_o),
            .flagMemWrite_o(flagMemWrite_o),
            .alu_flags_o(alu_flags_to_dec),
            .writeResultInt_o(writeResultInt_o),
            .writeResultV_o(writeResultV_o),
            .intRegDest_o(intRegDest_o),
            .vecRegDest_o(vecRegDest_o),
            .memo_res_o(memo_res_o)
            );
    



    superMemory #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
            memory(.clk_i(clk), .rst_i(rst),
                .int_a_i(valu_res_o),
                .int_wd_i(memo_res_o),
                .enableMem(enableMem_o), 
                .enableJump(enableJump_o), 
                .enableReg(enableReg_o),
                .jumpAddress(jumpAddress_o),
                .flagEnd(flagEnd_o),
                .flagNop(flagNop_o),
                .flagMemRead(flagMemRead_o),
                .flagMemWrite(flagMemWrite_o),
                .writeResultInt(writeResultInt_o),
                .writeResultV(writeResultV_o),

                .int_rd_f(int_rd_f),
                .enableJump_f(enableJump_f), 
                .enableReg_f(enableReg_f),
                .jumpAddress_f(jumpAddress_f),
                .flagEnd_f(flagEnd_f),
                .flagNop_f(flagNop_f),
                .flagMemRead_f(flagMemRead),
                .writeResultInt_f(writeResultInt_f),
                .writeResultV_f(writeResultV_f),
                .intRegDest_f(intRegDest_f),
                .vecRegDest_f(vecRegDest_f),
                .memo_res_f(memo_res_f)
                );

    mux2 #(ELEM_SIZE) pc_selector(next_pc_i, jumpAddress_f, enableJump_f, next_pc_o);

    initial begin
        #0 
        rst <= 1;
        
        #50
        rst <= 0;
        next_pc_i <= 0;
    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end
endmodule