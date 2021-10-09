module tbDecoder#(
    parameter I = 24, 
    parameter P = 16,
    parameter D = 32,
    parameter R = 5,
    parameter F = 3
) ();

	logic         clk, rst;
    logic         we3;
    logic [P-1:0] next_pc_i;
    logic [I-1:0] instr_i;
    logic [R-1:0] wa3;
    logic [D-1:0] wd3;
    logic         op_o;
    logic [F-1:0] funct3_o;
    logic [R-1:0] rd_o;
    logic [D-1:0] rs_o, rt_o;
    logic [P-1:0] next_pc_o;
            
    initial begin
        #0 
        rst <= 1;
        
        #50
        rst <= 0;

        #50;
        next_pc_i <= 42;
        instr_i <= 3673; // 00111001011001 > 3673
        wa3 <= 0;
        wd3 <= 0;
    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end

     code2Pipe dut(clk, rst, we3, next_pc_i, instr_i, wa3, wd3, 
                op_o, funct3_o, rd_o, rs_o, rt_o, next_pc_o);
endmodule