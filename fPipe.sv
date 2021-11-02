module fPipe #(    
    parameter REGI_BITS = 4,
    parameter REGI_SIZE = 16
)(
	 input logic                 clk_i, rst_i,
	 input logic [REGI_SIZE-1:0] next_pc_i,
     input logic [REGI_SIZE-1:0] instr_i,
    output logic [REGI_SIZE-1:0] next_pc_o,
    output logic [REGI_SIZE-1:0] instr_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            next_pc_o <= 0;
            instr_o <= 0;
        end
        else begin
            next_pc_o <= next_pc_i;
            instr_o <= instr_i;
        end
    end
endmodule