module mPipe #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                 clk_i, rst_i,
     input logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_rd_i,
     input logic                 enableMem_i,
     input logic                 enableReg_i,
	 input logic                 enableJump_i,
     input logic                 flagMemRead_i,
	 input logic                 flagMemWrite_i,
     input logic                 writeResultInt_i,
	 input logic                 writeResultV_i,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] int_rd_o,
    output logic                 enableMem_o,
    output logic                 enableReg_o,
	 output logic                 enableJump_o,
     output logic                 flagMemRead_o,
	 output logic                 flagMemWrite_o,
     output logic                 writeResultInt_o,
	 output logic                 writeResultV_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            int_rd_o <= 0;
            enableMem_o <= 0;
            enableReg_o <= 0;
            enableJump_o <= 0;
            flagMemRead_o <= 0;
            flagMemWrite_o <= 0;
            writeResultInt_o <= 0;
            writeResultV_o <= 0;
        end
        else begin
			int_rd_o <= int_rd_i;
            int_rd_o <= int_rd_i;
            enableMem_o <= enableMem_i;
            enableReg_o <= enableReg_i;
            enableJump_o <= enableJump_i;
            flagMemRead_o <= flagMemRead_i;
            flagMemWrite_o <= flagMemWrite_i;
            writeResultInt_o <= writeResultInt_i;
            writeResultV_o <= writeResultV_i;
        end
    end
endmodule