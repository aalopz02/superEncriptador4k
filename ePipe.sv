module ePipe #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk_i, rst_i,
     input logic             [REGI_SIZE-1:0] ialu_res_i, iswa_res_i,
     input logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_i, vswa_res_i,
     input logic                             enableMem_i,
     input logic                             enableReg_i,
	 input logic                             enableJump_i,
     input logic                             flagMemRead_i,
	 input logic                             flagMemWrite_i,
    output logic             [REGI_SIZE-1:0] ialu_res_o, iswa_res_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o, vswa_res_o,
    output logic                             enableMem_o,
    output logic                             enableReg_o,
	output logic                             enableJump_o,
    output logic                             flagMemRead_o,
	output logic                             flagMemWrite_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            ialu_res_o <= 0;
            iswa_res_o <= 0;
            valu_res_o <= 0;
            vswa_res_o <= 0;
            enableMem_o <= 0;
            enableReg_o <= 0;
            enableJump_o <= 0;
            flagMemRead_o <= 0;
            flagMemWrite_o <= 0;
        end
        else begin
			ialu_res_o <= ialu_res_i;
            iswa_res_o <= iswa_res_i;
			valu_res_o <= valu_res_i;
            vswa_res_o <= vswa_res_i;
            enableMem_o <= enableMem_i;
            enableReg_o <= enableReg_i;
            enableJump_o <= enableJump_i;
            flagMemRead_o <= flagMemRead_i;
            flagMemWrite_o <= flagMemWrite_i;
        end
    end
endmodule