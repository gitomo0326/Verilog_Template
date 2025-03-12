`include "./test_bench/TASK/sim_reg_acc_param.vh"

module SIM_CTRL #(
    parameter REG_ADDR_WH = 'd12,
    parameter REG_DAT_WH  = 'd8,
    parameter REG_NUM     = `REG_NUM,
    parameter FRAME_WH = $clog2(`FRAME_NUM + 1)
)
(
    // Video Interface
    input                       P_CLK,
    input                       P_RST,
    input                       iVS,
    input                       iHS,
    input                       iDE,
    output                      oSYNC_ON,
    output [FRAME_WH     -1: 0] oFRAME_NUM,

    // Register Interface
    input                       REG_CLK,
    input                       REG_RST,
    output [REG_NUM     -1: 0] oREG_WE,
    output [REG_NUM     -1: 0] oREG_RE,
    output [REG_ADDR_WH -1: 0] oREG_ADDR,
    output [REG_DAT_WH  -1: 0] oREG_WDATA,
    input  [REG_DAT_WH  -1: 0] iREG_RDATA
);

reg  sync_on;


integer i;
wire    reg_clk;
wire    reg_rst;

// ############################################################
// Timeout Processing of Simulation
// ############################################################
initial begin
    #`TIME_OUT;
    $finish;
end

// ############################################################
// Frame Count Control Processing
// ############################################################
initial begin
    sync_on <= 0;

    @(posedge P_RST);

    repeat(3) @(posedge P_CLK);

    sync_on <= 1;

    case (frame_num)
        0: begin
            ; // Not Close File
        end
        1: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file0);
        end
        2: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file1);
        end
        3: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file2);
        end
        4: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file3);
        end
        5: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file4);
        end
        6: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file5);
        end
        7: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file6);
        end
        8: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file7);
        end
        default: begin
            ;
        end
    endcase

    // Simulation Termination
    wait(frame_num == `FRAME_NUM) 

    $finish;

end

assign oSYNC_ON = sync_on;

reg [FRAME_WH -1: 0] frame_num;
wire vs_1d;
wire vs_1fp;

reg  is_frame_num_latch;

CYCLE_DELAY #(
    .CYCLE_DELAY('d1),
    .DATA_WIDTH ('d1)
) m_CYCLE_DELAY_VSYNC (
    .CLK   (P_CLK),
    .RST   (P_RST),
    .iDATA (iVS),
    .oDATA (vs_1d)
);

assign vs_1fp = iVS & ~vs_1d;

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        frame_num          <= '0;
        is_frame_num_latch <= 1'b0;
    end
    else if(vs_1fp & ~is_frame_num_latch) begin // Ignore first Vsync from frame count
        frame_num          <= frame_num;
        is_frame_num_latch <= 1'b1;
    end
    else if(vs_1fp) begin
        frame_num          <= frame_num + $bits(frame_num)'(1'b1);
        is_frame_num_latch <= is_frame_num_latch;
    end
    else begin
        frame_num          <= frame_num;
        is_frame_num_latch <= is_frame_num_latch;
    end
end

assign oFRAME_NUM = frame_num;



// ############################################################
// Register/SRAM Access
// ############################################################
`include "./TASK/sim_reg_acc.vh"

assign reg_clk    = REG_CLK;
assign reg_rst    = REG_RST;
assign oREG_WE    = reg_we     [0+: REG_NUM    ];
assign oREG_RE    = reg_re     [0+: REG_NUM    ];
assign oREG_ADDR  = reg_addr   [0+: REG_ADDR_WH];
assign oREG_WDATA = reg_wdata  [0+: REG_DAT_WH ];
assign reg_rdata  = iREG_RDATA [0+: REG_DAT_WH ];

initial begin
    reg_vs    <= '0;
    reg_we    <= '0;
    reg_re    <= '0;
    reg_addr  <= '0;
    reg_wdata <= '0;

    // Register Write Access
    $display("Register Write Start\n");
    write_reg_data_all(`REG_FILE);
    $display("Register Write End\n");

    // Register Read Access
    $display("Register Read Start\n");
    read_reg_data_all(`REG_GOLDEN_FILE);
    $display("Register Read End\n");

    @(posedge reg_clk);



    @(posedge vs_1fp);

    reg_update();
end


endmodule
