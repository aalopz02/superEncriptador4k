module dStage #(
    parameter I = 16, 
    parameter P = 16,
    parameter D = 16,
    parameter R = 4,
    parameter F = 4
) (
	 input logic         clk_i, rst_i,
     input logic [P-1:0] next_pc_i,
     input logic         we3,
     input logic [I-1:0] instr_i,
     input logic [R-1:0] wa3,
     input logic [D-1:0] wd3,
    output logic [P-1:0] next_pc_o,
    output logic [F-1:0] funct4_o,
    output logic [D-1:0] rs_o, rt_o
);
    logic [F-1:0] ra1, ra2;
    assign ra1 = instr_i[R+F:F];
    assign ra2 = instr_i[R+R+F:R+F];
    assign next_pc_o = next_pc_i;
    assign funct4_o = instr_i[F:0];

    dRegisterFile #(R, D)
        RegisterFile(clk_i, we3, 
                    ra1,//instr_i[R+F:F+1], 
                    ra2,//instr_i[R+R+F:R+F+1], 
                    wa3, 
                    wd3, 
                    rs_o, rt_o);
    
endmodule