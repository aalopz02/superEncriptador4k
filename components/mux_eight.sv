/* 
 *
 *
 * @file  mux_eight.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module mux_eight #(WIDTH = 8)
(
     input logic [WIDTH-1:0] bus_a_i, bus_b_i, bus_c_i, bus_d_i, 
     input logic [WIDTH-1:0] bus_e_i, bus_f_i, bus_g_i, bus_h_i,
     input logic [2:0]      select_i,
    output logic [WIDTH-1:0] bus_o);
    
    logic[WIDTH-1:0]  stage_1_1_out, stage_1_2_out;
    mux_four #(WIDTH) stage_1_1(bus_a_i, bus_b_i, bus_c_i, bus_d_i, select_i[1:0], stage_1_1_out);
    mux_four #(WIDTH) stage_1_2(bus_e_i, bus_f_i, bus_g_i, bus_h_i, select_i[1:0], stage_1_2_out);
    mux2     #(WIDTH) stage_2_0(stage_1_1_out, stage_1_2_out, select_i[2], bus_o);
endmodule
