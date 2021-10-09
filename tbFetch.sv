module tbFetch();

    logic        clk, rst;
    logic [15:0] next_pc_i, next_pc_o;
    logic [15:0] next_pc_p1, next_pc_p2;
    logic [15:0] instr_o, instr_p;

    fiPipe #(16)
        if_pipe(.clk_i(clk), .rst_i(rst),
                .next_pc_i(next_pc_i),
                .next_pc_o(next_pc_p1)
                );

    fStage #(16, 16) 
        dut(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_p1),
            .next_pc_o(next_pc_p2),
            .instr_o(instr_p)
            );

    fPipe #(16, 16) 
        ifid_pipe(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_p2),
            .instr_i(instr_p),
            .next_pc_o(next_pc_i),
            .instr_o(instr_o)
            );
            
    
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