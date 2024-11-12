module counter_test;

reg CLK, RES;
wire [3:0] Q;

counter10 i0(CLK, RES, Q);

always #1 CLK = ~CLK;

initial begin
       RES = 0; #23;
       RES = 1; #1;
       RES = 0;
end

initial begin
       CLK = 0; #50000;
       $finish;
end

initial begin
       $dumpfile("sim.vcd");
       $dumpvars(0, counter_test);
end

always @(posedge CLK or posedge RES) begin
       if (RES) begin
              i0.hoge <= 0;
       end
       else begin
              i0.hoge <= 1;
       end
end

endmodule