######################################################################
#
# File name : aluBench_simulate.do
# Created on: Fri Mar 08 18:29:14 -0600 2019
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
transcript off
opendesign H:/Documents/5200Projects/project_1/project_1.sim/sim_1/behav/activehdl/project_1/project_1.adf
set SIM_WORKING_FOLDER $dsn/..
asim -asdb +access +r +m+aluBench -L secureip -L xil_defaultlib -O5 xil_defaultlib.aluBench

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
