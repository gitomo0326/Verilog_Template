module VT_CORE_GAIN #(
    // Video Interface
    parameter IN_DAT_WH   = "",
    parameter OUT_DAT_WH  = "",

    // Gain Width
    parameter GAIN_WH     = ""
)
(
    // Video Interface
    input                      P_CLK,
    input                      P_RST,
    input  [IN_DAT_WH   -1: 0] iR,
    input  [IN_DAT_WH   -1: 0] iG,
    input  [IN_DAT_WH   -1: 0] iB,
    input                      iVS,
    input                      iHS,
    input                      iDE,
    output [OUT_DAT_WH  -1: 0] oR,
    output [OUT_DAT_WH  -1: 0] oG,
    output [OUT_DAT_WH  -1: 0] oB,
    output reg                 oVS,
    output reg                 oHS,
    output reg                 oDE,
    
    // Enable
    input                      iEN,

    // Gain
    input  [GAIN_WH     -1: 0] iGAIN_R,
    input  [GAIN_WH     -1: 0] iGAIN_G,
    input  [GAIN_WH     -1: 0] iGAIN_B
);

    reg [IN_DAT_WH+GAIN_WH  -1: 0] r_mul_gain;
    reg [IN_DAT_WH+GAIN_WH  -1: 0] g_mul_gain;
    reg [IN_DAT_WH+GAIN_WH  -1: 0] b_mul_gain;

    wire [GAIN_WH -1: 0] gain_r;
    wire [GAIN_WH -1: 0] gain_g;
    wire [GAIN_WH -1: 0] gain_b;

    assign gain_r = (iEN) ? iGAIN_R : $bits(gain_r)'(1'b1);
    assign gain_g = (iEN) ? iGAIN_G : $bits(gain_g)'(1'b1);
    assign gain_b = (iEN) ? iGAIN_B : $bits(gain_b)'(1'b1);

    always @(posedge P_CLK or posedge P_RST) begin
        if (P_RST) begin
            r_mul_gain <= $bits(r_mul_gain)'(1'b0);
            g_mul_gain <= $bits(g_mul_gain)'(1'b0);
            b_mul_gain <= $bits(b_mul_gain)'(1'b0);
        end
        else begin
            r_mul_gain <= iR * gain_r;
            g_mul_gain <= iG * gain_g;
            b_mul_gain <= iB * gain_b;
        end
    end

    assign oR = r_mul_gain[OUT_DAT_WH -1: 0];
    assign oG = g_mul_gain[OUT_DAT_WH -1: 0];
    assign oB = b_mul_gain[OUT_DAT_WH -1: 0];

    always @(posedge P_CLK or posedge P_RST) begin
        if (P_RST) begin
            oVS <= 1'b0;
            oHS <= 1'b0;
            oDE <= 1'b0;
        end
        else begin
            oVS <= iVS;
            oHS <= iHS;
            oDE <= iDE;
        end
    end

endmodule
