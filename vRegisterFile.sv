module vRegisterFile #(
    parameter elementSize = 8,
    parameter vectorSize = 8,
	 parameter vectors = 4)
	 (
	 input logic clk,
    input logic wEnable, 
    input logic [1:0] voper1, voper2, vresult,
    input logic [(elementSize*vectorSize)-1:0] dataIn, 
    output logic [(elementSize*vectorSize)-1:0] oper1, oper2
	 );
	
	logic [vectors-1:0][(elementSize*vectorSize)-1:0] matrix;
	
	initial begin
		matrix[2'd0] <= 64'h4343424241414141;
		matrix[2'd1] <= 64'h4344444444444443;
		matrix[2'd2] <= 64'h4a4a4b4c4c4d4d4e;
		matrix[2'd3] <= 64'h5050515252535353;
	end
	
	always_ff @(negedge clk) begin
		if (wEnable) matrix[vresult] <= dataIn;	
	end
	
	assign oper1 = matrix[voper1];
	assign oper2 = matrix[voper2];
  
endmodule

module vREgTB();

	logic clk = 1'b0;
	
	logic wEnable = 1'b0;
   logic [1:0] voper1 = 2'd0;
	logic [1:0] voper2 = 2'd0;
	logic [1:0] vresult = 2'd0;
	
	logic [63:0] dataIn = 64'd0;
	logic [63:0] oper1 = 64'd0;
	logic [63:0] oper2 = 64'd0;
	
	always #100 clk = !clk;
	localparam period = 100;
	
	vRegisterFile#(8, 8, 4) VRegisterFile(clk,wEnable, voper1, voper2, vresult,dataIn, oper1, oper2);
	
	 
    always begin
		wEnable = 1'b1;
		dataIn = 64'hFFFFFFF;
		vresult = 2'd0;
		#period;
		#period;
		wEnable = 1'b1;
		vresult = 2'd1;
		dataIn = 64'h12345;
		#period;
		#period;
		wEnable = 1'b0;
		vresult = 2'd0;
		voper2 = 2'd0;
		voper1 = 2'd1;
		dataIn = 64'd0;
		#period;
		#period;
		voper2 = 2'd1;
		voper1 = 2'd0;
		#period;
		#period;
    end
	 
endmodule