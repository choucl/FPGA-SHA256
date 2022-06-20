/*
 * Input w0 to w15 and produces w16 to w63
 * For w0 is input at 0'th cycle, w16 will be produced at 64'th cycle,
 * and w63 will come out at 252'th cycle 
 */
module expander(
    input clk_i,
    input rst_ni,
    input send_i,
    input [31:0] data_i,     // Input w
    output reg [31:0] data_o // Output w
);

reg [31:0] w1_0, w1_1, w1_2, w1_3, w2_0, w2_1, w2_2, w2_3;
reg [31:0] w3_0, w3_1, w3_2, w3_3, w4_0, w4_1, w4_2, w4_3;
reg [31:0] w5_0, w5_1, w5_2, w5_3, w6_0, w6_1, w6_2, w6_3;
reg [31:0] w7_0, w7_1, w7_2, w7_3, w8_0, w8_1, w8_2, w8_3;
reg [31:0] w9_0, w9_1, w9_2, w9_3, w10_0, w10_1, w10_2, w10_3;
reg [31:0] w11_0, w11_1, w11_2, w11_3, w12_0, w12_1, w12_2, w12_3;
reg [31:0] w13_0, w13_1, w13_2, w13_3, w14_0, w14_1, w14_2, w14_3;
reg [31:0] w15_0, w15_1, w15_2, w15_3, w16_0, w16_1, w16_2, w16_3;

// Stage 0
wire [31:0] w15_rr_7, w15_rr_18, w15_rs_3;
assign w15_rr_7 = {w15_0[6:0], w15_0[31:7]};
assign w15_rr_18 = {w15_0[17:0], w15_0[31:18]};
assign w15_rs_3 = {3'd0, w15_0[31:3]};

wire [31:0] w2_rr_17, w2_rr_19, w2_rs_10;
assign w2_rr_17 = {w2_0[16:0], w2_0[31:17]};
assign w2_rr_19 = {w2_0[18:0], w2_0[31:19]};
assign w2_rs_10 = {10'd0, w2_0[31:10]};

wire [31:0] s0_w;
wire [31:0] s1_w;
assign s0_w = w15_rr_7 ^ w15_rr_18 ^ w15_rs_3;
assign s1_w = w2_rr_17 ^ w2_rr_19 ^ w2_rs_10;

wire [31:0] s0_w16_w;
assign s0_w16_w = s0_w + w16_0;

wire [31:0] s1_w7_w;
assign s1_w7_w = s1_w + w7_0;
// Stage 1
reg [31:0] s0_w16 ,s1_w7;
reg [31:0] sum;
wire [31:0] sum_w;
assign sum_w = s0_w16 + s1_w7;
// Stage 2
reg [31:0] w_new;

always @(posedge clk_i or posedge ~rst_ni) begin
    if (~rst_ni) begin
        w1_0 <= 32'd0;
        w1_1 <= 32'd0;
        w1_2 <= 32'd0;
        w1_3 <= 32'd0;
        w2_0 <= 32'd0;
        w2_1 <= 32'd0;
        w2_2 <= 32'd0;
        w2_3 <= 32'd0;
        w3_0 <= 32'd0;
        w3_1 <= 32'd0;
        w3_2 <= 32'd0;
        w3_3 <= 32'd0;
        w4_0 <= 32'd0;
        w4_1 <= 32'd0;
        w4_2 <= 32'd0;
        w4_3 <= 32'd0;
        w5_0 <= 32'd0;
        w5_1 <= 32'd0;
        w5_2 <= 32'd0;
        w5_3 <= 32'd0;
        w6_0 <= 32'd0;
        w6_1 <= 32'd0;
        w6_2 <= 32'd0;
        w6_3 <= 32'd0;
        w7_0 <= 32'd0;
        w7_1 <= 32'd0;
        w7_2 <= 32'd0;
        w7_3 <= 32'd0;
        w8_0 <= 32'd0;
        w8_1 <= 32'd0;
        w8_2 <= 32'd0;
        w8_3 <= 32'd0;
        w9_0 <= 32'd0;
        w9_1 <= 32'd0;
        w9_2 <= 32'd0;
        w9_3 <= 32'd0;
        w10_0 <= 32'd0;
        w10_1 <= 32'd0;
        w10_2 <= 32'd0;
        w10_3 <= 32'd0;
        w11_0 <= 32'd0;
        w11_1 <= 32'd0;
        w11_2 <= 32'd0;
        w11_3 <= 32'd0;
        w12_0 <= 32'd0;
        w12_1 <= 32'd0;
        w12_2 <= 32'd0;
        w12_3 <= 32'd0;
        w13_0 <= 32'd0;
        w13_1 <= 32'd0;
        w13_2 <= 32'd0;
        w13_3 <= 32'd0;
        w14_0 <= 32'd0;
        w14_1 <= 32'd0;
        w14_2 <= 32'd0;
        w14_3 <= 32'd0;
        w15_0 <= 32'd0;
        w15_1 <= 32'd0;
        w15_2 <= 32'd0;
        w15_3 <= 32'd0;
        w16_0 <= 32'd0;
        w16_1 <= 32'd0;
        w16_2 <= 32'd0;
        w16_3 <= 32'd0;
        s0_w16 <= 32'd0;
        s1_w7 <= 32'd0;
        sum <= 32'd0;
        w_new <= 32'd0;
        data_o <= 32'd0;
    end else begin
        // Get w from BRAM or FIFO
        if (send_i) begin
            w1_0 <= data_i; // Consume input data to FIFO
        end else begin
            w1_0 <= w_new;
        end
        // Calculations
        // Stage 0
        s0_w16 <= s0_w16_w;
        s1_w7 <= s1_w7_w;
        // Stage 1
        sum <= sum_w;
        // Stage 2
        w_new <= sum;
        // Stage 3
        data_o <= w_new; // Output data

        // FIFOs
        w1_1 <= w1_0;
        w1_2 <= w1_1;
        w1_3 <= w1_2;
        w2_0 <= w1_3;
        w2_1 <= w2_0;
        w2_2 <= w2_1;
        w2_3 <= w2_2;
        w3_0 <= w2_3;
        w3_1 <= w3_0;
        w3_2 <= w3_1;
        w3_3 <= w3_2;
        w4_0 <= w3_3;
        w4_1 <= w4_0;
        w4_2 <= w4_1;
        w4_3 <= w4_2;
        w5_0 <= w4_3;
        w5_1 <= w5_0;
        w5_2 <= w5_1;
        w5_3 <= w5_2;
        w6_0 <= w5_3;
        w6_1 <= w6_0;
        w6_2 <= w6_1;
        w6_3 <= w6_2;
        w7_0 <= w6_3;
        w7_1 <= w7_0;
        w7_2 <= w7_1;
        w7_3 <= w7_2;
        w8_0 <= w7_3;
        w8_1 <= w8_0;
        w8_2 <= w8_1;
        w8_3 <= w8_2;
        w9_0 <= w8_3;
        w9_1 <= w9_0;
        w9_2 <= w9_1;
        w9_3 <= w9_2;
        w10_0 <= w9_3;
        w10_1 <= w10_0;
        w10_2 <= w10_1;
        w10_3 <= w10_2;
        w11_0 <= w10_3;
        w11_1 <= w11_0;
        w11_2 <= w11_1;
        w11_3 <= w11_2;
        w12_0 <= w11_3;
        w12_1 <= w12_0;
        w12_2 <= w12_1;
        w12_3 <= w12_2;
        w13_0 <= w12_3;
        w13_1 <= w13_0;
        w13_2 <= w13_1;
        w13_3 <= w13_2;
        w14_0 <= w13_3;
        w14_1 <= w14_0;
        w14_2 <= w14_1;
        w14_3 <= w14_2;
        w15_0 <= w14_3;
        w15_1 <= w15_0;
        w15_2 <= w15_1;
        w15_3 <= w15_2;
        w16_0 <= w15_3;
        w16_1 <= w16_0;
        w16_2 <= w16_1;
        w16_3 <= w16_2;
    end
end

endmodule