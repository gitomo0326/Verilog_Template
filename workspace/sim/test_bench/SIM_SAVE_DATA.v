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

integer i;
integer file;

initial begin
    file = $fopen(`OUTPUT_FILE1, "w");
end


always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        ;
    end
    else if(iDE) begin
        $fdisplay(file, "%h %h %h", iR, iG, iB);
    end
    else begin
        ;
    end
end

endmodule
