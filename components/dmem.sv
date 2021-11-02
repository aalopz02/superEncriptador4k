module dmem #(
    parameter DATA_WIDTH = 64, 
    parameter DATA_SLOTS = 16
)(
     input logic clk, we,
     input logic [DATA_WIDTH-1:0] a, wd,
    output logic [DATA_WIDTH-1:0] rd
);
    logic [DATA_WIDTH-1:0] RAM[DATA_SLOTS-1:0];
    assign rd = RAM[a[DATA_WIDTH-1:2]]; // word aligned
    always_ff @(posedge clk)
        if (we) RAM[a[DATA_WIDTH-1:2]] <= wd;
endmodule