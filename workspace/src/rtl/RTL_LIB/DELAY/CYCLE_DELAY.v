module CYCLE_DELAY #(
    parameter CYCLE_DELAY = "",
    parameter DATA_WIDTH  = ""
)
(
    input                      CLK,
    input                      RST,
    input  [DATA_WIDTH - 1: 0] iDATA,
    output [DATA_WIDTH - 1: 0] oDATA
);

    reg [DATA_WIDTH - 1: 0] data [0: CYCLE_DELAY -1];
    integer i;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            for (int i = 0; i < CYCLE_DELAY; i++) begin
                data[i] <= 'd0;
            end
        end else begin
            for (int i = 0; i < CYCLE_DELAY; i++) begin
                if (i == 0) begin
                    data[i] <= iDATA;
                end else begin
                    data[i] <= data[i - 1];
                end
            end
        end
    end

    assign oDATA = data[CYCLE_DELAY - 1];

endmodule
