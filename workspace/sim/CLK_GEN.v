`include "sim_parameter.vh"

module CLK_GEN (
    output oP_CLK
);

reg p_clk;

always begin
     p_clk = ~p_clk;
     #`CLK_CYCLE;
end

initial begin
       p_clk = 0; #50000;
       $finish;
end

assign oP_CLK = p_clk;

endmodule