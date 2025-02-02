@echo off

iverilog -I ./test_bench -g2005-sv -s SIM_TOP ../src/10counter.v ./test_bench/SIM_TOP.v ./test_bench/SIM_DUMP.v ./test_bench/CLK_GEN.v ./test_bench/RESET_GEN.v ./test_bench/SYNC_GEN.v
vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd