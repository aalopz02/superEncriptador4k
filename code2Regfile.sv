module code2Regfile #(
    parameter I = 5,
    parameter D = 32
) (
    input  logic         clk, 
    input  logic         we3, 
    input  logic [I-1:0] ra1, ra2, wa3,
    input  logic [D-1:0] wd3, 
    output logic [D-1:0] rd1, rd2
);

  logic [D-1:0] rf[D-1:0];

initial $readmemh("C:/OP-ProjectII/superEncriptador4k/dataReg.dat", rf);

  always_ff @(negedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule