module dmem #(
    parameter DATA_SLOTS = 64,
    parameter VECT_SIZE = 8,
    parameter ELEM_SIZE = 8
)(
     input logic clk, we,
     input logic [(ELEM_SIZE*VECT_SIZE)-1:0] a, wd,
    output logic [(ELEM_SIZE*VECT_SIZE)-1:0] rd
);
    logic [(ELEM_SIZE*VECT_SIZE)-1:0] RAM[DATA_SLOTS-1:0];
    assign rd = RAM[a[(ELEM_SIZE*VECT_SIZE)-1:2]]; // word aligned
    always_ff @(posedge clk)
        if (we) RAM[a[(ELEM_SIZE*VECT_SIZE)-1:2]] <= wd;
endmodule