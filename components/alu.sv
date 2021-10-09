/* 
 *
 *
 * @file  alu.sv
 * @autor Luis Arturo Mora Granados
 * @date  14/10/2018
 * @src   Based on code found in Harris, D., & Harris, S. 
 *        Digital design and computer architecture. Elsevier. 2012.
 */

module alu #(parameter WIDTH = 3)
(
     input logic [WIDTH-1:0] bus_a_i, bus_b_i,
     input logic [2:0]       control_i,
    output logic [WIDTH-1:0] bus_s_o,
    output logic [3:0]       flags_o
);
    logic[WIDTH-1:0] addr_l, and_l, orr_l, shl_l, sll_l;
    logic flag_z, flag_v, flag_n, flag_c, carry_o;
    adder_substractor #(WIDTH) adder_sub(.bus_a_i(bus_a_i), 
                                         .bus_b_i(bus_b_i), 
                                         .select_i(control_i[0]), 
                                         .bus_o(addr_l), 
                                         .carry_o(carry_o));
    and_gate #(WIDTH) and_op(bus_a_i, bus_b_i,
                             and_l);
    or_gate #(WIDTH)  xor_op(bus_a_i, bus_b_i,
                             orr_l);
    shift_left_gate #(WIDTH) shift_left_gate(bus_a_i, bus_b_i,
                             sll_l);
    shift_right_gate #(WIDTH) shift_right_gate(bus_a_i, bus_b_i,
                             shl_l);

    mux_eight #(WIDTH) opSelector(.bus_a_i(addr_l), 
                                 .bus_b_i(addr_l), 
                                 .bus_c_i(and_l), 
                                 .bus_d_i(orr_l),
                                 .bus_e_i(shl_l),
                                 .bus_f_i(sll_l),
                                 .select_i(control_i),
                                 .bus_o(bus_s_o));
    always_comb begin
        flag_z   = & (~bus_s_o);
        flag_c   = ~ control_i[1] & carry_o;
        flag_n   =   bus_s_o[WIDTH-1];
        flag_v   = ~ control_i[1] & 
                    (bus_a_i[WIDTH-1] | addr_l[WIDTH-1]) & 
                   ~(control_i[0] ^ bus_a_i[WIDTH-1] ^ bus_b_i[WIDTH-1]);
        flags_o[0] = flag_v;
        flags_o[1] = flag_c;
        flags_o[2] = flag_z;
        flags_o[3] = flag_n;
    end
endmodule
