module code2Pipe #(
    parameter P = 16,
    parameter D = 32,
    parameter R = 5,
    parameter F = 3
) (
	 input logic         clk_i, rst_i,
     input logic [P-1:0] next_pc_i,
     input logic         op_i,
     input logic [F-1:0] funct3_i,
     input logic [R-1:0] rd_i,
     input logic [D-1:0] rs_i, rt_i,
    output logic [P-1:0] next_pc_o,
    output logic         op_o,
    output logic [F-1:0] funct3_o,
    output logic [R-1:0] rd_o,
    output logic [D-1:0] rs_o, rt_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            next_pc_o <= 0;
            op_o <= 0;
            funct3_o <= 0;
            rd_o <= 0;
            rs_o <= 0;
            rt_o <= 0;
        end
        else begin
            next_pc_o <= next_pc_i;
            op_o <= op_i;
            funct3_o <= funct3_i;
            rd_o <= rd_i;
            rs_o <= rs_i;
            rt_o <= rt_i;
        end
    end
endmodule