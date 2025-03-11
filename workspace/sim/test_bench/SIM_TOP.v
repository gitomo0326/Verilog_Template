`include "sim_parameter.vh"

module SIM_TOP #(
    // Video Interface
    parameter IN_DAT_WH   = 'd8,
    parameter OUT_DAT_WH  = 'd8,

    // Register Interface
    parameter REG_ADDR_WH = 'd12,
    parameter REG_DAT_WH  = 'd8,
    parameter REG_NUM     = `REG_NUM,

    // Frame Counter
    parameter FRAME_WH    = $clog2(`FRAME_NUM + 1)
)
(

);

// CLK_GEN
wire p_clk;
wire sys_clk;
wire reg_clk;

// RESET_GEN
wire p_rst;
wire sys_rst;
wire reg_rst;

// SIM_SYNC_GEN
wire sim_sync_gen_vs;
wire sim_sync_gen_hs;
wire sim_sync_gen_de;

// SIM_LOAD_DATA
wire [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0] sim_load_data_r;
wire [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0] sim_load_data_g;
wire [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0] sim_load_data_b;
wire sim_load_data_vs;
wire sim_load_data_hs;
wire sim_load_data_de;

// SIM_CTRL
wire sim_ctrl_sync_on;
wire [FRAME_WH     -1: 0] sim_ctrl_frame_num;
wire [REG_NUM      -1: 0] sim_ctrl_reg_we;
wire [REG_NUM      -1: 0] sim_ctrl_reg_re;
wire [REG_ADDR_WH  -1: 0] sim_ctrl_reg_addr;
wire [REG_DAT_WH   -1: 0] sim_ctrl_reg_write_data;
wire [REG_DAT_WH   -1: 0] sim_ctrl_reg_read_data;



wire [3:0] q;

// Simulation Dump
SIM_DUMP m_SIM_DUMP();

SIM_CTRL #(
    .REG_ADDR_WH(REG_ADDR_WH),
    .REG_DAT_WH (REG_DAT_WH ),
    .REG_NUM    (REG_NUM    ),
    .FRAME_WH(FRAME_WH)
)
m_SIM_CTRL(
    // Video Interface
    .P_CLK(p_clk),
    .P_RST(p_rst),
    .iVS(sim_sync_gen_vs),
    .iHS('0),
    .iDE('0),
    .oSYNC_ON(sim_ctrl_sync_on),
    .oFRAME_NUM(sim_ctrl_frame_num),

    // Register Interface
    .REG_CLK       (reg_clk                ),
    .REG_RST       (reg_rst                ),
    .oREG_WE       (sim_ctrl_reg_we        ),
    .oREG_RE       (sim_ctrl_reg_re        ),
    .oREG_ADDR     (sim_ctrl_reg_addr      ),
    .oREG_WDATA    (sim_ctrl_reg_write_data),
    .iREG_RDATA    ((8)'('1))
);

// Clock Generator
CLK_GEN m_CLK_GEN(
    .oP_CLK  (p_clk  ),
    .oSYS_CLK(sys_clk)
);

assign reg_clk = sys_clk;

// Reset Generator
RESET_GEN m_RESET_GEN(
    .P_CLK   (p_clk  ),
    .SYS_CLK (sys_clk),
    .oP_RST  (p_rst  ),
    .oSYS_RST(sys_rst)
);

assign reg_rst = sys_rst;

// Sync Generator
SYNC_GEN m_SYNC_GEN(
    .P_CLK   (p_clk  ),
    .P_RST   (p_rst  ),
    .iSYNC_ON(sim_ctrl_sync_on),
    .oVS     (sim_sync_gen_vs     ),
    .oHS     (sim_sync_gen_hs     ),
    .oDE     (sim_sync_gen_de     )
);

// Load RGB Data
SIM_LOAD_DATA #(
    .IN_DAT_WH (IN_DAT_WH ),
    .OUT_DAT_WH(OUT_DAT_WH),
    .FRAME_WH  (FRAME_WH  )
) m_SIM_LOAD_DATA(
    .P_CLK     (p_clk             ),
    .P_RST     (p_rst             ),
    .iFRAME_NUM(sim_ctrl_frame_num),
    .iVS       (sim_sync_gen_vs   ),
    .iHS       (sim_sync_gen_hs   ),
    .iDE       (sim_sync_gen_de   ),
    .oR        (sim_load_data_r   ),
    .oG        (sim_load_data_g   ),
    .oB        (sim_load_data_b   ),
    .oVS       (sim_load_data_vs  ),
    .oHS       (sim_load_data_hs  ),
    .oDE       (sim_load_data_de  )
);

// Save RGB Data
SIM_SAVE_DATA #(
    .IN_DAT_WH (OUT_DAT_WH),
    .FRAME_WH  (FRAME_WH  )
) m_SIM_SAVE_DATA(
    .P_CLK     (p_clk             ),
    .P_RST     (p_rst             ),
    .iVS       (sim_load_data_vs  ),
    .iDE       (sim_load_data_de  ),
    .iR        (sim_load_data_r   ),
    .iG        (sim_load_data_g   ),
    .iB        (sim_load_data_b   ),
    .iFRAME_NUM(sim_ctrl_frame_num)
);

// Main Module Instantiation
counter10 i0(
    .P_CLK(p_clk),
    .P_RST(p_rst),
    .oQ(q)
);

endmodule
