module tbFetchToDecode #(
    parameter REGI_BITS = 4,
    parameter VECT_BITS = 2,
    parameter VECT_LANES = 3,
    parameter MEMO_LINES = 64,
    parameter REGI_SIZE = 16,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
)();
    logic                 clk, rst;
    logic [REGI_SIZE-1:0] next_pc_p1;

    // Fetch Var
    logic        int_we;
    logic [REGI_SIZE-1:0] int_a_i, int_wd_i;
    logic [REGI_SIZE-1:0] int_rd_o;
    logic [REGI_SIZE-1:0] next_pc_i;
    logic [REGI_SIZE-1:0] instr_p, instr_o;

    // Decode Var
	 logic [REGI_BITS-1:0]             reg_dest_o;
	 logic [VECT_BITS-1:0]             vec_dest_o;
	 logic [REGI_SIZE-1:0]             intOper1;
	 logic [REGI_SIZE-1:0]             intOper2;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper1;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOper2;
	 logic [(ELEM_SIZE*VECT_SIZE)-1:0] vOperImm, vOperCop;
	 logic [REGI_BITS-1:0] intRegDest;
	 logic [VECT_BITS-1:0] vecRegDest; 
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
	 logic isOper1V;
	 logic isOper2V;
	 logic isOper1Int;
	 logic isOper2Int;
	 logic writeResultInt;
	 logic writeResultV;
	 logic [3:0] alu_flags_o;
    

    fStage #(REGI_BITS, REGI_SIZE) 
        dut(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_i),
            .next_pc_o(next_pc_p1),
            .instr_o(instr_p)
            );

    fPipe #(REGI_BITS, REGI_SIZE) 
        ifid_pipe(.clk_i(clk), .rst_i(rst),
            .next_pc_i(next_pc_p1),
            .instr_i(instr_p),
            .next_pc_o(next_pc_i),
            .instr_o(instr_o)
            );

    superDecoder #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
        decoder(.clk(clk||rst), .rst(rst), 
            .instruction(instr_o),
            .next_pc_i(next_pc_i),
            .reg_dest_o(reg_dest_o),
            .vec_dest_o(vec_dest_o),
            .vOper1(vOper1), 
            .vOper2(vOper2),
            .intOper1(intOper1), 
            .intOper2(intOper2), 
            .vOperImm(vOperImm), 
            .vOperCop(vOperCop),
            .cond(cond),
            .enableAluInt(enableAluInt), 
            .enableAluV(enableAluV), 
            .enableMem(enableMem), 
            .enableJump(enableJump), 
            .flagImm(flagImm), 
            .ImmOut(ImmOut),
            .jumpAddress(jumpAddress),
            .flagEnd(flagEnd),
            .flagNop(flagNop),
            .flagMemRead(flagMemRead),
            .flagMemWrite(flagMemWrite),
            .swapBitOrigin(swapBitOrigin),
            .swapBitDest(swapBitDest),
            .intRegDest(intRegDest),
            //.vRegDest(vRegDest),
            .enableSwap(enableSwap),
            .aluOpcode(aluOpcode),
            .isOper1V(isOper1V),
	        .isOper2V(isOper2V),
            .isOper1Int(isOper1Int),
            .isOper2Int(isOper2Int),
            .writeResultInt(writeResultInt),
            .writeResultV(writeResultV)
            );
    
    initial begin
        #0 
        rst <= 1;
        
        #50
        rst <= 0;
        next_pc_i <= 0;
    end
    always begin
        #5 clk <= 1;
        #5 clk <= 0;
    end
endmodule

/*
vlog -reportprogress 300 -work work G:/superEncriptador4k/fPipe.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/fiPipe.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/fStage.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/tbFetchToDecode.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/imem.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/or_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/xor_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/and_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/one_bit_half_adder.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/one_bit_full_adder.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/adder.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/flip_flop.sv

vsim work.tbFetchToDecode

add wave -position end  sim:/tbFetchToDecode/next_pc_p1
add wave -position end  sim:/tbFetchToDecode/int_we
add wave -position end  sim:/tbFetchToDecode/int_a_i
add wave -position end  sim:/tbFetchToDecode/int_wd_i
add wave -position end  sim:/tbFetchToDecode/int_rd_o
add wave -position end  sim:/tbFetchToDecode/next_pc_i
add wave -position end  sim:/tbFetchToDecode/instr_p
add wave -position end  sim:/tbFetchToDecode/instr_o
add wave -position end  sim:/tbFetchToDecode/reg_dest_o
add wave -position end  sim:/tbFetchToDecode/vec_dest_o
add wave -position end  sim:/tbFetchToDecode/intOper1
add wave -position end  sim:/tbFetchToDecode/intOper2
add wave -position end  sim:/tbFetchToDecode/vOper1
add wave -position end  sim:/tbFetchToDecode/vOper2
add wave -position end  sim:/tbFetchToDecode/vOperImm
add wave -position end  sim:/tbFetchToDecode/vOperCop
add wave -position end  sim:/tbFetchToDecode/intRegDest
add wave -position end  sim:/tbFetchToDecode/vecRegDest
add wave -position end  sim:/tbFetchToDecode/decoder/miniDecoder/intOper1
add wave -position end  sim:/tbFetchToDecode/decoder/miniDecoder/intOper2
add wave -position end  sim:/tbFetchToDecode/decoder/miniDecoder/vOper1
add wave -position end  sim:/tbFetchToDecode/decoder/miniDecoder/vOper2
add wave -position end  sim:/tbFetchToDecode/cond
add wave -position end  sim:/tbFetchToDecode/enableAluInt
add wave -position end  sim:/tbFetchToDecode/enableAluV
add wave -position end  sim:/tbFetchToDecode/enableMem
add wave -position end  sim:/tbFetchToDecode/enableJump
add wave -position end  sim:/tbFetchToDecode/enableSwap
add wave -position end  sim:/tbFetchToDecode/flagEnd
add wave -position end  sim:/tbFetchToDecode/flagNop
add wave -position end  sim:/tbFetchToDecode/flagImm
add wave -position end  sim:/tbFetchToDecode/ImmOut
add wave -position end  sim:/tbFetchToDecode/aluOpcode
add wave -position end  sim:/tbFetchToDecode/jumpAddress
add wave -position end  sim:/tbFetchToDecode/flagMemRead
add wave -position end  sim:/tbFetchToDecode/flagMemWrite
add wave -position end  sim:/tbFetchToDecode/swapBitOrigin
add wave -position end  sim:/tbFetchToDecode/swapBitDest
add wave -position end  sim:/tbFetchToDecode/isOper1V
add wave -position end  sim:/tbFetchToDecode/isOper2V
add wave -position end  sim:/tbFetchToDecode/isOper1Int
add wave -position end  sim:/tbFetchToDecode/isOper2Int
add wave -position end  sim:/tbFetchToDecode/writeResultInt
add wave -position end  sim:/tbFetchToDecode/writeResultV
add wave -position end  sim:/tbFetchToDecode/alu_flags_o
add wave -position end  sim:/tbFetchToDecode/decoder/instruction
add wave -position end  sim:/tbFetchToDecode/clk
add wave -position end  sim:/tbFetchToDecode/rst
*/
