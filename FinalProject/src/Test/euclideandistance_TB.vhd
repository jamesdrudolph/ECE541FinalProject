library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library FinalProject;
use FinalProject.Common.all;

	-- Add your library and packages declaration here ...

entity euclideandistance_tb is
end euclideandistance_tb;

architecture TB_ARCHITECTURE of euclideandistance_tb is
	-- Component declaration of the tested unit
	component euclideandistance
	port(
		CLK : in STD_LOGIC;
		TrainingData : in DataAttributes;
		TestData : in DataAttributes;
		Distance : out STD_LOGIC_VECTOR(7 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC := '0';
	signal TrainingData : DataAttributes:= (51, 35, 14, 2 , 0);
	signal TestData : DataAttributes 	:= (70, 32, 48, 14, 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Distance : STD_LOGIC_VECTOR(7 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : euclideandistance
		port map (
			CLK => CLK,
			TrainingData => TrainingData,
			TestData => TestData,
			Distance => Distance
		);

	CLK <= not CLK after 10 ns;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_euclideandistance of euclideandistance_tb is
	for TB_ARCHITECTURE
		for UUT : euclideandistance
			use entity work.euclideandistance(arch);
		end for;
	end for;
end TESTBENCH_FOR_euclideandistance;

