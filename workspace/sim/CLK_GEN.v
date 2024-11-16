`include "sim_parameter.vh"

module CLK_GEN 
(
    output oP_CLK
);

reg p_clk;

//always begin
//     p_clk = ~p_clk;
//     #(((1/`CLK_CYCLE) / 2.0)*1000);
//end
//
//initial begin
//       p_clk = 0; #50000;
//       $finish;
//end

initial begin
    p_clk = 0;
    forever #(((1/`CLK_CYCLE) / 2.0)*1000) p_clk = ~p_clk;
end

assign oP_CLK = p_clk;

endmodule