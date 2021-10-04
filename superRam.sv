module superRam(
	input clk, 
	input [7:0] address, 
	input [2:0] spam,
	input	[63:0] dataIn,
	input wren,
	
	output logic [7:0] byte0,
	output logic [7:0] byte1,
	output logic [7:0] byte2,
	output logic [7:0] byte3,
	output logic [7:0] byte4,
	output logic [7:0] byte5,
	output logic [7:0] byte6,
	output logic [7:0] byte7,
	output logic [63:0] dataOut
	);
	
	logic [63:0] dataInAux;
	
	assign dataInAux[7:0] = (spam >= 3'd0) ? dataIn[7:0] : 8'd0;
	assign dataInAux[15:8] = (spam >= 3'd1) ? dataIn[15:8] : 8'd0;
	assign dataInAux[23:16] = (spam >= 3'd2) ? dataIn[23:16] : 8'd0;
	assign dataInAux[31:24] = (spam >= 3'd3) ? dataIn[31:24] : 8'd0;
	assign dataInAux[39:32] = (spam >= 3'd4) ? dataIn[39:32] : 8'd0;
	assign dataInAux[47:40] = (spam >= 3'd5) ? dataIn[47:40] : 8'd0;
	assign dataInAux[55:48] = (spam >= 3'd6) ? dataIn[55:48] : 8'd0;
	assign dataInAux[63:56] = (spam >= 3'd7) ? dataIn[63:56] : 8'd0;
	
	ram ram(address,clk,dataInAux,wren,dataOut);

	assign byte0 = (spam >= 3'd0) ? dataOut[7:0] : 8'd0;
	assign byte1 = (spam >= 3'd1) ? dataOut[15:8] : 8'd0;
	assign byte2 = (spam >= 3'd2) ? dataOut[23:16] : 8'd0;
	assign byte3 = (spam >= 3'd3) ? dataOut[31:24] : 8'd0;
	assign byte4 = (spam >= 3'd4) ? dataOut[39:32] : 8'd0;
	assign byte5 = (spam >= 3'd5) ? dataOut[47:40] : 8'd0;
	assign byte6 = (spam >= 3'd6) ? dataOut[55:48] : 8'd0;
	assign byte7 = (spam >= 3'd7) ? dataOut[63:56] : 8'd0;

endmodule

`timescale 1 ps / 1 ps
module ramTB();

	logic mainClk = 1'b0;
	always #100 mainClk = !mainClk;
	
	logic ramClk = 1'b1;
	always #50 ramClk = !ramClk;
	
	logic [7:0] address = 8'd0;
	logic [2:0] spam = 3'd0;
	logic	[63:0] dataIn = 64'd0;
	logic wren = 1'b0;
	logic [7:0] byte0 = 8'd0;
	logic [7:0] byte1 = 8'd0;
	logic [7:0] byte2 = 8'd0;
	logic [7:0] byte3 = 8'd0;
	logic [7:0] byte4 = 8'd0;
	logic [7:0] byte5 = 8'd0;
	logic [7:0] byte6 = 8'd0;
	logic [7:0] byte7 = 8'd0;
	logic [63:0] dataOut = 64'd0;
	
	localparam period = 100;

	superRam superRam(ramClk,address,spam,dataIn,wren,byte0,byte1,byte2,byte3,byte4,byte5,byte6,byte7,dataOut);
	
	initial begin
		//reads
		#period;
		#period;
		
		address = address + 1'd1;
		#period;
		#period;
		
		spam = 3'd1;
		address = address + 1'd1;
		#period;
		#period;
		
		spam = 3'd4;
		address = address + 1'd1;
		#period;
		#period;
		
		spam = 3'd7;
		address = address + 1'd1;
		#period;
		#period;
		
		spam = 3'd5;
		address = address + 1'd1;
		#period;
		#period;
		
		//writes
		wren = 1'b1;
		spam = 3'd5;
		address = 8'd0;
		dataIn = 64'he23400789abadeff;
		#period;
		#period;
		
		spam = 3'd5;
		address = address + 1'd1;
		dataIn = dataIn + 64'h1;
		#period;
		#period;
		
		spam = 3'd1;
		address = address + 1'd1;
		dataIn = dataIn + 64'ha;
		#period;
		#period;
		
		spam = 3'd4;
		address = address + 1'd1;
		dataIn = dataIn + 64'hf;
		#period;
		#period;
		
		spam = 3'd7;
		address = address + 1'd1;
		dataIn = dataIn + 64'hfad;
		#period;
		#period;
		
		spam = 3'd5;
		address = address + 1'd1;
		dataIn = dataIn + 64'hf12;
		#period;
		#period;
		
		//read again
		wren = 1'b0;
		address = 8'd0;
		spam = 3'd7;
		#period;
		#period;
		
		address = address + 1'd1;
		#period;
		#period;
		
		address = address + 1'd1;
		#period;
		#period;
		
		address = address + 1'd1;
		#period;
		#period;
		
		address = address + 1'd1;
		#period;
		#period;
		
		address = address + 1'd1;
		#period;
		#period;
		
		$stop;
	end

endmodule

/*
do superEncriptador_run_msim_rtl_verilog.do
vsim -gui -l msim_transcript rtl_work.ramTB -L altera_mf_ver
add wave -position 0  sim:/ramTB/mainClk
add wave -position 1  sim:/ramTB/ramClk
add wave -position 2  sim:/ramTB/spam
add wave -position 3  sim:/ramTB/dataIn
add wave -position 4  sim:/ramTB/wren
add wave -position 5  sim:/ramTB/byte0
add wave -position 6  sim:/ramTB/byte1
add wave -position 7  sim:/ramTB/byte2
add wave -position 8  sim:/ramTB/byte3
add wave -position 9  sim:/ramTB/byte4
add wave -position 10  sim:/ramTB/byte5
add wave -position 11  sim:/ramTB/byte6
add wave -position 12  sim:/ramTB/byte7
add wave -position 13  sim:/ramTB/dataOut
add wave -position 5  sim:/ramTB/address
run 100
*/
