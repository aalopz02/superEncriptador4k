module dPipe #(
    parameter P = 16,
    parameter D = 16,
    parameter R = 5,
    parameter F = 4
) (
	 input logic         clk_i, rst_i,
     input logic [P-1:0] next_pc_i,
     input logic [F-1:0] funct4_i,
     input logic [D-1:0] rs_i, rt_i,
    output logic [P-1:0] next_pc_o,
    output logic [F-1:0] funct4_o,
    output logic [D-1:0] rs_o, rt_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            next_pc_o <= 0;
            funct4_o <= 0;
            rs_o <= 0; rt_o <= 0;
        end
        else begin
            next_pc_o <= next_pc_i;
            funct4_o <= funct4_i;
            rs_o <= rs_i; rt_o <= rt_i;
        end
    end
endmodule