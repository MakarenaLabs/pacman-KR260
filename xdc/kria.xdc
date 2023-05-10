# PMOD 1
set_property PACKAGE_PIN H12      [get_ports {I_SW_0[3]}];
set_property PACKAGE_PIN B10      [get_ports {I_SW_0[2]}];
set_property PACKAGE_PIN E10      [get_ports {I_SW_0[1]}];
set_property PACKAGE_PIN E12      [get_ports {I_SW_0[0]}];
set_property PACKAGE_PIN D10      [get_ports {I_BUTTON_0[3]}];
set_property PACKAGE_PIN D11      [get_ports {I_BUTTON_0[2]}];
set_property PACKAGE_PIN C11      [get_ports {I_BUTTON_0[1]}];
set_property PACKAGE_PIN B11      [get_ports {I_BUTTON_0[0]}];

# PMOD 2
set_property PACKAGE_PIN J11 [get_ports {CLOCK_PAC}];
set_property PACKAGE_PIN H11 [get_ports {O_AUDIO}];

# PMOD 3
set_property PACKAGE_PIN AC12 [get_ports {RED[0]}];
set_property PACKAGE_PIN AD11 [get_ports {BLUE[0]}];
set_property PACKAGE_PIN AD12 [get_ports {RED[1]}];
set_property PACKAGE_PIN AD10 [get_ports {BLUE[1]}];
set_property PACKAGE_PIN AE10 [get_ports {RED[2]}];
set_property PACKAGE_PIN AA11 [get_ports {BLUE[2]}];
set_property PACKAGE_PIN AF10 [get_ports {RED[3]}];
set_property PACKAGE_PIN AA10 [get_ports {BLUE[3]}];

# PMOD 4
set_property PACKAGE_PIN AE12 [get_ports {GREEN[0]}];
set_property PACKAGE_PIN AF11 [get_ports {HSYNC}];
set_property PACKAGE_PIN AF12 [get_ports {GREEN[1]}];
set_property PACKAGE_PIN AG11 [get_ports {VSYNC}];
set_property PACKAGE_PIN AG10 [get_ports {GREEN[2]}];
# AH12 NC
set_property PACKAGE_PIN AH10 [get_ports {GREEN[3]}];
# AH11 NC

set_property IOSTANDARD LVCMOS33 [get_ports I_BUTTON_0[*]]
set_property IOSTANDARD LVCMOS33 [get_ports I_SW_0[*]]
set_property IOSTANDARD LVCMOS33 [get_ports O_AUDIO]
set_property IOSTANDARD LVCMOS33 [get_ports VSYNC]
set_property PULLUP TRUE [get_ports VSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports HSYNC]
set_property PULLUP TRUE [get_ports HSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports CLOCK_PAC]
set_property IOSTANDARD LVCMOS33 [get_ports BLUE[*]]
set_property PULLUP TRUE [get_ports BLUE[*]]
set_property IOSTANDARD LVCMOS33 [get_ports GREEN[*]]
set_property PULLUP TRUE [get_ports GREEN[*]]
set_property IOSTANDARD LVCMOS33 [get_ports RED[*]]
set_property PULLUP TRUE [get_ports RED[*]]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

#Fan Speed Enable
set_property PACKAGE_PIN A12 [get_ports {fan_en_b}]
set_property IOSTANDARD LVCMOS33 [get_ports {fan_en_b}]
set_property SLEW SLOW [get_ports {fan_en_b}]
set_property DRIVE 4 [get_ports {fan_en_b}]


# 25Mhz clock
set_property PACKAGE_PIN C3 [get_ports {CLK_IN_gem}]
set_property IOSTANDARD LVCMOS18 [get_ports {CLK_IN_gem}]