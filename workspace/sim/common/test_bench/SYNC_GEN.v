module SYNC_GEN
(
    input  P_CLK,
    input  P_RST,
    input  iSYNC_ON,
    output oVS,
    output oHS,
    output oDE
);

    // Sync
    reg vs;
    reg hs;
    reg hde;
    reg vde;

    // H Sync Generator
    always @(posedge P_CLK or posedge P_RST) begin
        if(P_RST) begin
            hs <= 1'b0;
        end
        else if(iSYNC_ON) begin
            hs <= 1'b1;
            repeat(`H_SYNC_WIDHT) @(posedge P_CLK);
            hs <= 1'b0;
            repeat(`H_TOTAL-`H_SYNC_WIDHT-1) @(posedge P_CLK);
        end
        else begin
            hs <= hs;
        end
    end

    // V Sync Generator
    always @(posedge hs or posedge P_RST) begin
        if(P_RST) begin
            vs <= 1'b0;
        end
        else if(iSYNC_ON) begin
            vs <= 1'b1;
            repeat(`V_SYNC_WIDHT) @(posedge hs);
            vs <= 1'b0;
            repeat(`V_TOTAL-`V_SYNC_WIDHT-1) @(posedge hs);
        end
        else begin
            vs <= vs;
        end
    end

    // Horizontal DE
    always @(posedge P_CLK or posedge P_RST) begin
        if(P_RST) begin
            hde <= 1'b0;
        end
        else if(iSYNC_ON) begin
            hde <= 1'b0;
            repeat(`H_SYNC_WIDHT+`H_BACK_PORCH) @(posedge P_CLK);
            hde <= 1'b1;
            repeat(`H_DISP) @(posedge P_CLK);
            hde <= 1'b0;
            repeat(`H_TOTAL-(`H_SYNC_WIDHT+`H_BACK_PORCH+`H_DISP)-1) @(posedge P_CLK);
        end
        else begin
            hde <= hde;
        end
    end

    // Vertical DE
    always @(posedge hs or posedge P_RST) begin
        if(P_RST) begin
            vde <= 1'b0;
        end
        else if(iSYNC_ON) begin
            vde <= 1'b0;
            repeat(`V_SYNC_WIDHT+`V_BACK_PORCH) @(posedge hs);
            vde <= 1'b1;
            repeat(`V_DISP) @(posedge hs);
            vde <= 1'b0;
            repeat(`V_TOTAL-(`V_SYNC_WIDHT+`V_BACK_PORCH+`V_DISP)-1) @(posedge hs);
        end
        else begin
            vde <= vde;
        end
    end


    assign oVS = vs;
    assign oHS = hs;
    assign oDE = hde & vde;

endmodule
