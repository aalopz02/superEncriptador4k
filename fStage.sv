module fStage #(parameter IWIDTH = 24, parameter PWIDTH = 16)
(
	 input logic              clk_i, rst_i,
     input logic [PWIDTH-1:0] next_pc_i,
    output logic [PWIDTH-1:0] next_pc_o,
    output logic [IWIDTH-1:0] instr_o
);
    logic [PWIDTH-1:0] actual_pc;

    flip_flop #(PWIDTH) pc(clk_i, rst_i, 
                           next_pc_i, 
                           actual_pc);
    adder #(PWIDTH) pc_adder(actual_pc, 4, 0, next_pc_o);
    imem instr_mem(actual_pc, instr_o);
    
endmodule