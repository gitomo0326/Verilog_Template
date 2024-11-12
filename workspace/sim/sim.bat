@echo off

iverilog ../src/*.v
vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd