`include "sim_parameter.vh"

module SIM_TOP #(
    parameter IN_DAT_WH  = 'd8,
    parameter OUT_DAT_WH = 'd8
)
(

);

wire p_clk;
wire p_rst;
wire vs;
wire hs;
wire de;
wire [3:0] q;

SIM_DUMP m_SIM_DUMP();

// Timeout Processing of Simulation
initial begin
    #`TIME_OUT;
    $finish;
end

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
    .P_CLK   (p_clk),
    .P_RST   (p_rst),
    .oVS     (vs   ),
    .oHS     (hs   ),
    .oDE     (de   )
);

// Load RGB Data
SIM_LOAD_DATA #(
    .IN_DAT_WH (IN_DAT_WH),
    .OUT_DAT_WH(OUT_DAT_WH)
) m_SIM_LOAD_DATA(
    .P_CLK   (p_clk  ),
    .P_RST   (p_rst  ),
    .iVS     (vs     ),
    .iHS     (hs     ),
    .iDE     (de     ),
    .oR      (),
    .oG      (),
    .oB      (),
    .oVS     (),
    .oHS     (),
    .oDE     ()
);

// Main Module Instantiation
counter10 i0(
    .P_CLK(p_clk),
    .P_RST(p_rst),
    .oQ(q)
);

endmodule
