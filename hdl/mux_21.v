module mux_21(
    input  sel_i,
    input  din0_i,
    input  din1_i,
    output dout_o
);

    assign dout_o = (sel_i)? din1_i : din0_i;
    
endmodule
