######################################################################
#
# File name : addBench_simulate.do
# Created on: Fri Mar 08 23:22:41 -0600 2019
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
transcript off
opendesign H:/Documents/5200Projects/project_1/project_1.sim/sim_1/behav/activehdl/project_1/project_1.adf
set SIM_WORKING_FOLDER $dsn/..
asim -asdb +access +r +m+addBench -L secureip -L xil_defaultlib -O5 xil_defaultlib.addBench

if { ![batch_mode] } {
	wave *
} else {
	log *
}


run 1000ns
if [batch_mode] {
	endsim
	quit
}
