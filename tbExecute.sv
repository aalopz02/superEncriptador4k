module tbExecute#(
    parameter D = 16
) ();


	logic clk, rst;
    logic [2:0] control_i;
    logic [D-1:0] rs_i, rt_i;
    logic [D-1:0] alu_res_p, alu_res_o;

    eStage #(D) 
        dut(.clk_i(clk), .rst_i(rst),
            .control_i(control_i),
            .rs_i(rs_i), .rt_i(rt_i),
            .alu_res_o(alu_res_p)
            //.flags_o(flags_o)
            );
            
    ePipe #(D)
        exmem_pipe(.clk_i(clk), .rst_i(rst),
        .alu_res_i(alu_res_p),
        .alu_res_o(alu_res_o)
        );
            
    
    initial begin
        #0 
        rst <= 1;
        alu_res_p <= 0;
        
        #50
        rst <= 0;

        #60
        control_i <= 0;
        rs_i <= 3; rt_i <= 5;

        #70
        control_i <= 1;
        rs_i <= 3; rt_i <= 5;

        #80
        control_i <= 2;
        rs_i <= 3; rt_i <= 5;

        #90
        control_i <= 3;
        rs_i <= 3; rt_i <= 5;

    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end
endmodule