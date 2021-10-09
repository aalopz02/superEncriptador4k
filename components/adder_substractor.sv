/* 
 *
 *
 * @file  adder_substractor.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module adder_substractor #(parameter WIDTH = 3)
(
     input logic [WIDTH-1:0] bus_a_i, bus_b_i,
     input logic             select_i,
    output logic [WIDTH-1:0] bus_o,
    output logic             carry_o
);
    
    logic[WIDTH-1:0] bus_tmp, selected;
    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i+1) begin:forloop
            assign selected[i] = select_i;
        end
    endgenerate
    xor_gate #(WIDTH) oper(.bus_a_i(bus_b_i),
                          .bus_b_i(selected), 
                          .bus_s_o(bus_tmp));
    adder    #(WIDTH) addr(.bus_a_i(bus_a_i),
                          .bus_b_i(bus_tmp),
                          .carry_i(select_i),
                          .bus_o(bus_o),
                          .carry_o(carry_o));
endmodule
