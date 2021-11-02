module tbFetchToMemory #(
    parameter REGI_CONT = 4,
    parameter VECT_CONT = 2,
    parameter REGI_SIZE = 2**REGI_CONT,
    parameter VECT_SIZE = 2**VECT_CONT
)();
    logic        clk, rst;
    logic        int_we;
    logic [REGI_SIZE-1:0] int_a_i, int_wd_i,
    logic [REGI_SIZE-1:0] next_pc_i,
    logic [REGI_SIZE-1:0] next_pc_o,
    logic [REGI_SIZE-1:0] int_rd_o
    logic [REGI_SIZE-1:0] next_pc_i, next_pc_o;
    logic [REGI_SIZE-1:0] next_pc_p1, next_pc_p2, next_pc_p3;
    logic [REGI_SIZE-1:0] instr_o, instr_p;

    fiPipe #(REGI_SIZE)
        if_pipe(.clk_i(clk), .rst_i(rst),
                .next_pc_i(next_pc_i),
                .next_pc_o(next_pc_p1)
                );

    fStage #(REGI_SIZE) 
        dut(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_i),
            .next_pc_o(next_pc_p1),
            .instr_o(instr_p)
            );

    fPipe #(REGI_SIZE) 
        ifid_pipe(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_p1),
            .instr_i(instr_p),
            .next_pc_o(next_pc_i),
            .instr_o(instr_o)
            );
            
    
    superDecoder  dStage(clk||res, instr_o);

    superMemory #()
        memo

    // TOOD

    initial begin
        #0 
        rst <= 1;
        next_pc_o = 0;
        
        #50
        rst <= 0;
    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end
endmodule