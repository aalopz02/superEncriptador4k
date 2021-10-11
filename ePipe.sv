module ePipe #(parameter PWIDTH = 16)
(
	 input logic              clk_i, rst_i,
	 input logic [PWIDTH-1:0] next_pc_i,
    output logic [PWIDTH-1:0] next_pc_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            next_pc_o <= 0;
        end
        else begin
            next_pc_o <= next_pc_i;
        end
    end
endmodule