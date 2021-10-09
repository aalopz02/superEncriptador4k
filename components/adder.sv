module adder #(parameter WIDTH = 3)
(
     input logic[WIDTH-1:0] bus_a_i, bus_b_i,
     input logic            carry_i,
    output logic[WIDTH-1:0] bus_o,
    output logic            carry_o
);
    logic[WIDTH:0] full_num;
    assign full_num[0] = carry_i;
    assign carry_o     = full_num[WIDTH];
    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i+1) begin:forloop
            one_bit_full_adder addrr(bus_a_i[i], bus_b_i[i], full_num[i], bus_o[i], full_num[i+1]);
        end
    endgenerate
endmodule