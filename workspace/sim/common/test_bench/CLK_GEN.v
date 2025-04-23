module CLK_GEN 
(
    output oP_CLK,
    output oSYS_CLK
);

reg p_clk;
reg sys_clk;

initial begin
    p_clk   = 0;

    forever #(((1/`P_CLK_CYCLE) / 2.0)*1000)   p_clk   = ~p_clk;
end

initial begin
    sys_clk = 0;

    forever #(((1/`SYS_CLK_CYCLE) / 2.0)*1000) sys_clk = ~sys_clk;
end

assign oP_CLK   = p_clk;
assign oSYS_CLK = sys_clk;
endmodule
