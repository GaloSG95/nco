restart -f -nowave
config wave -signalnamewidth 1

add wave clk_reg
add wave rst_reg
add wave -radix sfixed -color red -format analog-step -height 75 -max 8191 -min -8191 dout_sin
add wave -radix sfixed -color blue -format analog-step -height 75 -max 8191 -min -8191 dout_cos

add wave -divider "internal"
add wave -radix unsigned -color coral -format analog-step -height 75 -max 255 -min 0 nco_lo_inst/phase_temp

run -all

view signals wave
wave zoom full
