module mux_21(
    input         sel_i,
    input  [31:0] din0_i,
    input  [31:0] din1_i,
    output [31:0] dout_o
);

    assign dout_o = (sel_i)? din1_i : din0_i;
    
endmodule
