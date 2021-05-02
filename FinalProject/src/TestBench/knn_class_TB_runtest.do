SetActiveLib -work
comp -include "$dsn\src\knn_class.vhd" 
comp -include "$dsn\src\TestBench\knn_class_TB.vhd" 
asim +access +r TESTBENCH_FOR_knn_class 
wave 
wave -noreg CLK
wave -noreg TrainingData
wave -noreg TestData
wave -noreg min_dists
wave -noreg done
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\knn_class_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_knn_class 
