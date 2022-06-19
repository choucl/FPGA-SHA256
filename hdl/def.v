`define GPIO_WIDTH 32

`define IB_IDX 31:30
`define PHASE0_IB_SIZE 5:0
`define PHASE1_IB_SIZE 11:6
`define PHASE2_IB_SIZE 17:12
`define PHASE3_IB_SIZE 23:18
`define IB_NUM 4
`define ADDR_WIDTH 10

`define PHASE0_WB_ADDR 10'd0
`define PHASE1_WB_ADDR 10'd64
`define PHASE2_WB_ADDR 10'd128
`define PHASE3_WB_ADDR 10'd192


`define ML_UPDATA_CYCLE 65
`define PHASE_NUM 4
`define PHASE_BIT 2  // lg(PHASE_NUM) 