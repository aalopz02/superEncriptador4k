module decoder#(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
) (
	input logic clk,
	input logic [REGI_SIZE-1:0] instruction,
	output logic [REGI_SIZE-1:0] intOper1,
	output logic [REGI_SIZE-1:0] intOper2,
	output logic [VECT_BITS-1:0] vOper1,
	output logic [VECT_BITS-1:0] vOper2,
	output logic [REGI_BITS-3:0] intRegDest,
	output logic [VECT_BITS-1:0] vRegDest, 
	output logic [1:0] cond,
	output logic enableAluInt,
	output logic enableAluV,
	output logic enableMem,
	output logic enableJump,
	output logic enableSwap,
	output logic flagEnd,
	output logic flagNop,
	output logic flagImm,
	output logic [7:0] ImmOut,
	output logic [2:0] aluOpcode,
	output logic [9:0] jumpAddress,
	output logic flagMemRead,
	output logic flagMemWrite,
	output logic [2:0] swapBitOrigin,
	output logic [2:0] swapBitDest
	);
	
	reg [3:0] intOper1Aux = 4'd0;
	reg [3:0] intOper2Aux = 4'd0;
	reg [1:0] vOper1Aux = 2'd0;
	reg [1:0] vOper2Aux = 2'd0;
	reg [3:0] intRegDestAux = 4'd0;
	reg [1:0] vRegDestAux = 2'd0;
	reg [1:0] condAux = 2'd0;
	reg enableAluIntAux = 1'b0;
	reg enableAluVAux = 1'b0;
	reg enableMemAux = 1'b0;
	reg enableJumpAux = 1'b0;
	reg enableSwapAux = 1'd0;
	reg flagEndAux = 1'b0;
	reg flagNopAux = 1'b0;
	reg flagImmAux = 1'b0;
	reg [7:0] ImmOutAux = 8'd0;
	reg [2:0] aluOpcodeAux = 2'd0;
	reg [9:0] jumpAddressAux = 10'd0;
	reg flagMemReadAux = 1'b0;
	reg flagMemWriteAux = 1'b0;
	reg [2:0] swapBitOriginAux = 3'd0;
	reg [2:0] swapBitDestAux = 3'd0;
	
	logic [3:0] opCodeCMP = 4'd0;
	logic [3:0] opCodeJ = 4'd1;
	logic [3:0] opCodeVXOR = 4'd2;
	logic [3:0] opCodeVXORI = 4'd3;
	logic [3:0] opCodeVLD = 4'd4;
	logic [3:0] opCodeVSTR = 4'd5;
	logic [3:0] opCodeVSR = 4'd6;
	logic [3:0] opCodeVSL = 4'd7;
	logic [3:0] opCodeVSWAP = 4'd8;
	logic [3:0] opCodeINTADD = 4'd9;
	logic [3:0] opCodeINTSUB = 4'd10;
	logic [3:0] opCodeINTADDI = 4'd11;
	logic [3:0] opCodeINTSUBI = 4'd12;
	logic [3:0] opCodeNOP = 4'd13;
	logic [3:0] opCodeEND = 4'd14;
	logic [2:0] codeCMP = 3'b101;
	
	logic [1:0] condEQ = 2'b00;
	logic [1:0] condGT = 2'b01;
	logic [1:0] condAL = 2'b10;
	logic [1:0] condNE = 2'b11;
	
	logic [2:0] codeXOR = 3'b000;
	logic [2:0] codeSR = 3'b001;
	logic [2:0] codeSL = 3'b010;
	logic [2:0] codeADD = 3'b011;
	logic [2:0] codeSUB = 3'b100;
	
	always @ (negedge clk) begin
			intOper1 <= intOper1Aux;
			intOper2 <= intOper2Aux;
			vOper1 <= vOper1Aux;
			vOper2 <= vOper2Aux;
			case (instruction[3:0])
				opCodeCMP: begin
						intOper1Aux <= instruction[13:10];
						intOper2Aux <= instruction[9:6];
						condAux <= condEQ;
						enableAluIntAux <= 1'b1;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						enableSwapAux <= 1'd0;
						aluOpcodeAux <= codeCMP;
					end
				opCodeJ: begin
						jumpAddressAux <= instruction[13:4];
						condAux <= instruction[15:14];
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b1;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						enableSwapAux <= 1'd0;
					end
				opCodeVXOR: begin
						condAux <= instruction[15:14];
						aluOpcodeAux <= codeXOR;
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b1;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[8:5];
						vOper1Aux <= instruction[12:11];
						vRegDestAux <= instruction[10:9];
						enableSwapAux <= 1'd0;
					end
				opCodeVXORI: begin
						condAux <= instruction[15:14];
						aluOpcodeAux <= codeXOR;
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b1;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b1;
						ImmOutAux[4:0] <= instruction[8:4];
						ImmOutAux[7:5] <= 3'd0;
						vOper1Aux <= instruction[12:11];
						vRegDestAux <= instruction[10:9];
						enableSwapAux <= 1'd0;
					end
				opCodeVLD: begin
						condAux <= instruction[15:14];
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b1;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b1;
					   flagMemReadAux <= 1'b1;
						flagMemWriteAux <= 1'b0;
						ImmOutAux[2:0] <= instruction[7:5];
						ImmOutAux[7:3] <= 5'd0;
						intOper1Aux <= instruction[13:10];
						vRegDestAux <= instruction[9:8];
						enableSwapAux <= 1'd0;
					end
				opCodeVSTR: begin
						condAux <= instruction[15:14];
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b1;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b1;
					   flagMemReadAux <= 1'b0;
						flagMemWriteAux <= 1'b1;
						ImmOutAux[2:0] <= instruction[7:5];
						ImmOutAux[7:3] <= 5'd0;
						intOper1Aux <= instruction[13:10];
						vOper1Aux <= instruction[9:8];
						enableSwapAux <= 1'd0;
					end 
				opCodeVSR: begin
						condAux <= instruction[15:14];
						aluOpcodeAux <= codeSR;
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b1;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[8:5];
						vOper1Aux <= instruction[12:11];
						vRegDestAux <= instruction[10:9];
						enableSwapAux <= 1'd0;
					end 
				opCodeVSL: begin
						condAux <= instruction[15:14];
						aluOpcodeAux <= codeSL;
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b1;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[8:5];
						vOper1Aux <= instruction[12:11];
						vRegDestAux <= instruction[10:9];
						enableSwapAux <= 1'd0;
					end 
				opCodeVSWAP: begin
						condAux <= instruction[15:14];
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd1;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						vOper1Aux <= instruction[13:12];
						vRegDestAux <= instruction[11:10];
						swapBitOriginAux <= instruction[9:7];
						swapBitDestAux <= instruction[6:4];
					end
				opCodeINTADD: begin
						condAux <= condAL;
						aluOpcodeAux <= codeADD;
						enableAluIntAux <= 1'b1;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[15:12];
						intRegDestAux <= instruction[11:8];
						intOper2Aux <= instruction[7:4];
					end 
				opCodeINTSUB: begin
						condAux <= condAL;
						aluOpcodeAux <= codeSUB;
						enableAluIntAux <= 1'b1;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[15:12];
						intRegDestAux <= instruction[11:8];
						intOper2Aux <= instruction[7:4];
					end 
				opCodeINTADDI: begin
						condAux <= condAL;
						aluOpcodeAux <= codeADD;
						enableAluIntAux <= 1'b1;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[15:12];
						intRegDestAux <= instruction[11:8];
						flagImmAux <= 1'b1;
						ImmOutAux[3:0] <= instruction[7:4];
						ImmOutAux[7:4] <= 4'd0;
					end
				opCodeINTSUBI: begin
						condAux <= condAL;
						aluOpcodeAux <= codeSUB;
						enableAluIntAux <= 1'b1;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
						flagEndAux <= 1'b0;
						flagNopAux <= 1'b0;
						flagImmAux <= 1'b0;
						intOper1Aux <= instruction[15:12];
						intRegDestAux <= instruction[11:8];
						intOper2Aux <= instruction[7:4];
						flagImmAux <= 1'b1;
						ImmOutAux[3:0] <= instruction[7:4];
						ImmOutAux[7:4] <= 4'd0;
					end
				opCodeNOP: begin
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
					end
				opCodeEND: begin
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
						flagEndAux <= 1'b1;
						flagNopAux <= 1'b0;
					end
				default : begin
						enableAluIntAux <= 1'b0;
						enableAluVAux <= 1'b0;
						enableMemAux <= 1'b0;
						enableJumpAux <= 1'b0;
						enableSwapAux <= 1'd0;
				end
			endcase
	end
	
	always @ (posedge clk) begin
		intRegDest <= intRegDestAux;
		vRegDest <= vRegDestAux; 
		cond <= condAux;
		enableAluInt <= enableAluIntAux;
		enableAluV <= enableAluVAux;
		enableMem <= enableMemAux;
		enableJump <= enableJumpAux;
		enableSwap <= enableSwapAux;
		flagEnd <= flagEndAux;
		flagNop <= flagNopAux;
		flagImm <= flagImmAux;
		ImmOut <= ImmOutAux;
		aluOpcode <= aluOpcodeAux;
		jumpAddress <= jumpAddressAux;
		flagMemRead <= flagMemReadAux;
		flagMemWrite <= flagMemWriteAux;
		swapBitOrigin <= swapBitOriginAux;
		swapBitDest <= swapBitDestAux;
	end
	
endmodule

module decoderTB();

	logic clk = 1'b0;
	
	always #100 clk = !clk;
	localparam period = 100;
	
	logic [15:0] instruction;
	logic [3:0] intOper1;
	logic [3:0] intOper2;
	logic [1:0] vOper1;
	logic [1:0] vOper2;
	logic [3:0] intRegDest;
	logic [1:0] vRegDest; 
	logic [1:0] cond;
	logic enableAluInt;
	logic enableAluV;
	logic enableMem;
	logic enableJump;
	logic enableSwap;
	logic flagEnd;
	logic flagNop;
	logic flagImm;
	logic [7:0] ImmOut;
	logic [2:0] aluOpcode;
	logic [9:0] jumpAddress;
	logic flagMemRead;
	logic flagMemWrite;
	logic [2:0] swapBitOrigin;
	logic [2:0] swapBitDest;
	
	decoder superDecoder(
	clk, instruction, 
	intOper1, intOper2, 
	vOper1, vOper2, 
	cond, enableAluInt, enableAluV, enableMem, enableJump, flagImm, ImmOut,
	jumpAddress,
	flagEnd,
	flagNop,
	flagMemRead,
	flagMemWrite,
	swapBitOrigin,swapBitDest,
	intRegDest,vRegDest,aluOpcode,enableSwap
	);
	
	initial begin
		#period;
		instruction = 16'b0000100011000000;//cmp r2, r3 
		#period;
		#period;
		instruction = 16'b0000000000000001;//jne #1
		#period;
		#period;
		instruction = 16'b0000110001100010;//vxoreq v1, v2, r3
		#period;
		#period;
		instruction = 16'b0110011111100011;//vxorigt v0, v3, #30
		#period;
		#period;
		instruction = 16'b1010100001100100;//vldal r10, v0, #3
		#period;
		#period;
		instruction = 16'b0010010111100101;//vstreq r9, v1, #7
		#period;
		#period;
		instruction = 16'b0101011100000110;//vsrgt v2, v3, r8
		#period;
		#period;
		instruction = 16'b1001011100000111;//vslal v2, v3, r8
		#period;
		#period;
		instruction = 16'b1110111010011000;//vswapne v2, v3, #5, #1
		#period;
		#period;
		instruction = 16'b0111111111101001;//add r7, r15, r14
		#period;
		#period;
		instruction = 16'b1101110010111010;//sub r13, r12, r11
		#period;
		instruction = 16'b0110010111101011;//addi r6, r5, #14
		#period;
		#period;
		instruction = 16'b0011001010011100;//subi r3, r2, #9
		#period;
		#period;
		instruction = 16'b0000000000001101;//nop
		#period;
		#period;
		instruction = 16'b0000000000001110;//end
		#period;
		#period;
	end
endmodule
	