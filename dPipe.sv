module dPipe #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	 input logic                             clk_i, rst_i,
	 input logic             [REGI_SIZE-1:0] intOper1_i, intOper2_i,
     input logic [(ELEM_SIZE*VECT_SIZE)-1:0] vecOper1_i, vecOper2_i, vOperCop_i, vOperImm_i,
     input logic                       [1:0] alu_flags_i,
    output logic             [REGI_SIZE-1:0] intOper1_o, intOper2_o,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] vecOper1_o, vecOper2_o, vOperCop_o, vOperImm_o,
    output logic                       [1:0] alu_flags_o
);
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
            intOper1_o <= 0;
            intOper2_o <= 0;
            vecOper1_o <= 0;
            vecOper2_o <= 0;
            vOperCop_o <= 0;
            vOperImm_o <= 0;
            alu_flags_o <= 0;
        end
        else begin
            intOper1_o <= intOper1_i;
            intOper2_o <= intOper2_i;
            vecOper1_o <= vecOper1_i;
            vecOper2_o <= vecOper2_i;
            vOperCop_o <= vOperCop_i;
            vOperImm_o <= vOperImm_i;
            alu_flags_o <= alu_flags_i;
        end
    end
endmodule