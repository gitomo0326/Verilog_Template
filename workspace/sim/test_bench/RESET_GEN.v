module RESET_GEN 
(
    input  P_CLK,
    output oP_RST
);

reg p_rst;


initial begin
    p_rst = 0;
   
    repeat(`RESET_TIMING) @(posedge P_CLK);
    
    p_rst = 1;
    
    repeat(1) @(posedge P_CLK);
    
    p_rst = 0;
end

assign oP_RST = p_rst;

endmodule