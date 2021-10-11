module eStage #(
    parameter D = 16
) (
	 input logic         clk_i, rst_i,
     input logic [2:0]   control_i,
     input logic [D-1:0] rs_i, rt_i,
    output logic [D-1:0] alu_res_o,
    output logic [3:0]   flags_o
);

    alu #(D) 
        fu(.bus_a_i(rs_i), 
        .bus_b_i(rt_i),
        .control_i(control_i),
        .bus_s_o(alu_res_o),
        .flags_o(flags_o)
        );

endmodule