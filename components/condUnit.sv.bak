module condUnit #(
    parameter EQ = 0,
    parameter GT = 1,
    parameter AL = 2,
    parameter NE = 3
)
(
     input logic clk_i,
     input logic[1:0] cond_i, alu_flags_i,
    output logic signal_o
);
    always_ff @(negedge clk_i) begin
        case(alu_flags_i)
            2'b00: if(cond == alu_flags_i) signal_o <= 1;
            2'b01: if(cond == alu_flags_i) signal_o <= 1;
            2'b10: if(cond == alu_flags_i) signal_o <= 1;
            2'b11: if(cond == alu_flags_i) signal_o <= 1;
            default: signal_o = 0; // undefined
        endcase 
    end
endmodule