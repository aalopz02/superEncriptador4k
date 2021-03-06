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
  
  initial begin
	rf[4'd0] <= 16'd0;
	rf[4'd1] <= 16'd0;
	rf[4'd2] <= 16'd0;
	rf[4'd3] <= 16'd0;
	rf[4'd4] <= 16'd0;
	rf[4'd5] <= 16'd0;
	rf[4'd6] <= 16'd0;
	rf[4'd7] <= 16'd0;
	rf[4'd8] <= 16'd0;
	rf[4'd9] <= 16'd0;
	rf[4'd10] <= 16'd0;
	rf[4'd11] <= 16'd0;
	rf[4'd12] <= 16'd0;
	rf[4'd13] <= 16'd0;
	rf[4'd14] <= 16'd0;
	rf[4'd15] <= 16'd0;
  end
  
  always_ff @(negedge clk)
    if (we3)  begin
      rf[wa3] <= wd3;	
      rf[REGI_SIZE-1] <= pc;
    end
  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule