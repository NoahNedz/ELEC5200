######################################################################
#
# File name : controlBench_compile.do
# Created on: Fri Mar 08 20:28:38 -0600 2019
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
transcript off
onbreak {quit}
onerror {quit}

createdesign {project_1} {H:/Documents/5200Projects/project_1/project_1.sim/sim_1/behav/activehdl}
opendesign {H:/Documents/5200Projects/project_1/project_1.sim/sim_1/behav/activehdl/project_1/project_1.adf}
vlib work

vlib activehdl/xil_defaultlib
vdel -lib xil_defaultlib -all

null [set origin_dir "H:/Documents/5200Projects/project_1/project_1.sim/sim_1/behav/activehdl"]
null [set vlog_opts {}]
null [set vcom_opts {}]


eval vcom -93 $vcom_opts -work xil_defaultlib  \
	"$origin_dir/../../../../project_1.srcs/sources_1/new/CONTROL.vhd" \
	"$origin_dir/../../../../project_1.srcs/sim_1/new/controlBench.vhd" \


quit
