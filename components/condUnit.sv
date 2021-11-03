module condUnit #(WIDTH = 8)
(
     input logic[1:0] cond_i, alu_flags_i,
    output logic signal_o
);
    always @() begin
        case(cond_i)
            2'b00: signal_o = 1;
            2'b01: signal_o = 1;
            default: signal_o = 0; // undefined
        endcase
        
    end

endmodule