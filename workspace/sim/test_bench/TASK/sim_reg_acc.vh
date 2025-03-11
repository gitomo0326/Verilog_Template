reg                                           reg_vs;
reg                   [`REG_OHE_WH    - 1: 0] reg_we;
reg                   [`REG_ADDR_WH   - 1: 0] reg_write_addr;
reg                   [`REG_DAT_WH    - 1: 0] reg_write_data;


// Register Update Task
task reg_update;         
    @(posedge reg_clk);

    reg_vs = 1'b1;
 
    @(posedge reg_clk);

    reg_vs = 1'b0;
endtask

// Register Write Task (All)
task write_reg_data_all;
    input string file_path;

    reg [`DAT_1LINE_WH - 1: 0] MEM [0 : `REG_NUM - 1];
    integer i;

    $readmemh(file_path, MEM);

    for(i=0; i<`REG_NUM; i=i+1) begin
        write_reg_data(MEM[i][`REG_DAT_WH+: `REG_ADDR_WH], MEM[i][0+: `REG_DAT_WH]);
    end

endtask

// Register Write Task (1 Line)
task write_reg_data;
    input [`REG_ADDR_WH   - 1: 0] iADR;
    input [`REG_DAT_WH    - 1: 0] iDATA;

    reg_we         = '0;
    reg_write_addr = '0;
    reg_write_data = '0;

    @(posedge reg_clk);

    reg_we         = $bits(reg_we)'(1 << iADR);
    reg_write_addr = iADR;
    reg_write_data = iDATA;

    $display("Write Addr : %h, Write Data : %h\n", iADR, iDATA);  

    @(posedge reg_clk);

    reg_we         = '0;
    reg_write_addr = '0;
    reg_write_data = '0;

endtask
