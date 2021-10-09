module fPipe #(parameter IWIDTH = 24, parameter PWIDTH = 16)
(
	 input logic              clk_i, rst_i,
	 input logic [PWIDTH-1:0] next_pc_i,
     input logic [IWIDTH-1:0] instr_i,
    output logic [PWIDTH-1:0] next_pc_o,
    output logic [IWIDTH-1:0] instr_o
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