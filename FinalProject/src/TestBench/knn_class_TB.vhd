library FinalProject;
use FinalProject.Common.all;   
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Add your library and packages declaration here ...

entity knn_class_tb is
end knn_class_tb;

architecture TB_ARCHITECTURE of knn_class_tb is
	-- Component declaration of the tested unit
	component knn_class
		port(
			CLK : in STD_LOGIC;
			TrainingData : in DataSlice;
			TestData : in DataAttributes;
			rst: in std_logic;
			min_dists : out distarr(1 to 5);
			done : out STD_LOGIC );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC;
	signal TrainingData : DataSlice;
	signal TestData : DataAttributes := (50,35,13,3,0);	
	signal rst: std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal min_dists : distarr(1 to 5);
	signal done : STD_LOGIC;
	
	-- Add your code here ...
	constant Data: DataSlice := (
		(51,35,14,2,0),
		(49,30,14,2,0),
		(47,32,13,2,0),
		(46,31,15,2,0),
		(50,36,14,2,0),
		(54,39,17,4,0),
		(46,34,14,3,0),
		(50,34,15,2,0),
		(44,29,14,2,0),
		(49,31,15,1,0),
		(54,37,15,2,0),
		(48,34,16,2,0),
		(48,30,14,1,0),
		(43,30,11,1,0),
		(58,40,12,2,0),
		(57,44,15,4,0),
		(54,39,13,4,0),
		(51,35,14,3,0),
		(57,38,17,3,0),
		(51,38,15,3,0),
		(54,34,17,2,0),
		(51,37,15,4,0),
		(46,36,10,2,0),
		(51,33,17,5,0),
		(48,34,19,2,0),
		(50,30,16,2,0),
		(50,34,16,4,0),
		(52,35,15,2,0),
		(52,34,14,2,0),
		(47,32,16,2,0),
		(48,31,16,2,0),
		(54,34,15,4,0),
		(52,41,15,1,0),
		(55,42,14,2,0),
		(49,31,15,2,0),
		(50,32,12,2,0),
		(55,35,13,2,0),
		(49,36,14,1,0),
		(44,30,13,2,0),
		(51,34,15,2,0)
	);			 
	
	signal SimulationActive: boolean := true;		
	type intarr5 is array(1 to 5) of integer;
	signal result: intarr5;		
	
	constant correct1: intarr5 := (1, 1, 1, 2, 2);
	constant correct2: intarr5 := (46, 47, 47, 47, 48);
begin
	
	-- Unit Under Test port map
	UUT : knn_class
	port map (
		CLK => CLK,
		TrainingData => TrainingData,
		TestData => TestData,
		rst => rst,
		min_dists => min_dists,
		done => done
		);
	
	-- Add your stimulus here ...	   	
	
	process(min_dists)
	begin
		for i in 1 to 5 loop
			result(i) <= to_integer(min_dists(i));
		end loop;
	end process;
	
		
	
	process
	begin	 
		while SimulationActive loop
			CLK <= '0';
			wait for 10ns;
			CLK <= '1';
			wait for 10ns; 
		end loop;  
		wait;
	end process;
	
	process
	begin	 
		rst <= '1';
		TrainingData <= data; 
		wait for 25 ns;
		rst <= '0';
		wait for 40 ns;
		wait until done = '1';
		wait for 20 ns;	
		rst <= '1';
		TestData <= (72, 30, 58, 16, 2);	
		wait for 20 ns;
		rst <= '0';
		wait for 40 ns;	 
		wait until done = '1';
		wait for 20 ns;
		SimulationActive <= false;
		wait;
	end process;
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_knn_class of knn_class_tb is
	for TB_ARCHITECTURE
		for UUT : knn_class
			use entity work.knn_class(arch);
		end for;
	end for;
end TESTBENCH_FOR_knn_class;

