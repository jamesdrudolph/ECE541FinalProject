SetActiveLib -work
comp -include "$dsn\MEGA\sqrt.vhd" 
comp -include "$dsn\src\Test\sqrt_TB.vhd" 
asim +access +r TESTBENCH_FOR_sqrt 
wave 
wave -noreg clk
wave -noreg radical
wave -noreg q
wave -noreg remainder
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\Test\sqrt_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_sqrt 
