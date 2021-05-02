library FinalProject;
use FinalProject.Common.all;	 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Add your library and packages declaration here ...

entity classifier_tb is
end classifier_tb;

architecture TB_ARCHITECTURE of classifier_tb is
	-- Component declaration of the tested unit
	component classifier
		port(
			CLK : in STD_LOGIC;
			rst : in STD_LOGIC;
			mins : in distarr_array;
			class : out INTEGER range 0 to 2;
			done : out STD_LOGIC );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal mins : distarr_array;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal class : INTEGER range 0 to 2;
	signal done : STD_LOGIC;
	
	-- Add your code here ...
	signal dist1, dist2, dist3: distarr(1 to 5);   
	signal SimulationActive: boolean := true; 
	
begin
	
	-- Unit Under Test port map
	UUT : classifier
	port map (
		CLK => CLK,
		rst => rst,
		mins => mins,
		class => class,
		done => done
		);
	
	-- Add your stimulus here ... 
	
	process
	begin 
		while SimulationActive loop
			clk <= '0';
			wait for 10ns;
			clk <= '1';
			wait for 10ns;
		end loop;
		wait;
	end process;
	
	process
	begin
		rst <= '1';	 
		dist1 <= (to_unsigned(1, 8), to_unsigned(2, 8), to_unsigned(3, 8), to_unsigned(4, 8), to_unsigned(5, 8));
		dist2 <= (to_unsigned(6, 8), to_unsigned(7, 8), to_unsigned(8, 8), to_unsigned(2, 8), to_unsigned(10, 8));
		dist3 <= (to_unsigned(11, 8), to_unsigned(12, 8), to_unsigned(1, 8), to_unsigned(14, 8), to_unsigned(15, 8));
		wait for 5ns;
		mins(0) <= dist1;
		mins(1) <= dist2;
		mins(2) <= dist3;  
		wait for 25 ns;
		rst <= '0';
		wait until done = '1';	 
		wait for 25 ns;
		SimulationActive <= false;
		wait;
	end process;
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_classifier of classifier_tb is
	for TB_ARCHITECTURE
		for UUT : classifier
			use entity work.classifier(arch);
		end for;
	end for;
end TESTBENCH_FOR_classifier;

