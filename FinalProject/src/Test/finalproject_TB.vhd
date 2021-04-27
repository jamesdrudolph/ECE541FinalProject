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
		LEDR : out STD_LOGIC_VECTOR(9 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLOCK_50 : STD_LOGIC;
	signal KEY : STD_LOGIC_VECTOR(3 downto 0);
	signal SW : STD_LOGIC_VECTOR(9 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal LEDR : STD_LOGIC_VECTOR(9 downto 0);

	-- Add your code here ...

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

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_finalproject of finalproject_tb is
	for TB_ARCHITECTURE
		for UUT : finalproject
			use entity work.finalproject(arch);
		end for;
	end for;
end TESTBENCH_FOR_finalproject;

