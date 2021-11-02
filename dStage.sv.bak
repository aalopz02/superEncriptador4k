module dStage #(
    parameter INST_SIZE = 16, 
    parameter ADDR_SIZE = 16,
    parameter VECT_CONT = 2,
    parameter REGI_CONT = 4,
    parameter VECT_SIZE = 64,
    parameter REGI_SIZE = 2**VECT_CONT,
    parameter IALU_CODE = 2,
    parameter COND_SIZE = 2
) (
	 input logic                 clk_i, rst_i,
     input logic [ADDR_SIZE-1:0] next_pc_i,
     input logic                  we3,
     input logic [INST_SIZE-1:0] instr_i,
     input logic [REGI_CONT-1:0] wa3,
     input logic [REGI_SIZE-1:0] wd3,
    output logic [INST_SIZE-1:0] next_pc_o,
    output logic           [3:0] funct4_o,
    output logic [REGI_SIZE-1:0] rs_o, rt_o
);

    dRegisterFile #(R, D)
        RegisterFile(clk_i, we3, 
                    ra1,//instr_i[R+F:F+1], 
                    ra2,//instr_i[R+R+F:R+F+1], 
                    wa3, 
                    wd3, 
                    rs_o, rt_o);

    //Todo Vector 
    
endmodule