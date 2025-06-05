`timescale 1ns / 100ps

`define TIME_OUT      1000000  //ns
`define P_RESET_TIMING    500
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
