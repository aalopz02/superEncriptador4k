module mStage #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk_i, rst_i, int_we_i,
     input logic [REGI_SIZE-1:0] int_a_i, int_wd_i,
    output logic [REGI_SIZE-1:0] int_rd_o
);
    dmem int_mem(clk_i, int_we_i, int_a_i, int_wd_i, int_rd_o); 

    //vmem vec_men(clk_i, we,)
    
endmodule