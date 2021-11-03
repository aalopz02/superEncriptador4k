module tbFetchToExecute #(
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
            .alu_flags_i(alu_flags_o),
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
    
    // Execute Var
     logic             [ELEM_SIZE-1:0] ialu_res_o;
     logic [(ELEM_SIZE*VECT_SIZE)-1:0] valu_res_o;
     logic                             enableMem_o;
     logic                             enableReg_o;
	 logic                             enableJump_o;
     logic                             flagMemRead_o;
	 logic                             flagMemWrite_o;
     logic                             isOper1V_o;
	 logic isOper2V_o;
	 logic isOper1Int_o;
	 logic isOper2Int_o;
	 logic writeResultInt_o;
	 logic writeResultV_o;
    
    superExecute #(REGI_BITS, VECT_BITS, VECT_LANES, MEMO_LINES, REGI_SIZE, VECT_SIZE, ELEM_SIZE)
        execute(.clk_i(clk), .rst_i(rst),
            .int_rsa_i(intOper1), 
            .int_rsb_i(intOper2),
            .vec_rsa_i(vOper1), 
            .vec_rsb_i(vOper2),
            .cond(cond),
            .enableAluInt(enableAluInt), 
            .enableAluV(enableAluV), 
            .enableMem(enableMem), 
            .enableJump(enableJump), 
            .enableReg(enableReg),
            .flagImm(flagImm), 
            .ImmOut(ImmOut),
            .jumpAddress(jumpAddress),
            .flagEnd(flagEnd),
            .flagNop(flagNop),
            .flagMemRead(flagMemRead),
            .flagMemWrite(flagMemWrite),
            .swapBitOrigin(swapBitOrigin),
            .swapBitDest(swapBitDest),
            .enableSwap(enableSwap),
            .aluOpcode(aluOpcode),
            .ialu_res_o(ialu_res_o),
            .valu_res_o(valu_res_o),
            .enableMem_o(enableMem_o),
            .enableReg_o(enableReg_o), 
            .enableJump_o(enableJump_o), 
            .flagMemRead_o(flagMemRead_o),
            .flagMemWrite_o(flagMemWrite_o),
            .alu_flags_o(alu_flags_o)
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
vlog -reportprogress 300 -work work G:/superEncriptador4k/superExecute.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/eStage.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/ePipe.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/tbFetchToExecute.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/singleSwapper.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/vSwapperBlock.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/mux2.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/alu.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/condUnit.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/mux_four.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/shift_right_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/shif_left_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/adder_substractor.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/mux_eight.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/vAluBlock.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/imem.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/or_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/xor_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/and_gate.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/one_bit_half_adder.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/one_bit_full_adder.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/adder.sv
vlog -reportprogress 300 -work work G:/superEncriptador4k/components/flip_flop.sv

vsim work.tbFetchToExecute

add wave -position end  sim:/tbFetchToExecute/reg_dest_o
add wave -position end  sim:/tbFetchToExecute/vec_dest_o
add wave -position end  sim:/tbFetchToExecute/intOper1
add wave -position end  sim:/tbFetchToExecute/intOper2
add wave -position end  sim:/tbFetchToExecute/vOper1
add wave -position end  sim:/tbFetchToExecute/vOper2
add wave -position end  sim:/tbFetchToExecute/vOperImm
add wave -position end  sim:/tbFetchToExecute/vOperCop
add wave -position end  sim:/tbFetchToExecute/intRegDest
add wave -position end  sim:/tbFetchToExecute/vecRegDest
add wave -position end  sim:/tbFetchToExecute/cond
add wave -position end  sim:/tbFetchToExecute/enableAluInt
add wave -position end  sim:/tbFetchToExecute/enableAluV
add wave -position end  sim:/tbFetchToExecute/enableMem
add wave -position end  sim:/tbFetchToExecute/enableJump
add wave -position end  sim:/tbFetchToExecute/enableSwap
add wave -position end  sim:/tbFetchToExecute/flagEnd
add wave -position end  sim:/tbFetchToExecute/flagNop
add wave -position end  sim:/tbFetchToExecute/flagImm
add wave -position end  sim:/tbFetchToExecute/ImmOut
add wave -position end  sim:/tbFetchToExecute/aluOpcode
add wave -position end  sim:/tbFetchToExecute/jumpAddress
add wave -position end  sim:/tbFetchToExecute/flagMemRead
add wave -position end  sim:/tbFetchToExecute/flagMemWrite
add wave -position end  sim:/tbFetchToExecute/swapBitOrigin
add wave -position end  sim:/tbFetchToExecute/swapBitDest
add wave -position end  sim:/tbFetchToExecute/isOper1V
add wave -position end  sim:/tbFetchToExecute/isOper2V
add wave -position end  sim:/tbFetchToExecute/isOper1Int
add wave -position end  sim:/tbFetchToExecute/isOper2Int
add wave -position end  sim:/tbFetchToExecute/writeResultInt
add wave -position end  sim:/tbFetchToExecute/writeResultV
add wave -position end  sim:/tbFetchToExecute/alu_flags_o
add wave -position end  sim:/tbFetchToExecute/ialu_res_o
add wave -position end  sim:/tbFetchToExecute/valu_res_o
add wave -position end  sim:/tbFetchToExecute/enableMem_o
add wave -position end  sim:/tbFetchToExecute/enableReg_o
add wave -position end  sim:/tbFetchToExecute/enableJump_o
add wave -position end  sim:/tbFetchToExecute/flagMemRead_o
add wave -position end  sim:/tbFetchToExecute/flagMemWrite_o
add wave -position end  sim:/tbFetchToExecute/isOper1V_o
add wave -position end  sim:/tbFetchToExecute/isOper2V_o
add wave -position end  sim:/tbFetchToExecute/isOper1Int_o
add wave -position end  sim:/tbFetchToExecute/isOper2Int_o
add wave -position end  sim:/tbFetchToExecute/writeResultInt_o
add wave -position end  sim:/tbFetchToExecute/writeResultV_o
add wave -position end  sim:/tbFetchToExecute/enableReg
add wave -position end  sim:/tbFetchToExecute/decoder/instruction
add wave -position end  sim:/tbFetchToExecute/clk
add wave -position end  sim:/tbFetchToExecute/rst

add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/voper1
add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/voper2
add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/vresult
add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/dataIn
add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/oper1
add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/oper2
add wave -position end  sim:/tbFetchToExecute/decoder/vec_regfile/matrix
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/vectorOper1
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/vectorOper2
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/result
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/opCode
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/opCodeAux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/vectorOper1Aux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/vectorOper2Aux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_alu/resultAux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/oper
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/pos1
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/pos2
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/res
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/oper1Aux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/oper2Aux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/fu_vec_swa/resAux
add wave -position end  sim:/tbFetchToExecute/execute/ex_stage/elVOper2


add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/ra1
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/ra2
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/wa3
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/pc
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/wd3
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/rd1
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/rd2
add wave -position end  sim:/tbFetchToExecute/decoder/int_regfile/rf
add wave -position end  sim:/tbFetchToExecute/decoder/idex_pipe/intOper1_i
add wave -position end  sim:/tbFetchToExecute/decoder/idex_pipe/intOper2_i
add wave -position end  sim:/tbFetchToExecute/decoder/idex_pipe/intOper1_o
add wave -position end  sim:/tbFetchToExecute/decoder/idex_pipe/intOper2_o
add wave -position end  sim:/tbFetchToExecute/decoder/miniDecoder/intOper1
add wave -position end  sim:/tbFetchToExecute/decoder/miniDecoder/intOper2
*/