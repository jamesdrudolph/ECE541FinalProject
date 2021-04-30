SetActiveLib -work
comp -include "$dsn\src\classifer.vhd" 
comp -include "$dsn\src\TestBench\classifier_TB.vhd" 
asim +access +r TESTBENCH_FOR_classifier 
wave 
wave -noreg CLK
wave -noreg rst
wave -noreg mins
wave -noreg class
wave -noreg done
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\classifier_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_classifier 
