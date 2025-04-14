module RESET_GEN 
(
    input  P_CLK,
    input  SYS_CLK,
    output oP_RST,
    output oSYS_RST
);

reg p_rst;
reg sys_rst;

// P_RST
initial begin
    p_rst = 0;
   
    repeat(`P_RESET_TIMING) @(posedge P_CLK);
    
    p_rst = 1;
    
    repeat(1) @(posedge P_CLK);
    
    p_rst = 0;
end

assign oP_RST = p_rst;


// SYS_RST
initial begin
    sys_rst = 0;
   
    repeat(`SYS_RESET_TIMING) @(posedge SYS_CLK);
    
    sys_rst = 1;
    
    repeat(1) @(posedge SYS_CLK);
    
    sys_rst = 0;
end

assign oSYS_RST = sys_rst;

endmodule
