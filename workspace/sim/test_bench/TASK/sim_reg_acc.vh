reg                                           reg_vs;
reg                   [`REG_OHE_WH    - 1: 0] reg_we;
reg                   [`REG_OHE_WH    - 1: 0] reg_re;
reg                   [`REG_ADDR_WH   - 1: 0] reg_addr;
reg                   [`REG_DAT_WH    - 1: 0] reg_wdata;
reg                   [`REG_DAT_WH    - 1: 0] reg_rdata;

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

    reg_we    = '0;
    reg_addr  = '0;
    reg_wdata = '0;

    @(posedge reg_clk);

    reg_we    = $bits(reg_we)'(1 << iADR);
    reg_addr  = iADR;
    reg_wdata = iDATA;

    $display("Write Addr : %h, Write Data : %h\n", iADR, iDATA);  

    @(posedge reg_clk);

    reg_we    = '0;
    reg_addr  = '0;
    reg_wdata = '0;

endtask

// Register Read Task (All)
task read_reg_data_all;
    input string file_path;

    reg [`DAT_1LINE_WH - 1: 0] MEM [0 : `REG_NUM - 1];
    integer i;

    $readmemh(file_path, MEM);

    for(i=0; i<`REG_NUM; i=i+1) begin
        read_reg_data(MEM[i][`REG_DAT_WH+: `REG_ADDR_WH], MEM[i][0+: `REG_DAT_WH]);
    end

endtask

// Register Read Task (1 Line)
task read_reg_data;
    input [`REG_ADDR_WH   - 1: 0] iADR;
    input [`REG_DAT_WH    - 1: 0] iDATA;

    reg_re = '0;

    @(posedge reg_clk);

    reg_re = $bits(reg_re)'(1 << iADR);

    if(reg_rdata != iDATA) begin
        $display("Register Read Error!!\n");
        $display("Read Addr : %h, Read Data : %h, Expected Data : %h\n", iADR, reg_rdata, iDATA);
    end
    else begin
        $display("Read Addr : %h, Read Data : %h\n", iADR, iDATA);  
    end

    @(posedge reg_clk);

    reg_re = '0;

endtask
