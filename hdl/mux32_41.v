module mux32_41(
    input [1:0]  sel_i,
    input [31:0] din0_i,
    input [31:0] din1_i,
    input [31:0] din2_i,
    input [31:0] din3_i,
    output reg [31:0] dout_o
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
