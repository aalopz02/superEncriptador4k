module vAluBlock #(
	parameter elementSize = 8,
	parameter vectorSize = 8
						)(
						input logic clk,
						input logic [(elementSize*vectorSize)-1:0] vectorOper1,
						input logic [(elementSize*vectorSize)-1:0] vectorOper2,
						output logic [(elementSize*vectorSize)-1:0] result,
						input logic [2:0] opCode
						);

		reg [2:0] opCodeAux = 3'd0;
		reg [(elementSize*vectorSize)-1:0] vectorOper1Aux;
		reg [(elementSize*vectorSize)-1:0] vectorOper2Aux;
		reg [(elementSize*vectorSize)-1:0] resultAux;
		
		genvar i;
		generate 
			for (i = 0; i < vectorSize; i = i+1) begin:forloop
				alu#(8) alu(
							vectorOper1Aux[(vectorSize*(8-i))-1:(vectorSize*(8-i))-8],
							vectorOper2Aux[(vectorSize*(8-i))-1:(vectorSize*(8-i))-8], 
							opCodeAux,
							resultAux[(vectorSize*(8-i))-1:(vectorSize*(8-i))-8],
							x
						);
			end
		endgenerate
		
		always @ (posedge clk) begin
			opCodeAux <= opCode;
			vectorOper1Aux <= vectorOper1;
			vectorOper2Aux <= vectorOper2;
			
		end
		
		always @ (negedge clk) begin
			result <= resultAux;
		end
	 
endmodule

module vAluTest();

	logic clk = 1'b1;
	
	always #100 clk = !clk;
	localparam period = 100;
	
	logic [2:0] opCode = 3'd0;
	logic	[(8*8)-1:0] vectorOper1 = 64'd0;
	logic [(8*8)-1:0] vectorOper2 = 64'd0;
	logic [(8*8)-1:0] result = 64'd0;
	
	vAluBlock #(8,8) vAluBlock(clk,vectorOper1,vectorOper2,result,opCode);
	
	
	initial begin
		
		vectorOper1 = 64'hFFFFFFFFFFFFFFFF;
		vectorOper2 = 64'h1122334455667788;
		opCode = 3'b000;
		#period;
		vectorOper1 = 64'h00000000ffffffff;
		vectorOper2 = 64'h1122334455667788;
		opCode = 3'b001;
		#period;
		vectorOper1 = 64'hFFFFFFFFFFFFFFFF;
		vectorOper2 = 64'hFFFFFFFFFFFFFFFF;
		opCode = 3'b010;
		#period;
		vectorOper1 = 64'h1122334455667788;
		vectorOper2 = 64'h1122334455667788;
		opCode = 3'b011;
		#period;
		vectorOper1 = 64'hFFFFFFFFFFFFFFFF;
		vectorOper2 = 64'h1122334455667788;
		opCode = 3'b100;
		#period;
		vectorOper1 = 64'hFFFFFFFFFFFFFFFF;
		vectorOper2 = 64'h1122334455667788;
		opCode = 3'b101;
		#period;
	end

endmodule
