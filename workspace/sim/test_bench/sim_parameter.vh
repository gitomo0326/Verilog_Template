`timescale 1ns / 100ps

`define TIME_OUT 1000000  //ns
`define RESET_TIMING 23
`define CLK_CYCLE 135.0 //MHz
`define PARALLEL 4 // Pixel Per Clock

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
`define FRAME_NUM    1

// Input File
`define INPUT_FILE_0  "./in_data/sample_0.dat"

// Output File
`define OUTPUT_FILE_0 "./in_data/sample_out_0.dat"
