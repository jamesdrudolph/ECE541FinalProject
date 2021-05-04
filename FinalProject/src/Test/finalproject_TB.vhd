library FinalProject;
library ieee;
use FinalProject.Common.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Add your library and packages declaration here ...

entity finalproject_tb is
end finalproject_tb;

architecture TB_ARCHITECTURE of finalproject_tb is
	-- Component declaration of the tested unit
	component finalproject
		port(
			CLOCK_50 : in STD_LOGIC;
			KEY : in STD_LOGIC_VECTOR(3 downto 0);
			SW : in STD_LOGIC_VECTOR(9 downto 0);
			LEDR : out STD_LOGIC_VECTOR(9 downto 0);
			HEX0 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
			HEX1 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
			HEX2 		:	OUT STD_LOGIC_VECTOR(0 to 6);
			HEX3 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
			HEX4 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
			HEX5 		: 	OUT STD_LOGIC_VECTOR(0 to 6)
			);
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLOCK_50 : STD_LOGIC;
	signal KEY : STD_LOGIC_VECTOR(3 downto 0);
	signal SW : STD_LOGIC_VECTOR(9 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal LEDR : STD_LOGIC_VECTOR(9 downto 0);	 
	signal HEX0 : STD_LOGIC_VECTOR(0 to 6);	 
	signal HEX1 : STD_LOGIC_VECTOR(0 to 6);	 
	signal HEX2 : STD_LOGIC_VECTOR(0 to 6);	 
	signal HEX3 : STD_LOGIC_VECTOR(0 to 6);	 
	signal HEX4 : STD_LOGIC_VECTOR(0 to 6);	 
	signal HEX5 : STD_LOGIC_VECTOR(0 to 6);
	
	-- Add your code here ... 
	signal SimulationActive: boolean := true;
	
begin
	
	-- Unit Under Test port map
	UUT : finalproject
	port map (
		CLOCK_50 => CLOCK_50,
		KEY => KEY,
		SW => SW,
		LEDR => LEDR
		);
	
	-- Add your stimulus here ...
	
	process
	begin  
		while simulationActive loop
			clock_50 <= '0';
			wait for 10 ns;
			clock_50 <= '1';
			wait for 10 ns;
		end loop;
		wait;
	end process;
	
	process
	begin
		KEY(0) <= '0';	
		KEY(1) <= '1';
		wait until rising_edge(clock_50);
		wait for 5 ns;
		Key(0) <= '1';
		wait for 101us;
		KEY(1) <= '0';
		wait until rising_edge(CLOCK_50);
		wait for 5 ns;
		KEY(1) <= '1';
		wait for 10us;
		simulationActive <= false;
		wait;
	end process;
	
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_finalproject of finalproject_tb is
	for TB_ARCHITECTURE
		for UUT : finalproject
			use entity work.finalproject(arch);
		end for;
	end for;
end TESTBENCH_FOR_finalproject;

