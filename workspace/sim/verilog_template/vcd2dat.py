from vcdvcd import VCDVCD

def find_value(tv, timestamp):

    dict_tv = dict(tv)
    value = dict_tv.get(timestamp, "invalid")

    return value        
# File Read
vcd = VCDVCD("sim.vcd", store_tvs=True)

# Timestamp and value extraction
data_r = vcd['SIM_TOP.m_VERILOG_TEMPLATE.oR[31:0]'].tv
data_g = vcd['SIM_TOP.m_VERILOG_TEMPLATE.oG[31:0]'].tv
data_b = vcd['SIM_TOP.m_VERILOG_TEMPLATE.oB[31:0]'].tv
de     = vcd['SIM_TOP.m_VERILOG_TEMPLATE.oDE'].tv
p_clk  = vcd['SIM_TOP.p_clk'].tv

p_clk_term = p_clk[2][0] - p_clk[0][0]

p_clk_time = next((k for k, v in dict(p_clk).items() if v == "1"), None)

data_enable = 0
de_flag = 0
r = "invalid"
g = "invalid"
b = "invalid"


output_file = "rgb_output.txt"
with open(output_file, "w") as f:

    count = 0
    while p_clk_time <= p_clk[-1][0]:

        data_enable = find_value(de, p_clk_time)

        if  data_enable == '1':
            de_flag = 1
            r_temp = find_value(data_r, p_clk_time)
            g_temp = find_value(data_g, p_clk_time)
            b_temp = find_value(data_b, p_clk_time)

            if r_temp != "invalid":
                r = r_temp
            if g_temp != "invalid":
                g = g_temp
            if b_temp != "invalid":
                b = b_temp

        elif data_enable == "0":
            de_flag = 0
        elif data_enable == "invalid":
            if de_flag == 1:
                r_temp = find_value(data_r, p_clk_time)
                g_temp = find_value(data_g, p_clk_time)
                b_temp = find_value(data_b, p_clk_time)

                if r_temp != "invalid":
                    r = r_temp
                if g_temp != "invalid":
                    g = g_temp
                if b_temp != "invalid":
                    b = b_temp

        if de_flag == 1:
            line = f"time:{p_clk_time}, de:{de_flag}, r:{hex(int(r, 2))}, g:{hex(int(g, 2))}, b:{hex(int(b, 2))}\n"
            f.write(line)
            count += 1
            print(count)
        p_clk_time += p_clk_term
