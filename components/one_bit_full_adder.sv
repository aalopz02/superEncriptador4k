/* 
 *
 *
 * @file  one_bit_full_adder.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/09/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module one_bit_full_adder
(
     input logic bit_a_i, bit_b_i, carry_i,
    output logic sum_o, carry_o
);
    logic sum_a, carry_a, carry_b;
    one_bit_half_adder getSumA(bit_a_i, bit_b_i, sum_a, carry_a);
    one_bit_half_adder getSumB(carry_i, sum_a, sum_o, carry_b);
    or_gate #(1) getCarry(carry_a, carry_b, carry_o);
endmodule
