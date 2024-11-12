module SIM_TOP;

reg RES;
wire p_clk;
wire [3:0] Q;

CLK_GEN m_CLK_GEN(p_clk);

counter10 i0(p_clk, RES, Q);


initial begin
       RES = 0; #23;
       RES = 1; #1;
       RES = 0;
end



initial begin
       $dumpfile("sim.vcd");
       $dumpvars(0, SIM_TOP);
end

always @(posedge p_clk or posedge RES) begin
       if (RES) begin
              i0.hoge <= 0;
       end
       else begin
              i0.hoge <= 1;
       end
end

endmodule