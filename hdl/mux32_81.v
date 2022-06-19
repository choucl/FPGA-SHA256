module mux32_81(
    input [2:0]  sel_i,
    input [31:0] din0_i,
    input [31:0] din1_i,
    input [31:0] din2_i,
    input [31:0] din3_i,
    input [31:0] din4_i,
    input [31:0] din5_i,
    input [31:0] din6_i,
    input [31:0] din7_i,
    output reg [31:0] dout_o
);

    always @(*) begin
        case (sel_i) 
            0: dout_o = din0_i;
            1: dout_o = din1_i;
            2: dout_o = din2_i;
            3: dout_o = din3_i;
            4: dout_o = din0_i;
            5: dout_o = din1_i;
            6: dout_o = din2_i;
            7: dout_o = din3_i;
        endcase
    end

endmodule
