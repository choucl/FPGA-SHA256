/* 
 * Main loop of SHA256 algorithm
 * It takes 256 cycles to finish 64 iters
 */
module main_loop(
    input clk_i,
    input rst_ni,
    input clr_i,
    input update_i,
    input [31:0] w_i,
    input [31:0] k_i,
    output reg [31:0] H00, // The 1st hash set, the output
    output reg [31:0] H01,
    output reg [31:0] H02,
    output reg [31:0] H03,
    output reg [31:0] H04,
    output reg [31:0] H05,
    output reg [31:0] H06,
    output reg [31:0] H07
);

// FIFOs for hash
reg [31:0] H10, H11, H12, H13, H14, H15, H16, H17; // The 2nd hash set
reg [31:0] H20, H21, H22, H23, H24, H25, H26, H27; // The 3rd hash set
reg [31:0] H30, H31, H32, H33, H34, H35, H36, H37; // The 4th hash set

// FIFOs of abcdefgh
reg [31:0] a0, a1, a2, a3;
reg [31:0] b0, b1, b2, b3;
reg [31:0] c0, c1, c2, c3;
reg [31:0] d0, d1, d2, d3;
reg [31:0] e0, e1, e2, e3;
reg [31:0] f0, f1, f2, f3;
reg [31:0] g0, g1, g2, g3;
reg [31:0] h0, h1, h2, h3;
// w_i and k_i
reg [31:0] w0;
reg [31:0] k0;

wire [31:0] a_rr_2 = {a0[1:0], a0[31:2]};
wire [31:0] a_rr_13 = {a0[12:0], a0[31:13]};
wire [31:0] a_rr_22 = {a0[21:0], a0[31:22]};

wire [31:0] e_rr_6 = {e0[5:0], e0[31:6]};
wire [31:0] e_rr_11 = {e0[10:0], e0[31:11]};
wire [31:0] e_rr_25 = {e0[24:0], e0[31:25]};

wire [31:0] a_and_b, a_and_c, b_and_c, e_and_f, ne_and_g;

assign a_and_b = a0 & b0;
assign a_and_c = a0 & c0;
assign b_and_c = b0 & c0;
assign e_and_f = e0 & f0;
assign ne_and_g = (~e0) & f0;

// Stage 0
reg [31:0] s0, s1, maj, ch, kw;
wire [31:0] s0_w, s1_w, maj_w, ch_w, kw_w;

assign s0_w = a_rr_2 ^ a_rr_13 ^ a_rr_22;
assign s1_w = e_rr_6 ^ e_rr_11 ^ e_rr_25;
assign maj_w = a_and_b ^ b_and_c ^ a_and_c;
assign ch_w = e_and_f ^ ne_and_g;
assign kw_w = w0 + k0;
// Stage 1
reg [31:0] s0_maj, s1_ch, hkw;
wire [31:0] s0_maj_w, s1_ch_w, hkw_w;

assign s0_maj_w = s0 + maj;
assign s1_ch_w = s1 + ch;
assign hkw_w = h1 + kw;
// Stage 2
reg [31:0] t1, t2;
wire [31:0] t1_w;
assign t1_w = s1_ch + hkw;
// Stage 3
wire [31:0] new_a, new_e;
assign new_a = t1 + t2;
assign new_e = t2 + d3;

wire [31:0] H0_new, H1_new, H2_new, H3_new;
wire [31:0] H4_new, H5_new, H6_new, H7_new;

assign H0_new = H30 + new_a; // H0 = a + H0
assign H1_new = H31 + a3;    // H1 = b + H1
assign H2_new = H32 + b3;    // H2 = c + H2
assign H3_new = H33 + c3;    // H3 = d + H3
assign H4_new = H34 + new_e; // H4 = e + H4
assign H5_new = H35 + e3;    // H5 = f + H5
assign H6_new = H36 + f3;    // H6 = g + H6
assign H7_new = H37 + g3;    // H7 = h + H7

always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        // Reset hash values
        H00 <= 32'h6a09e667;
        H01 <= 32'hbb67ae85;
        H02 <= 32'h3c6ef372;
        H03 <= 32'ha54ff53a;
        H04 <= 32'h510e527f;
        H05 <= 32'h9b05688c;
        H06 <= 32'h1f83d9ab;
        H07 <= 32'h5be0cd19;
        H10 <= 32'h6a09e667;
        H11 <= 32'hbb67ae85;
        H12 <= 32'h3c6ef372;
        H13 <= 32'ha54ff53a;
        H14 <= 32'h510e527f;
        H15 <= 32'h9b05688c;
        H16 <= 32'h1f83d9ab;
        H17 <= 32'h5be0cd19;
        H20 <= 32'h6a09e667;
        H21 <= 32'hbb67ae85;
        H22 <= 32'h3c6ef372;
        H23 <= 32'ha54ff53a;
        H24 <= 32'h510e527f;
        H25 <= 32'h9b05688c;
        H26 <= 32'h1f83d9ab;
        H27 <= 32'h5be0cd19;
        H30 <= 32'h6a09e667;
        H31 <= 32'hbb67ae85;
        H32 <= 32'h3c6ef372;
        H33 <= 32'ha54ff53a;
        H34 <= 32'h510e527f;
        H35 <= 32'h9b05688c;
        H36 <= 32'h1f83d9ab;
        H37 <= 32'h5be0cd19;
    end else begin
        if (clr_i) begin
            // Clear 1st hash set
            H00 <= 32'h6a09e667;
            H01 <= 32'hbb67ae85;
            H02 <= 32'h3c6ef372;
            H03 <= 32'ha54ff53a;
            H04 <= 32'h510e527f;
            H05 <= 32'h9b05688c;
            H06 <= 32'h1f83d9ab;
            H07 <= 32'h5be0cd19;
        end else begin 
            if (update_i) begin
                // Update output hash value
                H00 <= H0_new;
                H01 <= H1_new;
                H02 <= H2_new;
                H03 <= H3_new;
                H04 <= H4_new;
                H05 <= H5_new;
                H06 <= H6_new;
                H07 <= H7_new;
            end else begin
                // FIFOs for hash
                H00 <= H30;
                H01 <= H31;
                H02 <= H32;
                H03 <= H33;
                H04 <= H34;
                H05 <= H35;
                H06 <= H36;
                H07 <= H37;
            end
            // FIFOs for hash
            // 1st -> 2nd
            H10 <= H00;
            H11 <= H01;
            H12 <= H02;
            H13 <= H03;
            H14 <= H04;
            H15 <= H05;
            H16 <= H06;
            H17 <= H07;
            // 2nd -> 3rd
            H20 <= H10;
            H21 <= H11;
            H22 <= H12;
            H23 <= H13;
            H24 <= H14;
            H25 <= H15;
            H26 <= H16;
            H27 <= H17;
            // 3rd -> 4th
            H30 <= H20;
            H31 <= H21;
            H32 <= H22;
            H33 <= H23;
            H34 <= H24;
            H35 <= H25;
            H36 <= H26;
            H37 <= H27;
        end
    end   
end

always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        a0 <= 32'h6a09e667;
        b0 <= 32'hbb67ae85;
        c0 <= 32'h3c6ef372;
        d0 <= 32'ha54ff53a;
        e0 <= 32'h510e527f;
        f0 <= 32'h9b05688c;
        g0 <= 32'h1f83d9ab;
        h0 <= 32'h5be0cd19;

        a1 <= 32'd0;
        a2 <= 32'd0;
        a3 <= 32'd0;

        b1 <= 32'd0;
        b2 <= 32'd0;
        b3 <= 32'd0;

        c1 <= 32'd0;
        c2 <= 32'd0;
        c3 <= 32'd0;

        d1 <= 32'd0;
        d2 <= 32'd0;
        d3 <= 32'd0;

        e1 <= 32'd0;
        e2 <= 32'd0;
        e3 <= 32'd0;

        f1 <= 32'd0;
        f2 <= 32'd0;
        f3 <= 32'd0;

        g1 <= 32'd0;
        g2 <= 32'd0;
        g3 <= 32'd0;

        h1 <= 32'd0;
        h2 <= 32'd0;
        h3 <= 32'd0;

        w0 <= 32'd0;
        k0 <= 32'd0;

        s0 <= 32'd0;
        maj <= 32'd0;
        s1 <= 32'd0;
        ch <= 32'd0;
        kw <= 32'd0;

        s0_maj <= 32'd0;
        s1_ch <= 32'd0;
        hkw <= 32'd0;

        t2 <= 32'd0;
        t1 <= 32'd0;
    end else begin
        // Main loop caculation
        // w_i and k_i
        w0 <= w_i;
        k0 <= k_i;
        // Stage 0
        s0 <= s0_w;   // s0 <= a_rr_2 ^ a_rr_13 ^ a_rr_22;
        maj <= maj_w; //maj <= a_and_b ^ b_and_c ^ a_and_c;
        s1 <= s1_w;   // s1 <= e_rr_6 ^ e_rr_11 ^ e_rr_25;
        ch <= ch_w;   // ch <= e_and_f ^ ne_and_g;
        kw <= kw_w;   //kw <= w0 + k0;
        // Stage 1
        s0_maj <= s0_maj_w; // s0_maj <= s0 + maj;
        s1_ch <= s1_ch_w;   // s1_ch <= s1 + ch;
        hkw <= hkw_w;// hkw <= h1 + kw;
        // Stage 2
        t2 <= s0_maj;
        t1 <= t1_w;  // t1 <= s1_ch + hkw;
        // Stage 3 begin
        if (clr_i) begin
            a0 <= 32'h6a09e667;
            b0 <= 32'hbb67ae85;
            c0 <= 32'h3c6ef372;
            d0 <= 32'ha54ff53a;
            e0 <= 32'h510e527f;
            f0 <= 32'h9b05688c;
            g0 <= 32'h1f83d9ab;
            h0 <= 32'h5be0cd19;
        end else if (update_i) begin
            // Update abcdefgh for new chunk
            a0 <= H0_new;
            b0 <= H1_new;
            c0 <= H2_new;
            d0 <= H3_new;
            e0 <= H4_new;
            f0 <= H5_new;
            g0 <= H6_new;
            h0 <= H7_new;
        end else begin
            // abcdefgh for new main loop iter
            a0 <= new_a;
            e0 <= new_e;
            b0 <= a3;
            c0 <= b3;
            d0 <= c3;
            f0 <= e3;
            g0 <= f3;
            h0 <= g3;
        end
        // Stage 3 end
        // FIFOs for abcdefgh
        // a0 ~ h0 is given in stage 3 of main loop
        a1 <= a0;
        a2 <= a1;
        a3 <= a2;
        b1 <= b0;
        b2 <= b1;
        b3 <= b2;
        c1 <= c0;
        c2 <= c1;
        c3 <= c2;
        d1 <= d0;
        d2 <= d1;
        d3 <= d2;
        e1 <= e0;
        e2 <= e1;
        e3 <= e2;
        f1 <= f0;
        f2 <= f1;
        f3 <= f2;
        g1 <= g0;
        g2 <= g1;
        g3 <= g2;
        h1 <= h0;
        h2 <= h1;
        h3 <= h2;
    end
end

endmodule