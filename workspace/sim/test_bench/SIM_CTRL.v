module SIM_CTRL
(
    input P_CLK,
    input P_RST,
    input iVS,
    input iHS,
    input iDE,
    output oSYNC_ON
);

reg sync_on;

initial begin
        sync_on <= 0;

        @(posedge P_RST);

        repeat(3) @(posedge P_CLK);

        sync_on <= 1;

        // Simulation Termination
        wait(frame_num == `FRAME_NUM + 1) $finish;
end

assign oSYNC_ON = sync_on;

reg [5 : 0] frame_num;
reg  vs_1d;
wire vs_1fp;

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        vs_1d <= 1'b0;
    end
    else begin
        vs_1d <= iVS;
    end
end

assign vs_1fp = iVS & ~vs_1d;

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        frame_num <= 6'b0;
    end
    else if(vs_1fp) begin
        frame_num <= frame_num + $bits(frame_num)'(1'b1);
    end
    else begin
        frame_num <= frame_num;
    end
end


endmodule
