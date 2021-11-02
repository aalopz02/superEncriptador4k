module vSwapperBlock#(
	parameter elementSize = 8,
	parameter vectorSize = 8
						)(clk,vOper,dir1,dir2,res);

	reg [2:0] dir1Aux = 3'd0;
	reg [2:0] dir2Aux = 3'd0;
	reg [(elementSize*vectorSize)-1:0] vectorOper1Aux;
	reg [(elementSize*vectorSize)-1:0] resultAux;
	
	input clk;
	input [(elementSize*vectorSize)-1:0] vOper;
	input [2:0] dir1;
	input [2:0] dir2;
	output logic [(elementSize*vectorSize)-1:0] res;
	
	genvar i;
	generate 
	for (i = 0; i < vectorSize; i = i+1) begin:forloop
		singleSwapper singleSwapper(
			clk,
			vectorOper1Aux[(vectorSize*(8-i))-1:(vectorSize*(8-i))-8],
			resultAux[(vectorSize*(8-i))-1:(vectorSize*(8-i))-8],
			dir1Aux,
			dir2Aux
			);
		end
	endgenerate
	
	always @ (negedge clk) begin
		vectorOper1Aux <= vOper;
		dir1Aux <= dir1;
		dir2Aux <= dir2;
			
	end
		
	always @ (posedge clk) begin
		res <= resultAux;
	end
		
endmodule
