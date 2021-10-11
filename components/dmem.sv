module dmem #(
    parameter P = 16, 
    parameter S = 16
)(
     input logic clk, we,
     input logic [P:0] a, wd,
    output logic [P:0] rd
);
    logic [P-1:0] RAM[S-1:0];
    assign rd = RAM[a[P-1:2]]; // word aligned
    always_ff @(posedge clk)
        if (we) RAM[a[P-1:2]] <= wd;
endmodule