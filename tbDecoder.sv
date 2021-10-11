module tbDecoder#(
    parameter I = 16, 
    parameter P = 16,
    parameter D = 16,
    parameter R = 4,
    parameter F = 4
) ();
	logic         clk, rst;
    logic [P-1:0] next_pc_i, next_pc_p;
    logic         we3;
    logic [I-1:0] instr_i;
    logic [R-1:0] wa3;
    logic [D-1:0] wd3;

    logic [P-1:0] next_pc_o;
    logic [F-1:0] funct4_o, funct4_p;
    logic [D-1:0] rs_o, rt_o, rs_p, rt_p;

    initial begin
        #0 
        rst <= 1;
        
        #50
        rst <= 0;
        wa3 <= 0;
        wd3 <= 0;
        we3 <= 0;
        next_pc_p <= 0;
        funct4_p <= 0;
        rs_p <= 0;
        rt_p <= 0;

        #60;
        next_pc_i <= 42;
        instr_i <= 2473; // 1001 1010 1001

        #70;
        next_pc_i <= 69;
        instr_i <= 1359; // 0101 0100 1111

    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end

    dStage #(I, P, D, R, F)
        dut(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_i),
            .we3(we3),
            .instr_i(instr_i),
            .wa3(wa3),
            .wd3(wd3),
            .next_pc_o(next_pc_p),
            .funct4_o(funct4_p),
            .rs_o(rs_p), .rt_o(rt_p)
            );

    dPipe #(P, D, R, F)
        idex_pipe(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_p),
            .funct4_i(funct4_p),
            .rs_i(rs_p), .rt_i(rt_p),
            .next_pc_o(next_pc_o),
            .funct4_o(funct4_o),
            .rs_o(rs_o), .rt_o(rt_o)
            );
endmodule