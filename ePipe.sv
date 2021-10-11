module ePipe #(
    parameter D = 16
) (
	 input logic         clk_i, rst_i,
     input logic [D-1:0] alu_res_i,
    output logic [D-1:0] alu_res_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            alu_res_o <= 0;
        end
        else begin
            alu_res_o <= alu_res_i;
        end
    end
endmodule