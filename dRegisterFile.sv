module dRegisterFile #(
    parameter REGI_BITS = 4,
    parameter REGI_SIZE = 16
) (
     input logic                 clk, 
     input logic                 we3, 
     input logic [REGI_BITS-1:0] ra1, ra2, wa3,
     input logic [REGI_SIZE-1:0] pc,
     input logic [REGI_SIZE-1:0] wd3, 
    output logic [REGI_SIZE-1:0] rd1, rd2

);

  logic [REGI_SIZE-1:0] rf[REGI_SIZE-1:0];
  
  always_ff @(negedge clk)
    if (we3)  begin
      rf[wa3] <= wd3;	
      rf[REGI_SIZE-1] <= pc;
    end
  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule