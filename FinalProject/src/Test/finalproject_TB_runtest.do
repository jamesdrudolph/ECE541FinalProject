SetActiveLib -work
comp -include "$dsn\src\FinalProject.vhd" 
comp -include "$dsn\src\Test\finalproject_TB.vhd" 
asim +access +r TESTBENCH_FOR_finalproject 
wave 
wave -noreg CLOCK_50
wave -noreg KEY
wave -noreg SW
wave -noreg LEDR
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\Test\finalproject_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_finalproject 
