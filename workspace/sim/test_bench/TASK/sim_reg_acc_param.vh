`define REG_OHE_WH     2**`REG_ADDR_WH                       // Register One Hot Enable Width
`define REG_BANK_WH    4                                     // Bank Width
`define REG_1BANK_NUM  256                                   // Register Number in 1 Bank
`define DAT_1LINE_WH   32                                    // Data Bit Width of 1 Line
`define REG_ADDR_WH    `REG_BANK_WH + $clog2(`REG_1BANK_NUM) // Register Address Width
`define REG_DAT_WH     8                                     // Data Width of 1 Register
