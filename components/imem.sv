module imem(input  logic [15:0] a,
            output logic [15:0] rd);

  logic [15:0] RAM[63:0];

  initial
      $readmemh("G:/superEncriptador4k/dataReg.dat", RAM);

  assign rd = RAM[a]; // word aligned
endmodule