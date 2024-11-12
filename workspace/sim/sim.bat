@echo off

iverilog ../src/*.v ./*.v

vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd