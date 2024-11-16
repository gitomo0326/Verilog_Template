module SIM_DUMP
(

);

initial begin
       $dumpfile("sim.vcd");
       $dumpvars(0, SIM_TOP);
end

endmodule