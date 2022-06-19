module mux_41(
    input [1:0] sel_i,
    input       din0_i,
    input       din1_i,
    input       din2_i,
    input       din3_i,
    output reg  dout_o
);

    always @(*) begin
        case (sel_i) 
            0: dout_o = din0_i;
            1: dout_o = din1_i;
            2: dout_o = din2_i;
            3: dout_o = din3_i;
        endcase
    end

endmodule
