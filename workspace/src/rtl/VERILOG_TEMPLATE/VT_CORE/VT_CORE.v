module VT_CORE #(
    // Video Interface
    parameter IN_DAT_WH   = "",
    parameter OUT_DAT_WH  = "",
    parameter PARALLEL    = "",

    // Gain 
    parameter GAIN_WH     = ""
)
(
    // Video Interface
    input                                      P_CLK,
    input                                      P_RST,
    input  [0: PARALLEL -1][IN_DAT_WH   -1: 0] iR,
    input  [0: PARALLEL -1][IN_DAT_WH   -1: 0] iG,
    input  [0: PARALLEL -1][IN_DAT_WH   -1: 0] iB,
    input                                      iVS,
    input                                      iHS,
    input                                      iDE,
    output [0: PARALLEL -1][OUT_DAT_WH  -1: 0] oR,
    output [0: PARALLEL -1][OUT_DAT_WH  -1: 0] oG,
    output [0: PARALLEL -1][OUT_DAT_WH  -1: 0] oB,
    output                                     oVS,
    output                                     oHS,
    output                                     oDE,

    // Enable
    input                                      iEN,
    // Gain
    input                  [GAIN_WH     -1: 0] iGAIN_R,
    input                  [GAIN_WH     -1: 0] iGAIN_G,
    input                  [GAIN_WH     -1: 0] iGAIN_B,

    // Capture
    output                 [OUT_DAT_WH  -1: 0] oCAPTURE_R,
    output                 [OUT_DAT_WH  -1: 0] oCAPTURE_G,
    output                 [OUT_DAT_WH  -1: 0] oCAPTURE_B
);

    wire [PARALLEL -1: 0] vs;
    wire [PARALLEL -1: 0] hs;
    wire [PARALLEL -1: 0] de;

    generate
        for(genvar i=0; i<PARALLEL; i=i+1) begin:VT_CORE_GAIN_GEN
            VT_CORE_GAIN #(
                .IN_DAT_WH   (IN_DAT_WH  ),
                .OUT_DAT_WH  (OUT_DAT_WH ),
                .GAIN_WH     (GAIN_WH    )
            ) m_VT_CORE_GAIN(
                .P_CLK      (P_CLK       ),
                .P_RST      (P_RST       ),
                .iR         (iR[i]       ),
                .iG         (iG[i]       ),
                .iB         (iB[i]       ),
                .iVS        (iVS         ),
                .iHS        (iHS         ),
                .iDE        (iDE         ),
                .oR         (oR[i]       ),
                .oG         (oG[i]       ),
                .oB         (oB[i]       ),
                .oVS        (vs[i]       ),
                .oHS        (hs[i]       ),
                .oDE        (de[i]       ),
                .iEN        (iEN         ),
                .iGAIN_R    (iGAIN_R     ),
                .iGAIN_G    (iGAIN_G     ),
                .iGAIN_B    (iGAIN_B     )
            );
       end
    endgenerate

    VT_CORE_CAPTURE #(
        .IN_DAT_WH   (IN_DAT_WH  ),
        .OUT_DAT_WH  (OUT_DAT_WH ),
        .PARALLEL    (PARALLEL   )
    ) m_VT_CORE_CAPTURE (
        .P_CLK      (P_CLK       ),
        .P_RST      (P_RST       ),
        .iR         (iR          ),
        .iG         (iG          ),
        .iB         (iB          ),
        .iVS        (iVS         ),
        .iHS        (iHS         ),
        .iDE        (iDE         ),
        .oR         (oCAPTURE_R  ),
        .oG         (oCAPTURE_G  ),
        .oB         (oCAPTURE_B  )
    );

    assign oVS = vs[0];
    assign oHS = hs[0];
    assign oDE = de[0];

endmodule
