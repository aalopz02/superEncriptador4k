module fStage #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8,
    parameter ADDI_SIZE = 1
)
(
	 input logic                 clk_i, rst_i,
     input logic [REGI_SIZE-1:0] next_pc_i,
    output logic [REGI_SIZE-1:0] next_pc_o,
    output logic [REGI_SIZE-1:0] instr_o
);
    logic [REGI_SIZE-1:0] actual_pc;
    
    flip_flop #(REGI_SIZE) pc(clk_i, rst_i, 
                           next_pc_i, 
                           actual_pc);
    adder #(REGI_SIZE) pc_adder(actual_pc, ADDI_SIZE, 0, next_pc_o);
    imem instr_mem(actual_pc, instr_o);
    
endmodule