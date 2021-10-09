/* 
 *
 *
 * @file  one_bit_half_adder.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module one_bit_half_adder
(
    input logic bit_a_i, bit_b_i,
    output logic sum_o, carry_o
);
    xor_gate #(1) sum(bit_a_i, bit_b_i, sum_o);
    and_gate #(1) car(bit_a_i, bit_b_i, carry_o);
endmodule
