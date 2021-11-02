module superFetch #(
    parameter REGI_BITS = 4,
    parameter REGI_SIZE = 16
) (
	 input logic                 clk_i, rst_i,
     input logic [REGI_SIZE-1:0] next_pc_i,
    output logic [REGI_SIZE-1:0] next_pc_o,
    output logic [REGI_SIZE-1:0] instr_o
);

    logic [REGI_SIZE-1:0] next_pc_p;
    logic [REGI_SIZE-1:0] instr_p;

    fStage #(REGI_BITS, REGI_SIZE) 
        stage(.clk_i(clk_i), .rst_i(rst_i),
            .next_pc_i(next_pc_i),
            .next_pc_o(next_pc_p),
            .instr_o(instr_p)
            );

    fPipe #(REGI_BITS, REGI_SIZE) 
        ifid_pipe(.clk_i(clk), .rst_i(rst_i),
            .next_pc_i(next_pc_p),
            .instr_i(instr_p),
            .next_pc_o(next_pc_o),
            .instr_o(instr_o)
            );
            
endmodule