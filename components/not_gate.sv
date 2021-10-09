/* 
 *
 *
 * @file  not_gate.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 */

module not_gate #(parameter WIDTH = 4)
(
     input logic[WIDTH-1:0] bus_i,
    output logic[WIDTH-1:0] bus_o
);
    assign bus_o = ~bus_i;
endmodule
