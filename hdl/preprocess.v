`ifndef _DEF
`define _DEF
`include "def.v"
`endif

module preprocess(
    input clk_i,
    input rst_ni,
    input [`IB_WIDTH-1:0] data_i,
    output [`IB_WIDTH-1:0] w_o
);

    reg [`IB_WIDTH-1:0] data_reg [`DATA_REG_NUM-1:0];
    reg [`W_WIDTH-1:0] x_w15, x_w2, w16, w7;
    reg [`W_WIDTH-1:0] x_w14, x_w1, w15, w6;

    wire [`W_WIDTH-1:0] w15rr7, w15rr18, w15rr3, w2rr17, w2rr19, w2rr3;
    wire [`W_WIDTH-1:0] w14rr7, w14rr18, w14rr3, w1rr17, w1rr19, w1rr3;

    assign w15rr7  = {data_reg[7][38:32], data_reg[7][63:39]};
    assign w15rr18 = {data_reg[7][49:32], data_reg[7][63:50]};
    assign w15rr3  = {data_reg[7][34:32], data_reg[7][63:35]};

    assign w2rr17 = {data_reg[0][16:0], data_reg[0][31:17]};
    assign w2rr19 = {data_reg[0][18:0], data_reg[0][31:19]};
    assign w2rr3  = {data_reg[0][2:0], data_reg[0][31:3]};

    assign w14rr7  = {data_reg[6][6:0], data_reg[6][31:7]};
    assign w14rr18 = {data_reg[6][17:0], data_reg[6][31:18]};
    assign w14rr3  = {data_reg[6][2:0], data_reg[6][31:3]};

    assign w1rr17 = {data_reg[0][48:32], data_reg[0][63:49]};
    assign w1rr19 = {data_reg[0][50:32], data_reg[0][63:51]};
    assign w1rr3  = {data_reg[0][34:32], data_reg[0][63:35]};

    assign w_o = {x_w14 ^ x_w1 ^ w15 ^ w6, x_w15, x_w2, w16, w7};

    always @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 1'b0) begin
            data_reg[0] <= 64'b0;
            data_reg[1] <= 64'b0;
            data_reg[2] <= 64'b0;
            data_reg[3] <= 64'b0;
            data_reg[4] <= 64'b0;
            data_reg[5] <= 64'b0;
            data_reg[6] <= 64'b0;
            data_reg[7] <= 64'b0;
            x_w15       <= 32'b0;
            x_w2        <= 32'b0;
            w16         <= 32'b0;
            w7          <= 32'b0;
            x_w14       <= 32'b0;
            x_w1        <= 32'b0;
            w15         <= 32'b0;
            w6          <= 32'b0;
        end else begin
            data_reg[7] <= data_reg[6];
            data_reg[6] <= data_reg[5];
            data_reg[5] <= data_reg[4];
            data_reg[4] <= data_reg[3];
            data_reg[3] <= data_reg[2];
            data_reg[2] <= data_reg[1];
            data_reg[1] <= data_reg[0];
            data_reg[0] <= data_i;
            x_w15 <= w15rr7 ^ w15rr18 ^ w15rr3;
            x_w2  <= w2rr17 ^ w2rr19 ^ w2rr3;
            w16   <= data_reg[7][31:0];
            w7    <= data_reg[3][63:32];
            x_w14 <= w14rr7 ^ w14rr18 ^ w14rr3;
            x_w1  <= w1rr17 ^ w1rr19 ^ w1rr3;
            w15   <= data_reg[7][63:32];
            w6    <= data_reg[2][31:0];
        end
    end
endmodule