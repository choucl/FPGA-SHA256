# 250MHz clk
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -period 4.000 -name sys_clk_pin -waveform {0.000 2.000} -add [get_ports clk_i]