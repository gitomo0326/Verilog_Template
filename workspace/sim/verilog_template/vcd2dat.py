import argparse
from vcdvcd import VCDVCD

class SIM_VCD:
    def __init__(self, vcd_file, module_name):
        self.vcd = VCDVCD(vcd_file, store_tvs=True)
        self.module_name = module_name
        self.set_parameter()
        self.set_video_stream_tv()

    def set_parameter(self):
        out_dat_wh   = self.vcd['SIM_TOP.OUT_DAT_WH'].tv
        parallel_num = self.vcd['SIM_TOP.PARALLEL_NUM'].tv

        self.out_dat_wh   = int(out_dat_wh[0][1], 2)
        self.parallel_num = int(parallel_num[0][1], 2)

    def set_video_stream_tv(self):
        self.data_r       = self.vcd[f'SIM_TOP.m_{self.module_name}.oR[{self.out_dat_wh*self.parallel_num-1}:0]'].tv
        self.data_g       = self.vcd[f'SIM_TOP.m_{self.module_name}.oG[{self.out_dat_wh*self.parallel_num-1}:0]'].tv
        self.data_b       = self.vcd[f'SIM_TOP.m_{self.module_name}.oB[{self.out_dat_wh*self.parallel_num-1}:0]'].tv
        self.de           = self.vcd[f'SIM_TOP.m_{self.module_name}.oDE'].tv
        self.p_clk        = self.vcd['SIM_TOP.p_clk'].tv

    def find_value(self, tv, timestamp):
        dict_tv = dict(tv)
        value = dict_tv.get(timestamp, "invalid")
        return value        

if __name__ == "__main__":
    # Command Line Argument Parsing
    parser = argparse.ArgumentParser()
    parser.add_argument("module_name")
    args = parser.parse_args()

    # File name and module name
    vcd_file = "sim.vcd"
    module_name = args.module_name

    # Initialize VCD object
    vcd = SIM_VCD(vcd_file, module_name)

    # Calculate P_CLK term and initial time
    p_clk_term = vcd.p_clk[2][0] - vcd.p_clk[0][0]
    p_clk_time = next((k for k, v in dict(vcd.p_clk).items() if v == "1"), None)

    data_enable = 0
    de_flag = 0
    r = "invalid"
    g = "invalid"
    b = "invalid"

    output_file = "rgb_output.txt"
    with open(output_file, "w") as f:

        count = 0
        while p_clk_time <= vcd.p_clk[-1][0]:

            data_enable = vcd.find_value(vcd.de, p_clk_time)

            de_flag = 1 if data_enable == '1' else (0 if data_enable == '0' else de_flag)

            if de_flag == 1:
                r_temp = vcd.find_value(vcd.data_r, p_clk_time)
                g_temp = vcd.find_value(vcd.data_g, p_clk_time)
                b_temp = vcd.find_value(vcd.data_b, p_clk_time)

                r = r_temp if r_temp != "invalid" else r
                g = g_temp if g_temp != "invalid" else g
                b = b_temp if b_temp != "invalid" else b

                line = f"time:{p_clk_time}, de:{de_flag}, r:{hex(int(r, 2))}, g:{hex(int(g, 2))}, b:{hex(int(b, 2))}\n"
                f.write(line)
                count += 1
                print(count)
            p_clk_time += p_clk_term
