module VT_CORE_CAPTURE #(
    // Video Interface
    parameter IN_DAT_WH   = "",
    parameter OUT_DAT_WH  = "",
    parameter PARALLEL    = ""
)
(
    input                                      P_CLK,
    input                                      P_RST,
    input  [0: PARALLEL -1][IN_DAT_WH   -1: 0] iR,
    input  [0: PARALLEL -1][IN_DAT_WH   -1: 0] iG,
    input  [0: PARALLEL -1][IN_DAT_WH   -1: 0] iB,
    input                                      iVS,
    input                                      iHS,
    input                                      iDE,
    output reg             [OUT_DAT_WH  -1: 0] oR,
    output reg             [OUT_DAT_WH  -1: 0] oG,
    output reg             [OUT_DAT_WH  -1: 0] oB
);

    reg is_data_latched;

    always @(posedge P_CLK or posedge P_RST) begin
        if (P_RST) begin
            oR <= $bits(oR)'(1'b0);
            oG <= $bits(oG)'(1'b0);
            oB <= $bits(oB)'(1'b0);
            is_data_latched <= 1'b0;
        end
        else if (iDE && ~is_data_latched) begin
            oR <= iR[0];
            oG <= iG[0];
            oB <= iB[0];
            is_data_latched <= 1'b1;
        end
        else if (iVS) begin
            oR <= $bits(oR)'(1'b0);
            oG <= $bits(oG)'(1'b0);
            oB <= $bits(oB)'(1'b0);
            is_data_latched <= 1'b0;
        end
        else begin
            oR <= oR;
            oG <= oG;
            oB <= oB;
            is_data_latched <= is_data_latched;
        end
    end

endmodule
