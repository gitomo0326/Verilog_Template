module SIM_TOP;

wire p_clk, p_rst;
wire [3:0] Q;

CLK_GEN m_CLK_GEN(p_clk);
RESET_GEN m_RESET_GEN(p_rst);
counter10 i0(p_clk, p_rst, Q);

SIM_DUMP m_SIM_DUMP();

always @(posedge p_clk or posedge p_rst) begin
       if (p_rst) begin
              i0.hoge <= 0;
       end
       else begin
              i0.hoge <= 1;
       end
end

endmodule