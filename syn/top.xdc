
# create_clock -period 8.000 -name in_clk125 -waveform {0.000 4.000} [get_ports in_clk125]

# set_property PACKAGE_PIN L16 [get_ports in_clk125]
# set_property IOSTANDARD LVCMOS33 [get_ports in_clk125]
# set_property PACKAGE_PIN R18 [get_ports in_reset]
# set_property IOSTANDARD LVCMOS33 [get_ports in_reset]

set_property PACKAGE_PIN F17 [get_ports hdmi_out_en]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_out_en]

set_property PACKAGE_PIN H16 [get_ports hdmi_clk_p]
set_property PACKAGE_PIN D19 [get_ports {hdmi_data_p[0]}]
set_property PACKAGE_PIN C20 [get_ports {hdmi_data_p[1]}]
set_property PACKAGE_PIN B19 [get_ports {hdmi_data_p[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN M14 [get_ports {led[0]}]
set_property PACKAGE_PIN D18 [get_ports {led[3]}]
set_property PACKAGE_PIN G14 [get_ports {led[2]}]
set_property PACKAGE_PIN M15 [get_ports {led[1]}]


set_max_delay -from [get_clocks clk_fpga_1] -to [get_clocks clk_fpga_2] -datapath_only  10.000
set_max_delay -from [get_clocks clk_fpga_2] -to [get_clocks clk_fpga_1] -datapath_only  10.000

