module VERILOG_TEMPLATE #(
    // Video Interface
    parameter IN_DAT_WH   = "",
    parameter OUT_DAT_WH  = "",
    parameter PARALLEL    = "",

    // Register Interface
    parameter REG_ADDR_WH = "",
    parameter REG_DAT_WH  = "",
    parameter REG_NUM     = ""
)
(
    // Video Interface
    input  P_CLK,
    input  P_RST,
    input  [0: PARALLEL -1][IN_DAT_WH  - 1: 0] iR,
    input  [0: PARALLEL -1][IN_DAT_WH  - 1: 0] iG,
    input  [0: PARALLEL -1][IN_DAT_WH  - 1: 0] iB,
    input  iVS,
    input  iHS,
    input  iDE,
    output [0: PARALLEL -1][OUT_DAT_WH - 1: 0] oR,
    output [0: PARALLEL -1][OUT_DAT_WH - 1: 0] oG,
    output [0: PARALLEL -1][OUT_DAT_WH - 1: 0] oB,
    output oVS,
    output oHS,
    output oDE,

    // Register Interface
    input                       REG_CLK,
    input                       REG_RST,
    input                       iREG_VS,
    input  [REG_NUM     - 1: 0] iREG_WE,
    input  [REG_NUM     - 1: 0] iREG_RE,
    input  [REG_ADDR_WH - 1: 0] iREG_ADDR,
    input  [REG_DAT_WH  - 1: 0] iREG_WDATA,
    output [REG_DAT_WH  - 1: 0] oREG_RDATA
);

    localparam int unsigned GAIN_WH = 'd8;

    wire                   vt_reg_en;
    wire  [GAIN_WH - 1: 0] vt_reg_gain_r;
    wire  [GAIN_WH - 1: 0] vt_reg_gain_g;
    wire  [GAIN_WH - 1: 0] vt_reg_gain_b;

    wire  [IN_DAT_WH - 1: 0] vt_capture_r;
    wire  [IN_DAT_WH - 1: 0] vt_capture_g;
    wire  [IN_DAT_WH - 1: 0] vt_capture_b;


    VT_CORE #(
        .IN_DAT_WH  (IN_DAT_WH  ),
        .OUT_DAT_WH (OUT_DAT_WH ),
        .PARALLEL   (PARALLEL   ),
        .GAIN_WH    (GAIN_WH    )
    ) m_VT_CORE(
        .P_CLK      (P_CLK        ),
        .P_RST      (P_RST        ),
        .iR         (iR           ),
        .iG         (iG           ),
        .iB         (iB           ),
        .iVS        (iVS          ),
        .iHS        (iHS          ),
        .iDE        (iDE          ),
        .oR         (oR           ),
        .oG         (oG           ),
        .oB         (oB           ),
        .oVS        (oVS          ),
        .oHS        (oHS          ),
        .oDE        (oDE          ),    
        .iEN        (vt_reg_en    ),
        .iGAIN_R    (vt_reg_gain_r),
        .iGAIN_G    (vt_reg_gain_g),
        .iGAIN_B    (vt_reg_gain_b),
        .oCAPTURE_R (vt_capture_r ),
        .oCAPTURE_G (vt_capture_g ),
        .oCAPTURE_B (vt_capture_b )
    );

    VT_REG #(
        .IN_DAT_WH   (IN_DAT_WH  ),
        .REG_ADDR_WH (REG_ADDR_WH),
        .REG_DAT_WH  (REG_DAT_WH ),
        .REG_NUM     (REG_NUM    ),
        .GAIN_WH     (GAIN_WH    )
    ) m_VT_REG(
        .REG_CLK       (REG_CLK       ),
        .REG_RST       (REG_RST       ),
        .iREG_VS       (iREG_VS       ),
        .iREG_WE       (iREG_WE       ),
        .iREG_RE       (iREG_RE       ),
        .iREG_ADDR     (iREG_ADDR     ),
        .iREG_WDATA    (iREG_WDATA    ),
        .oREG_RDATA    (oREG_RDATA    ),
        .oEN           (vt_reg_en     ),
        .iCAPTURE_R    (vt_capture_r  ),
        .iCAPTURE_G    (vt_capture_g  ),
        .iCAPTURE_B    (vt_capture_b  ),
        .oGAIN_R       (vt_reg_gain_r ),
        .oGAIN_G       (vt_reg_gain_g ),
        .oGAIN_B       (vt_reg_gain_b )
    );

endmodule
