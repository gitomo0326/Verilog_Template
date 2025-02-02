module SIM_TOP;

wire p_clk, p_rst;
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


// Main Module Instantiation
counter10 i0(
    .P_CLK(p_clk),
    .P_RST(p_rst),
    .oQ(q)
);



endmodule