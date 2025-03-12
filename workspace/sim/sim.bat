@echo off

iverilog -I ./test_bench -g2012 -s SIM_TOP -c ./test_bench_rtl_file_list.cmd -c ../src/rtl/rtl_lib_rtl_file_list.cmd -c ../src/rtl/verilog_template_rtl_file_list.cmd 
vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd
