module SIM_CTRL #(
    parameter FRAME_WH = $clog2(`FRAME_NUM + 1) + 1 // Last +1 is for `FRAME_NUM = 1
)
(
    input P_CLK,
    input P_RST,
    input iVS,
    input iHS,
    input iDE,
    output oSYNC_ON,
    output [FRAME_WH -1: 0] oFRAME_NUM
);

reg sync_on;

initial begin
    sync_on <= 0;

    @(posedge P_RST);

    repeat(3) @(posedge P_CLK);

    sync_on <= 1;

    case (frame_num)
        2: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file0);
        end
        3: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file1);
        end
        4: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file2);
        end
        5: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file3);
        end
        6: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file4);
        end
        7: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file5);
        end
        8: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file6);
        end
        9: begin
            $fclose(SIM_TOP.m_SIM_SAVE_DATA.file7);
        end
        default: begin
            ;
        end
    endcase

    // Simulation Termination
    wait(frame_num == `FRAME_NUM + 1) 

    $finish;

end

assign oSYNC_ON = sync_on;

reg [FRAME_WH -1: 0] frame_num;
reg  vs_1d;
wire vs_1fp;

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        vs_1d <= 1'b0;
    end
    else begin
        vs_1d <= iVS;
    end
end

assign vs_1fp = iVS & ~vs_1d;

always @(posedge P_CLK or posedge P_RST) begin
    if(P_RST) begin
        frame_num <= 6'b0;
    end
    else if(vs_1fp) begin
        frame_num <= frame_num + $bits(frame_num)'(1'b1);
    end
    else begin
        frame_num <= frame_num;
    end
end

assign oFRAME_NUM = frame_num;

endmodule
