module CLK_GEN (
    output oP_CLK
);

reg p_clk;
always #1 p_clk = ~p_clk;

initial begin
       p_clk = 0; #50000;
       $finish;
end

assign oP_CLK = p_clk;

endmodule