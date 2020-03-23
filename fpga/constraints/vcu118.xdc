##general settings
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]

#clocks
set_property  -dict {PACKAGE_PIN E12 IOSTANDARD LVDS} [get_ports  SYSCLK1_300_P]
set_property  -dict {PACKAGE_PIN D12 IOSTANDARD LVDS} [get_ports  SYSCLK1_300_N]

#switches
set_property  -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS12} [get_ports  {sw[0]}]
set_property  -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS12} [get_ports  {sw[1]}]
set_property  -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS12} [get_ports  {sw[2]}]
set_property  -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS12} [get_ports  {sw[3]}]
set_false_path -from [get_ports -filter NAME=~sw*]

#cpu reset
set_property  -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS12} [get_ports  cpu_reset]
set_property PULLDOWN true [get_ports cpu_reset]

#LEDs
set_property  -dict {PACKAGE_PIN AT32 IOSTANDARD LVCMOS12} [get_ports {led[0]}]
set_property  -dict {PACKAGE_PIN AV34 IOSTANDARD LVCMOS12} [get_ports {led[1]}]
set_property  -dict {PACKAGE_PIN AY30 IOSTANDARD LVCMOS12} [get_ports {led[2]}]
set_property  -dict {PACKAGE_PIN BB32 IOSTANDARD LVCMOS12} [get_ports {led[3]}]
set_property  -dict {PACKAGE_PIN BF32 IOSTANDARD LVCMOS12} [get_ports {led[4]}]
set_property  -dict {PACKAGE_PIN AU37 IOSTANDARD LVCMOS12} [get_ports {led[5]}]
set_property  -dict {PACKAGE_PIN AV36 IOSTANDARD LVCMOS12} [get_ports {led[6]}]
set_property  -dict {PACKAGE_PIN BA37 IOSTANDARD LVCMOS12} [get_ports {led[7]}]
set_false_path -to [get_ports -filter NAME=~led*]

##DDR SDRAM
#Package Pin and IO Standard done by Vivado

#RAM Calibration
set_property C_CLK_INPUT_FREQ_HZ    300000000   [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER   false       [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN      1           [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_1]

#SD CARD
set_property PACKAGE_PIN AV15 [get_ports spi_clk_o]
set_property PACKAGE_PIN AY14 [get_ports spi_ss]
set_property PACKAGE_PIN AY15 [get_ports spi_mosi]
set_property PACKAGE_PIN AW15 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS18 [get_ports -filter NAME=~spi_*]

#Uart
set_property PACKAGE_PIN M30 [get_ports tx]
set_property PACKAGE_PIN N30 [get_ports rx]
set_property IOSTANDARD LVCMOS12 [get_ports { tx rx }]

#Create UART Interface
create_interface UART
set_property INTERFACE UART [get_ports { tx rx }]

#JTAG
set_property PACKAGE_PIN P29 [get_ports tck]
set_property PACKAGE_PIN L31 [get_ports tdi]
set_property PACKAGE_PIN M31 [get_ports tdo]
set_property PACKAGE_PIN R29 [get_ports tms]
set_property PACKAGE_PIN P30 [get_ports trst_n]
set_property IOSTANDARD LVCMOS12 [get_ports { tck tdi tdo tms trst_n }]

#Create JTAG Interface
create_interface JTAG
set_property INTERFACE JTAG [get_ports { tck tdi tdo tms trst_n }]

#accept sub-optimal placing
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_IBUF_inst/O]

#JTAG Clock
create_clock -period 100.000 -name tck -waveform {0.000 50.000} [get_ports tck]
set_input_jitter tck 1.000

#set JTAG reset as false path
set_false_path -from [get_ports trst_n]


#BPI FLASH
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN  div-1 [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE     Type1 [current_design]
set_property CONFIG_MODE                        BPI16 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS         TRUE  [current_design]
