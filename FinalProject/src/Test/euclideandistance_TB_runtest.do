SetActiveLib -work
comp -include "$dsn\src\EuclideanDistance.vhd" 
comp -include "$dsn\src\TestBench\euclideandistance_TB.vhd" 
asim +access +r TESTBENCH_FOR_euclideandistance 
wave 
wave -noreg CLK
wave -noreg TrainingData
wave -noreg TestData
wave -noreg Distance
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\euclideandistance_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_euclideandistance 
