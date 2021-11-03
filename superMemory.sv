module superMemory #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk_i, rst_i,
     input logic                 enableMem,
     input logic                 enableReg,
	 input logic                 enableJump,
     input logic                 flagMemRead,
	 input logic                 flagMemWrite,
     input logic                 flagEnd,
	 input logic                 flagNop,
     input logic                 writeResultInt,
	 input logic                 writeResultV,
     input logic           [9:0] jumpAddress,
     input logic [REGI_BITS-1:0] intRegDest,
	 input logic [VECT_BITS-1:0] vecRegDest,
     input logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_a_i, int_wd_i,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_rd_f,
    output logic                 enableReg_f,
	output logic                 enableJump_f,
    output logic                 flagMemRead_f,
    output logic                 flagMemWrite_f,
    output logic                 flagEnd_f,
	output logic                 flagNop_f,
    output logic           [9:0] jumpAddress_f,
    output logic [REGI_BITS-1:0] intRegDest_f,
	output logic [VECT_BITS-1:0] vecRegDest_f, 
    output logic                 writeResultInt_f,
	output logic                 writeResultV_f
    
);
    logic [(ELEM_SIZE*VECT_SIZE)-1:0] in_rd_p;

    //  VEC Memoryy
    mStage #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        mem_stage(.clk_i(clk_i), .rst_i(rst_i),
            .int_we_i(flagMemWrite_i), // Enable Write
            .int_a_i(int_a_i),
            .int_wd_i(int_wd_i),
            .int_rd_o(in_rd_p)
            );

    mPipe #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        exmem_pipe(.clk_i(clk_i), .rst_i(rst_i),
            .int_rd_i(in_rd_p),
            .enableReg_i(enableReg),
            .enableJump_i(enableJump),
            .flagMemRead_i(flagMemRead),
            .flagMemWrite_i(flagMemWrite),
            .flagEnd_i(flagEnd),
            .flagNop_i(flagNop),
            .jumpAddress_i(jumpAddress),
            .intRegDest_i(intRegDest),
            .vecRegDest_i(vecRegDest),
            .writeResultInt_i(writeResultInt),
            .writeResultV_i(writeResultV),

            .int_rd_o(int_rd_f),
            .enableReg_o(enableReg_f),
            .enableJump_o(enableJump_f),
            .flagMemRead_o(flagMemRead_f),
            .flagMemWrite_o(flagMemWrite_f),
            .flagEnd_o(flagEnd_f),
            .flagNop_o(flagNop_f),
            .jumpAddress_o(jumpAddress_f),
            .intRegDest_o(intRegDest_f),
            .vecRegDest_o(vecRegDest_f),
            .writeResultInt_o(writeResultInt_f),
            .writeResultV_o(writeResultV_f)
            );
            
endmodule