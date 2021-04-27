SetActiveLib -work
comp -include "$dsn\src\IrisDataManager.vhd" 
comp -include "$dsn\src\TestBench\irisdatamanager_TB.vhd" 
asim +access +r TESTBENCH_FOR_irisdatamanager 
wave 
wave -noreg CLK
wave -noreg SelectDataType
wave -noreg SelectDataIndex
wave -noreg SelectDataOut
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\irisdatamanager_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_irisdatamanager 
