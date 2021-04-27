library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity sqrt_tb is
end sqrt_tb;

architecture TB_ARCHITECTURE of sqrt_tb is
	-- Component declaration of the tested unit
	component sqrt
	port(
		clk : in STD_LOGIC;
		radical : in STD_LOGIC_VECTOR(15 downto 0);
		q : out STD_LOGIC_VECTOR(7 downto 0);
		remainder : out STD_LOGIC_VECTOR(8 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC := '0';
	signal radical : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal q : STD_LOGIC_VECTOR(7 downto 0);
	signal remainder : STD_LOGIC_VECTOR(8 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : sqrt
		port map (
			clk => clk,
			radical => radical,
			q => q,
			remainder => remainder
		);

	clk <= not clk after 10 ns;
	
	process
	begin
		radical <= x"0032"; --50
		wait for 20 ns;
		radical <= x"004B"; --75
		wait for 20 ns;
		radical <= x"07D0"; --2000
		wait for 20 ns;
		radical <= x"1388"; --5000
		wait for 20 ns;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_sqrt of sqrt_tb is
	for TB_ARCHITECTURE
		for UUT : sqrt
			use entity work.sqrt(syn);
		end for;
	end for;
end TESTBENCH_FOR_sqrt;

