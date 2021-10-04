module vectorRegs(
	input clk,
	input logic [1:0] dir,
	input logic [63:0] valueIn,
	input logic wren,
	output logic [63:0] valueOut
	);

	reg [63:0] vector1 = 64'd0;
	reg [63:0] vector2 = 64'd0;
	reg [63:0] vector3 = 64'd0;
	reg [63:0] vector4 = 64'd0;
	
	reg [63:0] vectorAux = 64'd0;
	
	always @(posedge clk) begin
		if (wren == 1'b1) begin
			if (dir == 2'd0) begin
				vector1 = valueIn;
			end
			else if (dir == 2'd1) begin
				vector2 = valueIn;
			end
			else if (dir == 2'd2) begin
				vector3 = valueIn;
			end
			else if (dir == 2'd3) begin
				vector4 = valueIn;
			end
		end
		
		if (dir == 2'd0) begin
			vectorAux = vector1;
		end
		else if (dir == 2'd1) begin
			vectorAux = vector2;
		end
		else if (dir == 2'd2) begin
			vectorAux = vector3;
		end
		else if (dir == 2'd3) begin
			vectorAux = vector4;
		end
	end
	
	always @(negedge clk) begin
		valueOut = vectorAux;
	end

endmodule

`timescale 1 ps / 1 ps
module vregsTB();

	logic clk = 1'b0;
	always #100 clk = !clk;
	
	logic [1:0] dir = 2'd0;
	logic [63:0] valueIn = 64'd0;
	logic wren = 1'b0;
	logic [63:0] valueOut = 64'd0;
	
	localparam period = 100; 	

	vectorRegs vectorRegs(clk,dir,valueIn,wren,valueOut);
	
	initial begin
	
		wren = 1'b1;
		valueIn = 64'd1;
		#period;
		#period;
		
		dir = 2'b01;
		valueIn = 64'd2;
		#period;
		#period;
		
		dir = 2'b10;
		valueIn = 64'd3;
		#period;
		#period;
		
		dir = 2'b11;
		valueIn = 64'd4;
		#period;
		#period;
		
		wren = 1'b0;
		dir = 2'b00;
		#period;
		#period;
		
		wren = 1'b0;
		dir = 2'b01;
		#period;
		#period;
		
		wren = 1'b0;
		dir = 2'b10;
		#period;
		#period;
		
		wren = 1'b0;
		dir = 2'b11;
		#period;
		#period;
		
	end
	
endmodule

/*

do superEncriptador_run_msim_rtl_verilog.do
vsim -gui -l msim_transcript rtl_work.vregsTB -L altera_mf_ver
add wave -position 0  sim:/vregsTB/clk
add wave -position 1  sim:/vregsTB/dir
add wave -position 3  sim:/vregsTB/valueIn
add wave -position 4  sim:/vregsTB/wren
add wave -position 5  sim:/vregsTB/vectorRegs/vectorAux 
add wave -position 6  sim:/vregsTB/valueOut
add wave -position 7  sim:/vregsTB/vectorRegs/vector1
add wave -position 8  sim:/vregsTB/vectorRegs/vector2
add wave -position 9  sim:/vregsTB/vectorRegs/vector3
add wave -position 10  sim:/vregsTB/vectorRegs/vector4
run 100

*/
