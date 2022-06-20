`include "def.v"

module controller(
    input clk_i,
    input rst_ni,
    input [`GPIO_WIDTH-1:0] start_i,
    input [`GPIO_WIDTH-1:0] IB_idx_size_i,
    output [`GPIO_WIDTH-1:0] valid_o,    
    output [`ADDR_WIDTH-1:0] OB_addr_o,
    output [`ADDR_WIDTH-1:0] IB_r_addr_o,
    output OB_wr_o,
    output [1:0] IB_r_sel_o,
    output [1:0] IB_w_sel_o,
    output [`ADDR_WIDTH-1:0] WB_w_addr_o,
    output [`ADDR_WIDTH-1:0] WB_r_addr_o,
    output WB_wr_o,
    output WB_sel_o,
    output [`ADDR_WIDTH-1:0] KB_r_addr_o,
    output ex_sel_o,
    output [2:0] ML_sel_o,
    output update_o,
    output ML_clr_o 
);

    parameter PHASE0  = 2'd0,
              PHASE1  = 2'd1,
              PHASE2  = 2'd2,
              PHASE3  = 2'd3,
              IDLE    = 3'd0,
              START   = 3'd1,
              CLEAR   = 3'd2,
              ML      = 3'd3,
              UPDATE  = 3'd4,
              IB_BACK = 3'd5,
              VALID   = 3'd6;

    reg [`PHASE_BIT-1:0] phase;
    reg [2:0] c_state[`PHASE_NUM-1:0];
    reg [2:0] n_state[`PHASE_NUM-1:0];
    reg [3:0] valid; 
    
    reg [5:0] iter[`PHASE_NUM-1:0];       
    reg [`ADDR_WIDTH-1:0] IB_addr[`PHASE_NUM-1:0];
    reg [`ADDR_WIDTH-1:0] OB_addr[`PHASE_NUM-1:0];
    reg [`IB_NUM-1:0] OB_wr[`PHASE_NUM-1:0];
    reg IB_sel[`PHASE_NUM-1:0];
    reg [`ADDR_WIDTH-1:0] WB_w_addr[`PHASE_NUM-1:0];
    reg [`ADDR_WIDTH-1:0] WB_r_addr[`PHASE_NUM-1:0];
    reg WB_wr[`PHASE_NUM-1:0];
    reg WB_sel[`PHASE_NUM-1:0];
    reg [`ADDR_WIDTH-1:0] KB_r_addr[`PHASE_NUM-1:0];
    reg ex_sel[`PHASE_NUM-1:0];
    reg [2:0] ML_sel[`PHASE_NUM-1:0];
    reg update[`PHASE_NUM-1:0];
    reg ML_clr[`PHASE_NUM-1:0];
    reg [5:0] counter[`PHASE_NUM-1:0];
    
     
    assign valid_o     = {28'b0, valid};
    assign OB_addr_o   = OB_addr[PHASE0];
    assign IB_r_addr_o = IB_addr[PHASE1];
    assign OB_wr_o     = OB_wr[PHASE1];
    assign IB_r_sel_o  = IB_sel[PHASE1];
    assign IB_w_sel_o  = IB_sel[PHASE1];
    assign WB_r_addr_o = WB_r_addr[PHASE0];
    assign WB_w_addr_o = WB_w_addr[PHASE1];
    assign WB_wr_o     = WB_wr[PHASE1];
    assign WB_sel_o    = WB_sel[PHASE1];
    assign KB_r_addr_o = KB_r_addr[PHASE0];
    assign ex_sel_o    = ex_sel[PHASE1];
    assign ML_sel_o    = ML_sel[PHASE1];
    assign update_o    = update[PHASE1];
    assign ML_clr_o    = ML_clr[PHASE1]; 


    always @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 1'b0) begin
            phase      <= PHASE3;
            valid      <= 4'b0;

            c_state[0] <= IDLE; 
            c_state[1] <= IDLE; 
            c_state[2] <= IDLE; 
            c_state[3] <= IDLE; 

            iter[PHASE0] <= 6'b0;
            iter[PHASE1] <= 6'b0;
            iter[PHASE2] <= 6'b0;
            iter[PHASE3] <= 6'b0;

            ML_sel[PHASE0] <= 3'b0;
            ML_sel[PHASE1] <= 3'b0;
            ML_sel[PHASE2] <= 3'b0;
            ML_sel[PHASE3] <= 3'b0;

            OB_addr[PHASE0] <= `PHASE0_OB_ADDR;
            OB_addr[PHASE1] <= `PHASE1_OB_ADDR;
            OB_addr[PHASE2] <= `PHASE2_OB_ADDR;
            OB_addr[PHASE3] <= `PHASE3_OB_ADDR;


           // valid[PHASE0]     <= 4'b0;
            IB_addr[PHASE0]   <= 10'b0;
            OB_wr[PHASE0]     <= 1'b0;
            IB_sel[PHASE0]    <= 2'b0;
            WB_w_addr[PHASE0] <= `PHASE0_WB_ADDR;
            WB_r_addr[PHASE0] <= `PHASE0_WB_ADDR;
            WB_wr[PHASE0]     <= 1'b0;
            WB_sel[PHASE0]    <= 1'b0;
            KB_r_addr[PHASE0] <= 10'b0;
            ex_sel[PHASE0]    <= 1'b0;
            update[PHASE0]    <= 1'b0;
            ML_clr[PHASE0]    <= 1'b0;
            counter[PHASE0]   <= 6'b0;

            //valid[PHASE1]     <= 4'b0;
            IB_addr[PHASE1]   <= 10'b0;
            OB_wr[PHASE1]     <= 1'b0;
            IB_sel[PHASE1]    <= 2'b0;
            WB_w_addr[PHASE1] <= `PHASE1_WB_ADDR;
            WB_r_addr[PHASE1] <= `PHASE1_WB_ADDR;
            WB_wr[PHASE1]     <= 1'b0;
            WB_sel[PHASE1]    <= 1'b0;
            KB_r_addr[PHASE1] <= 10'b0;
            ex_sel[PHASE1]    <= 1'b0;
            update[PHASE1]    <= 1'b0;
            ML_clr[PHASE1]    <= 1'b0;
            counter[PHASE1]   <= 6'b0;

            //valid[PHASE2]     <= 4'b0;
            IB_addr[PHASE2]   <= 10'b0;
            OB_wr[PHASE2]     <= 1'b0;
            IB_sel[PHASE2]    <= 2'b0;
            WB_w_addr[PHASE2] <= `PHASE2_WB_ADDR;
            WB_r_addr[PHASE2] <= `PHASE2_WB_ADDR;
            WB_wr[PHASE2]     <= 1'b0;
            WB_sel[PHASE2]    <= 1'b0;
            KB_r_addr[PHASE2] <= 10'b0;
            ex_sel[PHASE2]    <= 1'b0;
            update[PHASE2]    <= 1'b0;
            ML_clr[PHASE2]    <= 1'b0;
            counter[PHASE2]   <= 6'b0;

            //valid[PHASE3]     <= 4'b0;
            IB_addr[PHASE3]   <= 10'b0;
            OB_wr[PHASE3]     <= 1'b0;
            IB_sel[PHASE3]    <= 2'b0;
            WB_w_addr[PHASE3] <= `PHASE3_WB_ADDR;
            WB_r_addr[PHASE3] <= `PHASE3_WB_ADDR;
            WB_wr[PHASE3]     <= 1'b0;
            WB_sel[PHASE3]    <= 1'b0;
            KB_r_addr[PHASE3] <= 10'b0;
            ex_sel[PHASE3]    <= 1'b0;
            update[PHASE3]    <= 1'b0;
            ML_clr[PHASE3]    <= 1'b0;
            counter[PHASE3]   <= 6'b0;
        end
        else begin

            phase <= phase + 2'b1;
            case (c_state[PHASE3])
                IDLE: begin
                    case (phase) 
                        PHASE0: begin
                            iter[PHASE0] <= IB_idx_size_i[`PHASE0_IB_SIZE];
                            valid <= {valid[3:1], 1'b0};
                            if (start_i[0] == 1'b1) c_state[PHASE0] <= START;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                        PHASE1: begin
                            iter[PHASE0] <= IB_idx_size_i[`PHASE1_IB_SIZE];
                            valid <= {valid[3:2], 1'b0, valid[0]};
                            if (start_i[1] == 1'b1) c_state[PHASE0] <= START;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                        PHASE2: begin
                            iter[PHASE0] <= IB_idx_size_i[`PHASE2_IB_SIZE];
                            valid <= {valid[3], 1'b0, valid[1:0]};
                            if (start_i[2] == 1'b1) c_state[PHASE0] <= START;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                        PHASE3: begin
                            iter[PHASE0] <= IB_idx_size_i[`PHASE3_IB_SIZE];
                            valid <= {1'b0, valid[2:0]};
                            if (start_i[3] == 1'b1) c_state[PHASE0] <= START;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                    endcase
                    //valid[PHASE0] <= 4'b0;
                    IB_addr[PHASE0] <= 10'b0;
                    OB_wr[PHASE0] <= 1'b0;
                    OB_addr[PHASE0] <= {OB_addr[PHASE3][9:3], 3'b0};
                    IB_sel[PHASE0] <= phase;
                    WB_w_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], 6'b0};
                    WB_r_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], 6'b0};                   
                    WB_wr[PHASE0] <= 1'b0;
                    WB_sel[PHASE0] <= 1'b0;
                    KB_r_addr[PHASE0] <= 10'b0;
                    ex_sel[PHASE0] <= 1'b0;
                    update[PHASE0] <= 1'b0;
                    ML_clr[PHASE0] <= 1'b0;
                    counter[PHASE0] <= 6'b0;
                end

                START: begin
                    c_state[PHASE0] <= ML;
                    iter[PHASE0] <= iter[PHASE3];
                    //valid[PHASE0] <= valid[PHASE3];
                    IB_addr[PHASE0] <= IB_addr[PHASE3];
                    OB_wr[PHASE0] <= OB_wr[PHASE3];
                    IB_sel[PHASE0] <= IB_sel[PHASE3];
                    WB_w_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], 6'b0};
                    WB_r_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], 6'b111111};
                    OB_addr[PHASE0] <= OB_addr[PHASE3];
                    WB_wr[PHASE0] <= 1'b1;
                    WB_sel[PHASE0] <= WB_sel[PHASE3];
                    KB_r_addr[PHASE0] <= {KB_r_addr[PHASE3][9:6], 6'b111111};
                    ex_sel[PHASE0] <= 1'b1;
                    update[PHASE0] <= 1'b0;
                    ML_clr[PHASE0] <= 1'b1;
                    counter[PHASE0] <= counter[PHASE3];
                end

                CLEAR: begin
                    c_state[PHASE0] <= ML;
                    iter[PHASE0] <= iter[PHASE3];
                    //valid[PHASE0] <= valid[PHASE3];
                    IB_addr[PHASE0] <= IB_addr[PHASE3] + 10'b1;
                    OB_wr[PHASE0] <= OB_wr[PHASE3];
                    OB_addr[PHASE0] <= OB_addr[PHASE3];
                    IB_sel[PHASE0] <= IB_sel[PHASE3];
                    WB_w_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], WB_w_addr[PHASE3][5:0] + 6'b1};
                    WB_r_addr[PHASE0] <= {WB_r_addr[PHASE3][9:6], WB_w_addr[PHASE3][5:0] + 6'b1};
                    WB_wr[PHASE0] <= 1'b1;
                    WB_sel[PHASE0] <= 1'b0;
                    KB_r_addr[PHASE0] <= {KB_r_addr[PHASE3][9:6], KB_r_addr[PHASE3][5:0] + 6'b1};
                    ex_sel[PHASE0] <= 1'b0;
                    update[PHASE0] <= 1'b0;
                    ML_clr[PHASE0] <= 1'b1;
                    counter[PHASE0] <= counter[PHASE3] + 6'b1;;
                end
                ML: begin
                    if (counter[PHASE3] < 6'd15 || counter[PHASE3] == 6'd63) begin
                        WB_sel[PHASE0] <= 1'b0;
                        ex_sel[PHASE0] <= 1'b0;
                        IB_addr[PHASE0] <= IB_addr[PHASE3] + 10'b1;
                    end
                    else begin
                        WB_sel[PHASE0] <= 1'b1;
                        ex_sel[PHASE0] <= 1'b1;
                        IB_addr[PHASE0] <= IB_addr[PHASE3];
                    end

                    if (counter[PHASE3] == 6'd63 && iter[PHASE3] == 6'b0) c_state[PHASE0] <= IB_BACK; 
                    else if (counter[PHASE3] == 6'd63) c_state[PHASE0] <= UPDATE; 
                    else c_state[PHASE0] <= ML; 
                    
                    iter[PHASE0] <= iter[PHASE3];
                    //valid[PHASE0] <= valid[PHASE3];
                    
                    OB_wr[PHASE0] <= OB_wr[PHASE3];
                    OB_addr[PHASE0] <= OB_addr[PHASE3];
                    IB_sel[PHASE0] <= IB_sel[PHASE3];
                    WB_w_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], WB_w_addr[PHASE3][5:0] + 6'b1};
                    WB_r_addr[PHASE0] <= {WB_r_addr[PHASE3][9:6], WB_w_addr[PHASE3][5:0] + 6'b1};                   
                    WB_wr[PHASE0] <= 1'b1;
                    KB_r_addr[PHASE0] <= {KB_r_addr[PHASE3][9:6], KB_r_addr[PHASE3][5:0] + 6'b1};
                    
                    update[PHASE0] <= 1'b0;
                    ML_clr[PHASE0] <= 1'b0;
                    counter[PHASE0] <= counter[PHASE3] + 6'b1;
                end

                UPDATE: begin
                    c_state[PHASE0] <= ML;
                    iter[PHASE0] <= iter[PHASE3] - 6'b1;
                    //valid[PHASE0] <= 1'b0;
                    IB_addr[PHASE0] <= IB_addr[PHASE3] + 10'b1;
                    OB_wr[PHASE0] <= OB_wr[PHASE3];
                    OB_addr[PHASE0] <= OB_addr[PHASE3];
                    IB_sel[PHASE0] <= IB_sel[PHASE3];
                    WB_w_addr[PHASE0] <= {WB_w_addr[PHASE3][9:6], WB_w_addr[PHASE3][5:0] + 6'b1};
                    WB_r_addr[PHASE0] <= {WB_r_addr[PHASE3][9:6], WB_w_addr[PHASE3][5:0] + 6'b1};
                    WB_wr[PHASE0] <= 1'b1;
                    WB_sel[PHASE0] <= 1'b0;
                    KB_r_addr[PHASE0] <= {KB_r_addr[PHASE3][9:6], KB_r_addr[PHASE3][5:0] + 6'b1};
                    ex_sel[PHASE0] <= 1'b0;
                    update[PHASE0] <= 1'b1;
                    ML_clr[PHASE0] <= 1'b0;
                    counter[PHASE0] <= counter[PHASE3] + 6'b1;
                end
                IB_BACK: begin
                    if (counter[PHASE3] == 6'd7) c_state[PHASE0] <= VALID; 
                    else c_state[PHASE0] <= ML; 
                    iter[PHASE0] <= iter[PHASE3];
                    //valid[PHASE0] <= valid[PHASE3];
                    IB_addr[PHASE0] <= IB_addr[PHASE3];
                    OB_wr[PHASE0] <= 1'b1;
                    OB_addr[PHASE0] <= {OB_addr[PHASE3][9:3], counter[PHASE3][2:0]};
                    IB_sel[PHASE0] <= IB_sel[PHASE3];
                    WB_w_addr[PHASE0] <= WB_w_addr[PHASE3];
                    WB_r_addr[PHASE0] <= WB_r_addr[PHASE3];
                    WB_wr[PHASE0] <= 1'b1;
                    WB_sel[PHASE0] <= WB_sel[PHASE3];
                    KB_r_addr[PHASE0] <= KB_r_addr[PHASE3];
                    ex_sel[PHASE0] <= 1'b0;
                    update[PHASE0] <= 1'b0;
                    ML_sel[PHASE0] <= counter[PHASE3][2:0];
                    ML_clr[PHASE0] <= 1'b0;
                    counter[PHASE0] <= counter[PHASE3] + 6'b1;
                end
                VALID: begin
                    c_state[PHASE0] <= ML;
                    case (phase) 
                        PHASE0: begin
                            valid <= {valid[3:1], 1'b1};
                            if (start_i[0] == 1'b0) c_state[PHASE0] <= IDLE;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                        PHASE1: begin
                            valid <= {valid[3:2], 1'b1, valid[0]};
                            if (start_i[1] == 1'b0) c_state[PHASE0] <= IDLE;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                        PHASE2: begin
                            valid <= {valid[3], 1'b1, valid[1:0]};
                            if (start_i[2] == 1'b0) c_state[PHASE0] <= IDLE;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                        PHASE3: begin
                            valid <= {1'b1, valid[2:0]};
                            if (start_i[3] == 1'b0) c_state[PHASE0] <= IDLE;
                            else c_state[PHASE0] <= c_state[PHASE3];
                        end
                    endcase
                    iter[PHASE0] <= iter[PHASE3];
                    IB_addr[PHASE0] <= IB_addr[PHASE3] + 10'b1;
                    OB_wr[PHASE0] <= OB_wr[PHASE3];
                    OB_addr[PHASE0] <= OB_addr[PHASE3];
                    IB_sel[PHASE0] <= IB_sel[PHASE3];
                    WB_w_addr[PHASE0] <= WB_w_addr[PHASE3];
                    WB_r_addr[PHASE0] <= WB_r_addr[PHASE3];
                    WB_wr[PHASE0] <= 1'b1;
                    WB_sel[PHASE0] <= WB_sel[PHASE3];
                    KB_r_addr[PHASE0] <= KB_r_addr[PHASE3];
                    ex_sel[PHASE0] <= ex_sel[PHASE0];
                    update[PHASE0] <= 1'b0;
                    ML_clr[PHASE0] <= 1'b0;
                    counter[PHASE0] <= counter[PHASE3] + 6'b1;
                end

            endcase

            c_state[PHASE1]   <= c_state[PHASE0]; 
            iter[PHASE1]      <= iter[PHASE0];
            //valid[PHASE1]     <= valid[PHASE0];
            IB_addr[PHASE1]   <= IB_addr[PHASE0];
            OB_wr[PHASE1]     <= OB_wr[PHASE0];
            OB_addr[PHASE1]   <= OB_addr[PHASE0];
            IB_sel[PHASE1]    <= IB_sel[PHASE0];
            WB_w_addr[PHASE1] <= WB_w_addr[PHASE0];
            WB_r_addr[PHASE1] <= WB_r_addr[PHASE0];
            WB_wr[PHASE1]     <= WB_wr[PHASE0];
            WB_sel[PHASE1]    <= WB_sel[PHASE0];
            KB_r_addr[PHASE1] <= KB_r_addr[PHASE0];
            ex_sel[PHASE1]    <= ex_sel[PHASE0];
            update[PHASE1]    <= update[PHASE0];
            ML_sel[PHASE1]    <= ML_sel[PHASE0];
            ML_clr[PHASE1]    <= ML_clr[PHASE0];
            counter[PHASE1]   <= counter[PHASE0];

            c_state[PHASE2]   <= c_state[PHASE1]; 
            iter[PHASE2]      <= iter[PHASE1];
            //valid[PHASE2]     <= valid[PHASE1];
            IB_addr[PHASE2]   <= IB_addr[PHASE1];
            OB_wr[PHASE2]     <= OB_wr[PHASE1];
            OB_addr[PHASE2]   <= OB_addr[PHASE1];
            IB_sel[PHASE2]    <= IB_sel[PHASE1];
            WB_w_addr[PHASE2] <= WB_w_addr[PHASE1];
            WB_r_addr[PHASE2] <= WB_r_addr[PHASE1];
            WB_wr[PHASE2]     <= WB_wr[PHASE1];
            WB_sel[PHASE2]    <= WB_sel[PHASE1];
            KB_r_addr[PHASE2] <= KB_r_addr[PHASE1];
            ex_sel[PHASE2]    <= ex_sel[PHASE1];
            update[PHASE2]    <= update[PHASE1];
            ML_sel[PHASE2]    <= ML_sel[PHASE1];
            ML_clr[PHASE2]    <= ML_clr[PHASE1];
            counter[PHASE2]   <= counter[PHASE1];

            c_state[PHASE3]   <= c_state[PHASE2]; 
            iter[PHASE3]      <= iter[PHASE2];
            //valid[PHASE3]     <= valid[PHASE2];
            IB_addr[PHASE3]   <= IB_addr[PHASE2];
            OB_wr[PHASE3]     <= OB_wr[PHASE2];
            OB_addr[PHASE3]   <= OB_addr[PHASE2];
            IB_sel[PHASE3]    <= IB_sel[PHASE2];
            WB_w_addr[PHASE3] <= WB_w_addr[PHASE2];
            WB_r_addr[PHASE3] <= WB_r_addr[PHASE2];
            WB_wr[PHASE3]     <= WB_wr[PHASE2];
            WB_sel[PHASE3]    <= WB_sel[PHASE2];
            KB_r_addr[PHASE3] <= KB_r_addr[PHASE2];
            ex_sel[PHASE3]    <= ex_sel[PHASE2];
            update[PHASE3]    <= update[PHASE2];
            ML_sel[PHASE3]    <= ML_sel[PHASE2];
            ML_clr[PHASE3]    <= ML_clr[PHASE2];
            counter[PHASE3]   <= counter[PHASE2];

        end
    end

endmodule