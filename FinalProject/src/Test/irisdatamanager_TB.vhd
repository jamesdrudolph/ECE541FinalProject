library FinalProject;
library ieee;
use FinalProject.Common.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- Add your library and packages declaration here ...

entity irisdatamanager_tb is
end irisdatamanager_tb;

architecture TB_ARCHITECTURE of irisdatamanager_tb is
	-- Component declaration of the tested unit
	component irisdatamanager
	port(
		CLK : in STD_LOGIC;
		SelectDataType : in STD_LOGIC;
		SelectDataIndex : in UNSIGNED(6 downto 0);
		SelectDataOut : out DataAttributes );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC := '0';
	signal SelectDataType : STD_LOGIC := '0'; --select training data
	signal SelectDataIndex : UNSIGNED(6 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal SelectDataOut : DataAttributes;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : irisdatamanager
		port map (
			CLK => CLK,
			SelectDataType => SelectDataType,
			SelectDataIndex => SelectDataIndex,
			SelectDataOut => SelectDataOut
		);

	CLK <= not CLK after 10 ns;
	
	process
	begin
		SelectDataIndex <= "0000000";
		wait for 20 ns;
		SelectDataIndex <= "0000001";	
		wait for 20 ns;
		SelectDataIndex <= "0000010";	
		wait for 20 ns;
		SelectDataIndex <= "0000011";
		wait for 20 ns;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_irisdatamanager of irisdatamanager_tb is
	for TB_ARCHITECTURE
		for UUT : irisdatamanager
			use entity work.irisdatamanager(arch);
		end for;
	end for;
end TESTBENCH_FOR_irisdatamanager;

