module VERILOG_TEMPLATE
(
    input P_CLK,
    input P_RST,
    output [3:0] oQ 
);

reg [3: 0] q;

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST)
        q <= 4'd0;
    else if(q == 4'd9)
        q <= 4'd0;
    else
        q <= q + 4'd1;
end

assign oQ = q;

endmodule
