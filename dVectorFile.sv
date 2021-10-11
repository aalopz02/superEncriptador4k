module dVectorFile #(
    parameter S = 2,
    parameter D = 8,
    parameter V = 4
) (
    input  logic         clk, 
    input  logic         we3, 
    input  logic [S-1:0] ra1, ra2, wa3,
    input  logic [D-1:0] wd3 [V-1:0], 
    output logic [D-1:0] rd1 [V-1:0],
    output logic [D-1:0] rd2 [V-1:0]
);

  logic [S-1:0] vf[D-1:0][V-1:0];

  always_ff @(negedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule