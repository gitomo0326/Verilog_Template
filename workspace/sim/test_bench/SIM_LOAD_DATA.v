module SIM_LOAD_DATA #(
    parameter IN_DAT_WH  = 'd10,
    parameter OUT_DAT_WH = 'd10
)
(
    input                                              P_CLK,
    input                                              P_RST,
    input                                              iVS,
    input                                              iHS,
    input                                              iDE,
    output reg [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0]   oR,
    output reg [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0]   oG,
    output reg [0: `PARALLEL - 1][OUT_DAT_WH - 1: 0]   oB,
    output reg                                         oVS,
    output reg                                         oHS,
    output reg                                         oDE
);

localparam int unsigned COLOR_NUM = 3;
localparam int unsigned DE_COUNT_SHIFT = $clog2(`PARALLEL);

reg  [0: `PARALLEL - 1][0: COLOR_NUM - 1][IN_DAT_WH - 1: 0] color;
reg  [0:             `PARALLEL * COLOR_NUM * IN_DAT_WH - 1] memh [0 : `H_DISP * `V_DISP - 1];


reg  [$clog2(`H_DISP * `V_DISP + 1) - 1: 0] de_count;

// Load RGB Data
initial begin
    $readmemh(`INPUT_FILE_0, memh);
end

// DE Counter
always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        de_count <= '0;
    end
    else if(iVS) begin
        de_count <= '0;
    end
    else if(iDE) begin
        de_count <= de_count + 1'b1;
    end
    else begin
        de_count <= de_count;
    end
end

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        color <= '0;
    end
    else if(iDE) begin
        color <= memh[de_count >> DE_COUNT_SHIFT];
    end
    else begin
        color <= color;
    end
end

always @(*) begin
    case (`PARALLEL)
        1: begin
            oR = color[0][0];
            oG = color[0][1];
            oB = color[0][2];
        end
        2: begin
            oR = {color[0][0], color[1][0]};
            oG = {color[0][1], color[1][1]};
            oB = {color[0][2], color[1][2]};
        end
        4: begin
            oR = {color[0][0], color[1][0], color[2][0], color[3][0]};
            oG = {color[0][1], color[1][1], color[2][1], color[3][1]};
            oB = {color[0][2], color[1][2], color[2][2], color[3][2]};
        end
        8: begin
            oR = {color[0][0], color[1][0], color[2][0], color[3][0], color[4][0], color[5][0], color[6][0], color[7][0]};
            oG = {color[0][1], color[1][1], color[2][1], color[3][1], color[4][1], color[5][1], color[6][1], color[7][1]};
            oB = {color[0][2], color[1][2], color[2][2], color[3][2], color[4][2], color[5][2], color[6][2], color[7][2]};
        end
        default: begin
            oR = '0;
            oG = '0;
            oB = '0;
        end
    endcase
end

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        oHS <= '0;
        oVS <= '0;
        oDE <= '0;
    end
    else begin
        oHS <= iHS;
        oVS <= iVS;
        oDE <= iDE;
    end
end

endmodule
