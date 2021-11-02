module intToVect(intOper,vectorOut);

	input [7:0] intOper;
	output [63:0] vectorOut;
	
	assign vectorOut[63:56] = intOper;
	assign vectorOut[55:48] = intOper;
	assign vectorOut[47:40] = intOper;
	assign vectorOut[39:32] = intOper;
	assign vectorOut[31:24] = intOper;
	assign vectorOut[23:16] = intOper;
	assign vectorOut[15:8] = intOper;
	assign vectorOut[7:0] = intOper;
	
endmodule

module tb();

	logic [7:0] intOper;
	logic [63:0] vectorOut;
	
	localparam period = 100;
	
	intToVect intToVect(intOper,vectorOut);

	initial begin
		intOper = 8'hFF;
		#period;
		intOper = 8'hAA;
		#period;
		intOper = 8'h12;
		#period;
	end
endmodule
