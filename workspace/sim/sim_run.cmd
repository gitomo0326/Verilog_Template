@echo off
set MODULE=counter

iverilog ../src/*.v
vvp a.out
gtkwave %MODULE%.vcd