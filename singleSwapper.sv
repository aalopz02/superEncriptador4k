module singleSwapper(clk,oper,res,pos1,pos2);

	input clk;
	input [7:0] oper;
	input [2:0] pos1;
	input [2:0] pos2;
	output logic [7:0] res;
	
	logic oper1Aux;
	logic oper2Aux;
	logic [7:0] resAux;

	
	always @ (negedge clk) begin
		resAux = oper;
		resAux[pos1] = oper[pos2];
		resAux[pos2] = oper[pos1];
	end
	
	
	always @ (posedge clk) begin
		res <= resAux;
	end
		
endmodule

module swapTB();

	logic clk = 1'b0;
	always #100 clk = !clk;
	localparam period = 100;
	
	logic [7:0] oper = 8'd0;
	logic [2:0] pos1 = 3'd0;
	logic [2:0] pos2 = 3'd0;
	logic [7:0] res = 8'd0;
	
	singleSwapper singleSwapper(clk,oper,res,pos1,pos2);

	initial begin
			#period;
			#period;
			oper = 8'b00110011;
			pos1 = 3'd7;
			pos2 = 3'd0;
			#period;
			#period;
			oper = 8'b00110011;
			pos1 = 3'd6;
			pos2 = 3'd0;
			#period;
			#period;
			oper = 8'b00110011;
			pos1 = 3'd1;
			pos2 = 3'd0;
			#period;
			#period;
			oper = 8'b00110011;
			pos1 = 3'd4;
			pos2 = 3'd5;
			#period;
			#period;
			oper = 8'b00110011;
			pos1 = 3'd2;
			pos2 = 3'd2;
			#period;
			#period;
		   oper = 8'b00110011;
			pos1 = 3'd7;
			pos2 = 3'd3;
			#period;
			#period;
			$stop;
	end
	
endmodule

