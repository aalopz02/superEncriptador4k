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
     input logic                 enableMem_i,
     input logic                 enableReg_i,
	 input logic                 enableJump_i,
     input logic                 flagMemRead_i,
	 input logic                 flagMemWrite_i,
     input logic                 writeResultInt_i,
	 input logic                 writeResultV_i,
     input logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_a_i, int_wd_i,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_rd_o,
    output logic                 enableReg,
	output logic                 enableJump,
    output logic                 flagMemRead,
    output logic                 writeResultInt,
	output logic                 writeResultV,
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
            .int_rd_o(int_rd_o),
            .enableReg_i(enableReg_i),
            .enableJump_i(enableJump_i),
            .flagMemRead_i(flagMemRead_i),
            .writeResultInt_i(writeResultInt_i),
            .writeResultV_i(writeResultV_i),
            .enableReg_o(enableReg),
            .enableJump_o(enableJump),
            .flagMemRead_o(flagMemRead),
            .writeResultInt_o(writeResultInt),
            .writeResultV_o(writeResultV),
            );
            
endmodule