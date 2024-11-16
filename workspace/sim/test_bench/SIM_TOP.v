module SIM_TOP;

wire p_clk, p_rst;
wire [3:0] Q;


SIM_DUMP m_SIM_DUMP();

// Timeout Processing of Simulation
initial begin
    #`TIME_OUT;
    $finish;
end


// Clock Generator
CLK_GEN m_CLK_GEN(p_clk);

// Reset Generator
RESET_GEN m_RESET_GEN(p_rst);


// Main Module Instantiation
counter10 i0(p_clk, p_rst, Q);



endmodule