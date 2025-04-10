module D_FF_V #(
    parameter REG_DAT_WH = ""
)
(
    input                     CLK,
    input                     RST,
    input                     GATE,
    input                     VS,
    input  [REG_DAT_WH -1: 0] iDATA,
    output [REG_DAT_WH -1: 0] oREG_DATA,
    output [REG_DAT_WH -1: 0] oDATA
);

    reg [REG_DAT_WH -1: 0] ff_0;
    reg [REG_DAT_WH -1: 0] ff_1;

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
    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            ff_1 <= '0;
        end
        else if (VS) begin
            ff_1 <= ff_0; 
        end
        else begin
            ff_1 <= ff_1; 
        end
    end

    assign oDATA = ff_1;
endmodule
