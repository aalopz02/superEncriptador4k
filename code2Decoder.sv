module code2Decoder #(
    parameter I = 24, 
    parameter P = 16,
    parameter D = 32,
    parameter R = 5,
    parameter F = 3
) (
	 input logic         clk_i, rst_i,
     input logic         we3, 
     input logic [P-1:0] next_pc_i,
     input logic [I-1:0] instr_i,
     input logic [R-1:0] wa3,
    input  logic [D-1:0] wd3,
    output logic         op_o,
    output logic [F-1:0] funct3_o,
    output logic [R-1:0] rd_o,
    output logic [D-1:0] rs_o, rt_o,
    output logic [P-1:0] next_pc_o
);
    logic [D-1:0] rs, rt, ra1, ra2;
    assign ra1 = instr_i[R+F:F+1];
    code2Regfile icode2Regfile(clk_i, we3, instr_i[R+F:F+1], instr_i[R+R+F:R+F+1], wa3, wd3, 
                    rs, rt);
    code2Pipe icode2Pipe(clk_i, rst_i, next_pc_i, instr_i[0], instr_i[F:1], instr_i[R+R+R+F:R+R+F+1], rs, rt,
                        next_pc_o, op_o, funct3_o, rd_o, rs_o, rt_o);
    
endmodule