module SIM_SAVE_DATA #(
    parameter IN_DAT_WH  = 'd8
)
(
    input P_CLK,
    input P_RST,
    input iVS,
    input iDE,
    input [`PARALLEL - 1: 0][IN_DAT_WH - 1: 0] iR,
    input [`PARALLEL - 1: 0][IN_DAT_WH - 1: 0] iG,
    input [`PARALLEL - 1: 0][IN_DAT_WH - 1: 0] iB
);

localparam int unsigned COLOR_NUM = 3;

integer file;

wire [0: `PARALLEL - 1][0: COLOR_NUM - 1][IN_DAT_WH - 1: 0] color;

initial begin
    file = $fopen(`OUTPUT_FILE_0, "w");
end

generate
    for(genvar i=0; i<`PARALLEL; i=i+1) begin
        assign color[i][0] = iR[i];
        assign color[i][1] = iG[i];
        assign color[i][2] = iB[i];
    end
endgenerate

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        ;
    end
    else if(iDE) begin
        case (`PARALLEL)
            1: begin
                $fdisplay(file, "%h_%h_%h", color[0][0], color[0][1], color[0][2]);
            end
            2: begin
                $fdisplay(file, "%h_%h_%h_%h_%h_%h", color[0][0], color[0][1], color[0][2], color[1][0], color[1][1], color[1][2]);
            end
            4: begin
                $fdisplay(file, "%h_%h_%h_%h_%h_%h_%h_%h_%h_%h_%h_%h", color[0][0], color[0][1], color[0][2], color[1][0], color[1][1], color[1][2], color[2][0], color[2][1], color[2][2], color[3][0], color[3][1], color[3][2]);
            end
            8: begin
                $fwrite(file, "%h_%h_%h_%h_%h_%h_%h_%h_%h_%h_%h_%h",   color[0][0], color[0][1], color[0][2], color[1][0], color[1][1], color[1][2], color[2][0], color[2][1], color[2][2], color[3][0], color[3][1], color[3][2]);
                $fwrite(file, "%h_%h_%h_%h_%h_%h_%h_%h_%h_%h_%h_%h\n", color[4][0], color[4][1], color[4][2], color[5][0], color[5][1], color[5][2], color[6][0], color[6][1], color[6][2], color[7][0], color[7][1], color[7][2]);
            end
            default: begin
                ;
            end
        endcase
    end
    else begin
        ;
    end
end

endmodule
