module SIM_SAVE_DATA #(
    parameter IN_DAT_WH  = 'd8,
    parameter FRAME_WH   = $clog2(`FRAME_NUM + 1) + 1
)
(
    input P_CLK,
    input P_RST,
    input iVS,
    input iDE,
    input [0: `PARALLEL - 1][IN_DAT_WH - 1: 0] iR,
    input [0: `PARALLEL - 1][IN_DAT_WH - 1: 0] iG,
    input [0: `PARALLEL - 1][IN_DAT_WH - 1: 0] iB,
    input                   [FRAME_WH - 1 : 0] iFRAME_NUM
);

localparam int unsigned COLOR_NUM = 3;

integer file;
integer file0;
integer file1;
integer file2;
integer file3;
integer file4;
integer file5;
integer file6;
integer file7;

wire [0: `PARALLEL - 1][0: COLOR_NUM - 1][IN_DAT_WH - 1: 0] color;

initial begin
    file0 = $fopen(`OUTPUT_FILE_0, "w");
    file1 = $fopen(`OUTPUT_FILE_1, "w");
    file2 = $fopen(`OUTPUT_FILE_2, "w");
    file3 = $fopen(`OUTPUT_FILE_3, "w");
    file4 = $fopen(`OUTPUT_FILE_4, "w");
    file5 = $fopen(`OUTPUT_FILE_5, "w");
    file6 = $fopen(`OUTPUT_FILE_6, "w");
    file7 = $fopen(`OUTPUT_FILE_7, "w");
end

generate
    for(genvar i=0; i<`PARALLEL; i=i+1) begin
        assign color[i][0] = iR[i];
        assign color[i][1] = iG[i];
        assign color[i][2] = iB[i];
    end
endgenerate

always @(*) begin
    case (iFRAME_NUM)
        1: begin
            file = file0;
        end
        2: begin
            file = file1;
        end
        3: begin
            file = file2;
        end
        4: begin
            file = file3;
        end
        5: begin
            file = file4;
        end
        6: begin
            file = file5;
        end
        7: begin
            file = file6;
        end
        8: begin
            file = file7;
        end
        default: begin
            ;
        end
    endcase
end

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
            8: begin // Equal to $fdisplay
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
