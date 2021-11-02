module extend(
    input logic [5:0] Instr,
    input logic [1:0] ImmSrc,
    output logic [31:0] ExtImm
);
    always_comb
    case(ImmSrc)
    // 5-bit unsigned immediate
    2'b00: ExtImm = {24'b0, Instr[4:0]};
    // 4-bit unsigned immediate
    2'b01: ExtImm = {20'b0, Instr[3:0]};
    default: ExtImm = 32'bx; // undefined
    endcase
endmodule