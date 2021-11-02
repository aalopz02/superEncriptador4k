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
     input logic [REGI_SIZE-1:0] int_a_i, int_wd_i,
    output logic [REGI_SIZE-1:0] int_rd_o,
    output logic                 enableReg_o,
	output logic                 enableJump_o,
    output logic                 flagMemWrite_o
);
    logic [REGI_SIZE-1:0] int_rd_p;

    // TODO VEC Memory

    // Int Memory
    mStage #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        mem_stage(.clk_i(clk_i), .rst_i(rst_i),
            .int_we_i(flagMemWrite_i), // Enable Write
            .int_a_i(int_a_i),
            .int_wd_i(int_wd_i),
            .int_rd_o(int_rd_p)
            );

    mPipe #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE) 
        exmem_pipe(.clk_i(clk_i), .rst_i(rst_i),
            .int_rd_i(int_rd_p),
            .int_rd_o(int_rd_o)
            );
            
endmodule