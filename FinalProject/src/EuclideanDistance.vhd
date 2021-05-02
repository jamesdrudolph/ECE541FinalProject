library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity EuclideanDistance is
	port (
		CLK			:	in	std_logic;
		TrainingData:	in	DataAttributes;
		TestData	:	in	DataAttributes;
		Distance	:	out	std_logic_vector(7 downto 0)
	);
end entity EuclideanDistance;

architecture arch of EuclideanDistance is
	component sqrt
		port(
			clk 		: in 	std_logic;
			radical 	: in 	std_logic_vector(15 downto 0);
			q 			: out	std_logic_vector(7 downto 0);
			remainder	: out 	std_logic_vector(8 downto 0)
		);
	end component;
	
	signal EuclidDistanceArray	: DataAttributes_u;
	signal EuclidDistance		: std_logic_vector(7 downto 0);
	signal EuclidRadical		: std_logic_vector(15 downto 0);
	signal SqrtRemainder 		: std_logic_vector(8 downto 0);
begin
	u0 : sqrt
	port map(
		clk 		=> CLK,
		radical 	=> EuclidRadical,
		q 			=> EuclidDistance,
		remainder	=> SqrtRemainder
	);
	
	FourDimensionEC : for i in 0 to 3 generate
		EuclidDistanceArray(i) <= (TrainingData(i) - TestData(i)) ** 2;
	end generate;
	
	Distance <= EuclidDistance;
	
	process(CLK)
		variable sum : unsigned(15 downto 0);
	begin
		sum := to_unsigned(0, 16);
		for i in 0 to 3 loop
			sum := sum + EuclidDistanceArray(i);	
		end loop;
		EuclidRadical <= std_logic_vector(sum);
	end process;
	
end architecture;