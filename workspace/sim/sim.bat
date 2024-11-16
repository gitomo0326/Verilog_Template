@echo off

iverilog ../src/*.v ./test_bench/*.v

vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd