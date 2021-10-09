/* 
 *
 *
 * @file  mux2.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module mux2 #(WIDTH = 8)
(
     input logic[WIDTH-1:0] bus_a_i, bus_b_i,
     input logic            select_i,
    output logic[WIDTH-1:0] bus_o
);
    assign bus_o = select_i ? bus_b_i : bus_a_i;
endmodule
