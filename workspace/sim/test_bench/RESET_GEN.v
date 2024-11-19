module RESET_GEN 
(
    output oP_RST
);

reg p_rst;


initial begin
    p_rst = 0; #`RESET_TIMING;
    p_rst = 1; #1;
    p_rst = 0;
end

assign oP_RST = p_rst;

endmodule