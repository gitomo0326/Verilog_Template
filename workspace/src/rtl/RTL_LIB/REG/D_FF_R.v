module D_FF_R #(
    parameter REG_DAT_WH = ""
)
(
    input                     CLK,
    input                     RST,
    input                     GATE,
    input  [REG_DAT_WH -1: 0] iDATA,
    output [REG_DAT_WH -1: 0] oREG_DATA
);

    reg [REG_DAT_WH -1: 0] ff_0;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            ff_0 <= '0;
        end
        else if (GATE) begin
            ff_0 <= iDATA;
        end
        else begin
            ff_0 <= ff_0;
        end
    end

    assign oREG_DATA = ff_0;

endmodule
