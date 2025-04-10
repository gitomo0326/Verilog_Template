module VT_REG #(
    // Video Interface
    parameter IN_DAT_WH   = "",

    // Register Interface
    parameter REG_ADDR_WH = "",
    parameter REG_DAT_WH  = "",
    parameter REG_NUM     = "",

    // Gain Width
    parameter GAIN_WH     = ""
)
(
    // Register Interface
    input                       REG_CLK,
    input                       REG_RST,
    input                       iREG_VS,
    input   [REG_NUM     -1: 0] iREG_WE,
    input   [REG_NUM     -1: 0] iREG_RE,
    input   [REG_ADDR_WH -1: 0] iREG_ADDR,
    input   [REG_DAT_WH  -1: 0] iREG_WDATA,
    output  [REG_DAT_WH  -1: 0] oREG_RDATA,

    // Enable
    output                      oEN,

    // Capture
    input   [IN_DAT_WH   -1: 0] iCAPTURE_R,
    input   [IN_DAT_WH   -1: 0] iCAPTURE_G,
    input   [IN_DAT_WH   -1: 0] iCAPTURE_B,

    // Gain
    output  [GAIN_WH     -1: 0] oGAIN_R,
    output  [GAIN_WH     -1: 0] oGAIN_G,
    output  [GAIN_WH     -1: 0] oGAIN_B
);

    wire [REG_DAT_WH -1: 0] reg_rdata_temp[0: REG_NUM - 1];
    wire [REG_DAT_WH -1: 0] reg_rdata[0: REG_NUM - 1];
    wire [REG_DAT_WH -1: 0] data[0: REG_NUM - 1];

    for (genvar i = 0; i < REG_NUM; i = i + 1) begin:REG_GEN
        if (i==0) begin:reg_data_0
            assign reg_rdata[i] = {$bits(reg_rdata){iREG_RE[i]}} & reg_rdata_temp[i];
        end
        else begin:reg_data_x
            assign reg_rdata[i] = reg_rdata[i-1] | ({$bits(reg_rdata){iREG_RE[i]}} & reg_rdata_temp[i]);
        end
    end

    assign oREG_RDATA = reg_rdata[REG_NUM - 1];

    assign oEN     = data[0][0 +:$bits(oEN)];
    assign oGAIN_R = data[1][0 +:$bits(oGAIN_R)];
    assign oGAIN_G = data[2][0 +:$bits(oGAIN_G)];
    assign oGAIN_B = data[3][0 +:$bits(oGAIN_B)];

    D_FF_V #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_EN (
        .CLK        (REG_CLK            ),
        .RST        (REG_RST            ),
        .GATE       (iREG_WE[0]         ),
        .VS         (iREG_VS            ),
        .iDATA      (iREG_WDATA         ),
        .oREG_DATA  (reg_rdata_temp[0]  ),
        .oDATA      (data[0]            )
    );

    D_FF_V #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_GAIN_R (
        .CLK        (REG_CLK            ),
        .RST        (REG_RST            ),
        .GATE       (iREG_WE[1]         ),
        .VS         (iREG_VS            ),
        .iDATA      (iREG_WDATA         ),
        .oREG_DATA  (reg_rdata_temp[1]  ),
        .oDATA      (data[1]            )
    );

    D_FF_V #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_GAIN_G (
        .CLK        (REG_CLK            ),
        .RST        (REG_RST            ),
        .GATE       (iREG_WE[2]         ),
        .VS         (iREG_VS            ),
        .iDATA      (iREG_WDATA         ),
        .oREG_DATA  (reg_rdata_temp[2]  ),
        .oDATA      (data[2]            )
    );

    D_FF_V #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_GAIN_B (
        .CLK        (REG_CLK            ),
        .RST        (REG_RST            ),
        .GATE       (iREG_WE[3]         ),
        .VS         (iREG_VS            ),
        .iDATA      (iREG_WDATA         ),
        .oREG_DATA  (reg_rdata_temp[3]  ),
        .oDATA      (data[3]            )
    );

    wire [IN_DAT_WH -1: 0] capture_r;
    wire [IN_DAT_WH -1: 0] capture_g;
    wire [IN_DAT_WH -1: 0] capture_b;

    // Meta Stable
    CYCLE_DELAY #(
        .CYCLE_DELAY('d2),
        .DATA_WIDTH (IN_DAT_WH*3)
    ) m_CYCLE_DELAY_CAPTURE_CDC (
        .CLK   (REG_CLK),
        .RST   (REG_RST),
        .iDATA ({iCAPTURE_R, iCAPTURE_G, iCAPTURE_B}),
        .oDATA ({capture_r, capture_g, capture_b})
    );

    D_FF_R #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_CAPTURE_R (
        .CLK        (REG_CLK                    ),
        .RST        (REG_RST                    ),
        .GATE       (iREG_RE[4]                 ),
        .iDATA      (capture_r[REG_DAT_WH -1: 0]),
        .oREG_DATA  (reg_rdata_temp[4]          )
    );

    D_FF_R #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_CAPTURE_G (
        .CLK        (REG_CLK                    ),
        .RST        (REG_RST                    ),
        .GATE       (iREG_RE[5]                 ),
        .iDATA      (capture_g[REG_DAT_WH -1: 0]),
        .oREG_DATA  (reg_rdata_temp[5]          )
    );

    D_FF_R #(
        .REG_DAT_WH(REG_DAT_WH)
    ) m_REG_CAPTURE_B (
        .CLK        (REG_CLK                    ),
        .RST        (REG_RST                    ),
        .GATE       (iREG_RE[6]                 ),
        .iDATA      (capture_b[REG_DAT_WH -1: 0]),
        .oREG_DATA  (reg_rdata_temp[6]          )
    );

endmodule
