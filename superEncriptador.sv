module superEncriptador(
	input clk, 
	input ramClk,
	input [2:0]romSelect,
	output done,
	output logic [15:0] actualInst);

	logic [6:0] pc = 7'd0;
	
	logic flagXorRom = 1'b0;
	logic flagShiftRom = 1'b0;
	logic flagSwapRom = 1'b0;
	
	logic flagDecXorRom = 1'b0;
	logic flagDecShiftRom = 1'b0;
	logic flagDecSwapRom = 1'b0;
	
	logic [15:0] instXor = 16'd0;
	logic [15:0] instShift = 16'd0;
	logic [15:0] instSwap = 16'd0;
	
	logic [15:0] instDecXor = 16'd0;
	logic [15:0] instDecShift = 16'd0;
	logic [15:0] instDecSwap = 16'd0;
	
	//logic [15:0] actualInst = 16'd0;
	
	logic [2:0] selectXor = 3'd0;
	logic [2:0] selectorShift = 3'd1;
	logic [2:0] selectSwap = 3'd2;
	logic [2:0] selectDecXor = 3'd3;
	logic [2:0] selectDecShift = 3'd4;
	logic [2:0] selectDecSwap = 3'd5;
	
	logic	[15:0] address = 16'b0;
	
	logic	[63:0] dataIn = 64'd0;
	
	logic wren = 1'b0;
	
	logic [63:0] dataOut = 64'd0;
	
	//logic	[63:0] dataOut = 64'd0;
	
	romXor romXor(pc,clk && flagXorRom,instXor);
	
	romShift romShift(pc,clk && flagShiftRom,instShift);

	romSwap romSwap(pc,clk && flagSwapRom,instSwap);
	
	romDecXor romDecXor(pc,clk && flagDecXorRom,instDecXor);
	
	romDecShift romDecShift(pc,clk && flagDecShiftRom,instDecShift);
	
	romDecSwap romDecSwap(pc,clk && flagDecSwapRom,instDecSwap);
	
	ram ram(address,ramClk,dataIn,wren,dataOut);
	
	always @ (posedge clk) begin
		address = address + 1'd1;
		//dataOutAux = dataOut;
	end
	
	always @(*) begin
		if (romSelect == selectXor) begin
			flagXorRom = 1'b1;
			flagShiftRom = 1'b0;
			flagSwapRom = 1'b0;
			flagDecXorRom = 1'b0;
			flagDecShiftRom = 1'b0;
			flagDecSwapRom = 1'b0;
			actualInst = instXor;
		end 
		else if (romSelect == selectorShift) begin
			flagXorRom = 1'b0;
			flagShiftRom = 1'b1;
			flagSwapRom = 1'b0;
			flagDecXorRom = 1'b0;
			flagDecShiftRom = 1'b0;
			flagDecSwapRom = 1'b0;
			actualInst = instShift;
		end
		else if (romSelect == selectSwap) begin
			flagXorRom = 1'b0;
			flagShiftRom = 1'b0;
			flagSwapRom = 1'b1;
			flagDecXorRom = 1'b0;
			flagDecShiftRom = 1'b0;
			flagDecSwapRom = 1'b0;
			actualInst = instSwap;
		end
		else if (romSelect == selectDecXor) begin
			flagXorRom = 1'b0;
			flagShiftRom = 1'b0;
			flagSwapRom = 1'b0;
			flagDecXorRom = 1'b1;
			flagDecShiftRom = 1'b0;
			flagDecSwapRom = 1'b0;
			actualInst = instDecXor;
		end
		else if (romSelect == selectDecShift) begin
			flagXorRom = 1'b0;
			flagShiftRom = 1'b0;
			flagSwapRom = 1'b0;
			flagDecXorRom = 1'b0;
			flagDecShiftRom = 1'b1;
			flagDecSwapRom = 1'b0;
			actualInst = instDecShift;
		end
		else if (romSelect == selectDecSwap) begin
			flagXorRom = 1'b1;
			flagShiftRom = 1'b0;
			flagSwapRom = 1'b0;
			flagDecXorRom = 1'b0;
			flagDecShiftRom = 1'b0;
			flagDecSwapRom = 1'b1;
			actualInst = instDecSwap;
		end
	end
	
	always @(posedge clk) begin
		pc = pc + 1'b1;
	end

	assign done = (pc == 7'd128);
	
endmodule


`timescale 1 ps / 1 ps
module TB();

	logic mainClk = 1'b0;
	always #100 mainClk = !mainClk;
	
	logic ramClk = 1'b1;
	always #50 ramClk = !ramClk;
	
	logic [63:0] dataOut;
	
	localparam period = 100; 	

	superEncriptador superEncriptador(mainClk,ramClk,x,y,z,dataOut);
	
endmodule
/*

do superEncriptador_run_msim_rtl_verilog.do
vsim -gui -l msim_transcript rtl_work.TB -L altera_mf_ver
add wave -position 0  sim:/TB/mainClk
add wave -position 1  sim:/TB/ramClk
add wave -position 2  sim:/TB/superEncriptador/address
add wave -position 3  sim:/TB/superEncriptador/dataIn
add wave -position 4  sim:/TB/superEncriptador/wren
add wave -position 5  sim:/TB/superEncriptador/dataOutAux
add wave -position 6  sim:/TB/dataOut
run 100

*/