library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity FinalProject is
	port (
		CLOCK_50	:	in	std_logic;
		KEY			:	in	std_logic_vector(3 downto 0);
		SW			:	in	std_logic_vector(9 downto 0);
		LEDR		:	out	std_logic_vector(9 downto 0)
		);
end entity FinalProject;

architecture arch of FinalProject is
	component embedded_soc is
		port (
			clk_clk       	: in  std_logic                    := 'X'; 				-- clk
			reset_reset_n 	: in  std_logic                    := 'X'; 				-- reset_n
			led_export    	: out std_logic_vector(9 downto 0);        				-- export
			switches_export	: in  std_logic_vector(9 downto 0) := (others => 'X')	-- export
			);
	end component embedded_soc;
	
	component IrisDataManager is
		port (
			CLK				:	in	std_logic;
			SelectDataType	:	in	std_logic;
			SelectDataIndex	:	in	unsigned(6 downto 0);
			SelectDataOut	:	out	DataAttributes
			);
	end component IrisDataManager; 
	
	component EuclideanDistance is
		port (
			CLK			:	in	std_logic;
			TrainingData:	in	DataAttributes;
			TestData	:	in	DataAttributes;
			Distance	:	out	std_logic_vector(7 downto 0)
			);
	end component EuclideanDistance;
	
	
	
	
	signal LEDR_export	:	std_logic_vector(9 downto 0);
	
	signal IrisDataType	:	std_logic;
	signal IrisDataOut	:	DataAttributes;
	signal IrisIndex	:	unsigned(6 downto 0);
	
	signal SqrtRadical	:	std_logic_vector(15 downto 0);
	signal SqrtResult	:	std_logic_vector(7 downto 0);
	signal SqrtRemainder:	std_logic_vector(8 downto 0);	 
	
	signal state, nstate: std_logic_vector(4 downto 0) := "00001"; --size may change	 
	signal count: integer range 0 to 120 := 0;
	signal training_data: DataArray;
begin
	u0 : component embedded_soc
	port map (
		clk_clk       		=> CLOCK_50,	-- clk.clk
		reset_reset_n 		=> KEY(0),		-- reset.reset_n
		led_export    		=> LEDR_export,	-- led.export
		switches_export 	=> SW			-- switches.export
		);
	
	u1 : component IrisDataManager
	port map (
		CLK					=> CLOCK_50,
		SelectDataType		=> IrisDataType,
		SelectDataIndex		=> IrisIndex,
		SelectDataOut		=> IrisDataOut
		);	   
	
	process(CLOCK_50)
	begin
		if rising_edge(CLOCK_50) then
			state <= nstate;
			if state(0) = '1' then 	
				IrisDataType <= '0';  --state 0 loads training data
				if count < 120 then 
					count <= count + 1; 
					IrisIndex <= to_unsigned(count, 7);
				else count <= 0;
				end if;	
				
				if count > 0 then
					training_data(count - 1) <= IrisDataOut; 
				end if;
				
				
			elsif state(1) = '1' and count < 40 then count <= count + 1;	--may need to change state for this line assume this state is for running through the testing data
			else count <= 0;	
			end if;	
		end if;
	end process;
	
	
	
	
end architecture arch;