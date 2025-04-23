@echo off

set TEST_BENCH_TEMP="./test_bench_temp"
set LOCAL_TEST_BENCH="./test_bench"
set COMMON_TEST_BENCH="../common/test_bench"

if exist %TEST_BENCH_TEMP% (
    rmdir /s /q %TEST_BENCH_TEMP%
)

mkdir %TEST_BENCH_TEMP%

xcopy /e %COMMON_TEST_BENCH% %TEST_BENCH_TEMP%
xcopy /e %LOCAL_TEST_BENCH%  %TEST_BENCH_TEMP%

iverilog -I %TEST_BENCH_TEMP% ^
    -g2012 ^
    -s SIM_TOP ^
    -c %TEST_BENCH_TEMP%/test_bench_rtl_file_list.cmd ^
    -c %TEST_BENCH_TEMP%/common_test_bench_rtl_file_list.cmd ^
    -c ../../src/rtl/rtl_lib_rtl_file_list.cmd ^
    -c ../../src/rtl/verilog_template_rtl_file_list.cmd
vvp a.out
gtkwave sim.vcd
del a.out
del sim.vcd
