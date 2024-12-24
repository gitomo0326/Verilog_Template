@echo off

iverilog -g2005-sv ../src/*.v ./test_bench/*.v

vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd