module mPipe #(
    parameter REGI_CONT = 4,
    parameter VECT_CONT = 2,
    parameter MEMO_WIDTH = 16, 
    parameter MEMO_SLOTS = 16,
    parameter REGI_SIZE = 2**REGI_CONT,
    parameter VECT_SIZE = 2**VECT_CONT
) (
	 input logic                 clk_i, rst_i,
     input logic [REGI_SIZE-1:0] int_rd_i,
     input logic [REGI_SIZE-1:0] next_pc_i,
    output logic [REGI_SIZE-1:0] next_pc_o,
    output logic [REGI_SIZE-1:0] int_rd_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            next_pc_o <= 0;
            int_rd_o <= 0;
        end
        else begin
            next_pc_o <= next_pc_i;
			int_rd_o <= int_rd_i;
        end
    end
endmodule