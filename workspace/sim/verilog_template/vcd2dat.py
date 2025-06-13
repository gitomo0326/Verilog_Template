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
        frame_wh     = self.vcd['SIM_TOP.FRAME_WH'].tv

        self.out_dat_wh   = int(out_dat_wh[0][1], 2)
        self.parallel_num = int(parallel_num[0][1], 2)
        self.frame_wh     = int(frame_wh[0][1], 2)

    def set_video_stream_tv(self):
        self.data_r       = self.vcd[f'SIM_TOP.m_{self.module_name}.oR[{self.out_dat_wh*self.parallel_num-1}:0]'].tv
        self.data_g       = self.vcd[f'SIM_TOP.m_{self.module_name}.oG[{self.out_dat_wh*self.parallel_num-1}:0]'].tv
        self.data_b       = self.vcd[f'SIM_TOP.m_{self.module_name}.oB[{self.out_dat_wh*self.parallel_num-1}:0]'].tv
        self.de           = self.vcd[f'SIM_TOP.m_{self.module_name}.oDE'].tv
        self.frame_num    = self.vcd[f'SIM_TOP.sim_ctrl_frame_num[{self.frame_wh-1}:0]'].tv
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

    # Initialize variables
    data_enable = 0
    de_flag = 0
    r = "invalid"
    g = "invalid"
    b = "invalid"
    frame_num = "invalid"
    count = 0

    while p_clk_time <= vcd.p_clk[-1][0]:

        frame_num = vcd.find_value(vcd.frame_num, p_clk_time)

        if frame_num != "invalid":
            frame_num = int(frame_num, 2)

            # Close the previous frame file
            if frame_num > 0:
                out_frame_file.close()

            out_frame_file = open(f"out_frame_{frame_num}.txt", "w")

        # Data Enable Control
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
            out_frame_file.write(line)
        p_clk_time += p_clk_term

    out_frame_file.close()
