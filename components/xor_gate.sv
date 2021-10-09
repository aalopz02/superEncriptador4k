/* 
 *
 *
 * @file  xor_gate.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module xor_gate #(parameter WIDTH = 4) 
(
     input logic[WIDTH-1:0] bus_a_i, bus_b_i,
    output logic[WIDTH-1:0] bus_s_o
);
    assign bus_s_o = bus_a_i ^ bus_b_i;
endmodule
