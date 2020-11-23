vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr \
"../../../../lab5_FPGA_1.srcs/sources_1/ip/KeyboardCtrl_1/src/Ps2Interface.v" \
"../../../../lab5_FPGA_1.srcs/sources_1/ip/KeyboardCtrl_1/src/KeyboardCtrl.v" \
"../../../../lab5_FPGA_1.srcs/sources_1/ip/KeyboardCtrl_1/sim/KeyboardCtrl_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

