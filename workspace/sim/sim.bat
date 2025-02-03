@echo off

iverilog -I ./test_bench -g2005-sv -s SIM_TOP -c ./test_bench_rtl_file_list.cmd -c ../src/rtl/10counter_rtl_file_list.cmd 
vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd