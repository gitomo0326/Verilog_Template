`include "sim_parameter.vh"

module SIM_TOP #(
    parameter IN_DAT_WH  = 'd8,
    parameter OUT_DAT_WH = 'd8
)
(

);

wire p_clk;
wire p_rst;
wire sim_sync_gen_vs;
wire sim_sync_gen_hs;
wire sim_sync_gen_de;

wire [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0] sim_load_data_r;
wire [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0] sim_load_data_g;
wire [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0] sim_load_data_b;
wire sim_load_data_vs;
wire sim_load_data_hs;
wire sim_load_data_de;

wire sim_ctrl_sync_on;

wire [3:0] q;

// Simulation Dump
SIM_DUMP m_SIM_DUMP();

// Timeout Processing of Simulation
initial begin
    #`TIME_OUT;
    $finish;
end

SIM_CTRL m_SIM_CTRL(
    .P_CLK(p_clk),
    .P_RST(p_rst),
    .iVS(sim_sync_gen_vs),
    .iHS('0),
    .iDE('0),
    .oSYNC_ON(sim_ctrl_sync_on)
);

// Clock Generator
CLK_GEN m_CLK_GEN(
    .oP_CLK(p_clk)
);

// Reset Generator
RESET_GEN m_RESET_GEN(
    .P_CLK (p_clk),
    .oP_RST(p_rst)
);

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
    .IN_DAT_WH (IN_DAT_WH),
    .OUT_DAT_WH(OUT_DAT_WH)
) m_SIM_LOAD_DATA(
    .P_CLK   (p_clk  ),
    .P_RST   (p_rst  ),
    .iVS     (sim_sync_gen_vs),
    .iHS     (sim_sync_gen_hs),
    .iDE     (sim_sync_gen_de),
    .oR      (sim_load_data_r),
    .oG      (sim_load_data_g),
    .oB      (sim_load_data_b),
    .oVS     (sim_load_data_vs),
    .oHS     (sim_load_data_hs),
    .oDE     (sim_load_data_de)
);

// Save RGB Data
SIM_SAVE_DATA #(
    .IN_DAT_WH (OUT_DAT_WH)
) m_SIM_SAVE_DATA(
    .P_CLK   (p_clk  ),
    .P_RST   (p_rst  ),
    .iVS     (sim_load_data_vs),
    .iDE     (sim_load_data_de),
    .iR      (sim_load_data_r),
    .iG      (sim_load_data_g),
    .iB      (sim_load_data_b)
);

// Main Module Instantiation
counter10 i0(
    .P_CLK(p_clk),
    .P_RST(p_rst),
    .oQ(q)
);

endmodule
