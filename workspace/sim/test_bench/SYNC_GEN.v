module SYNC_GEN
(
    input  P_CLK,
    input  P_RST,
    output oVS,
    output oHS,
    output oDE
);

    // Sync
    reg vs;
    reg hs;
    reg hde;
    reg vde;

    // Sync Start Flag
    reg sync_on;

    initial begin
        vs <= 0;
        hs <= 0;
        sync_on <= 0;

        @(posedge P_RST);

        repeat(3) @(posedge P_CLK);

        sync_on <= 1;
    end

    // H Sync Generator
    always @(posedge P_CLK or posedge P_RST) begin
        if(P_RST) begin
            hs <= 1'b0;
        end
        else if(sync_on) begin
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
        else if(sync_on) begin
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
        else if(sync_on) begin
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
        else if(sync_on) begin
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