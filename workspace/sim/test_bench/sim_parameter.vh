`timescale 1ns / 100ps

`define TIME_OUT      1000000  //ns
`define P_RESET_TIMING    23
`define SYS_RESET_TIMING  5
`define P_CLK_CYCLE   135.0 //MHz
`define SYS_CLK_CYCLE 48.0 //MHz
`define PARALLEL      4 // Pixel Per Clock

// H Sync Parameter
`define H_TOTAL      56 / `PARALLEL
`define H_BACK_PORCH 4  / `PARALLEL
`define H_SYNC_WIDHT 12 / `PARALLEL
`define H_DISP       36 / `PARALLEL

// V Sync Parameter
`define V_TOTAL      23
`define V_BACK_PORCH 5
`define V_SYNC_WIDHT 3
`define V_DISP       10

// Frame Counter
`define FRAME_NUM    8 // Max 8 Frames

// Input File
`define INPUT_FILE_0  "./in_data/sample_0.dat"
`define INPUT_FILE_1  "./in_data/sample_1.dat"
`define INPUT_FILE_2  "./in_data/sample_1.dat"
`define INPUT_FILE_3  "./in_data/sample_1.dat"
`define INPUT_FILE_4  "./in_data/sample_0.dat"
`define INPUT_FILE_5  "./in_data/sample_1.dat"
`define INPUT_FILE_6  "./in_data/sample_1.dat"
`define INPUT_FILE_7  "./in_data/sample_1.dat"

// Output File
`define OUTPUT_FILE_0 "./in_data/sample_out_0.dat"
`define OUTPUT_FILE_1 "./in_data/sample_out_1.dat"
`define OUTPUT_FILE_2 "./in_data/sample_out_2.dat"
`define OUTPUT_FILE_3 "./in_data/sample_out_3.dat"
`define OUTPUT_FILE_4 "./in_data/sample_out_4.dat"
`define OUTPUT_FILE_5 "./in_data/sample_out_5.dat"
`define OUTPUT_FILE_6 "./in_data/sample_out_6.dat"
`define OUTPUT_FILE_7 "./in_data/sample_out_7.dat"

// Register File
`define REG_FILE           "./test_bench/reg.txt"
`define REG_GOLDEN_FILE    "./test_bench/reg_golden.txt"
`define REG_NUM             8               // Setting Register Number
