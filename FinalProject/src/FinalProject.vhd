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
			clk_clk                   : in  std_logic                     := 'X';             -- clk
			led_export                : out std_logic_vector(9 downto 0);                     -- export
			reset_reset_n             : in  std_logic                     := 'X';             -- reset_n
			switches_export           : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			buttons_export            : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			nios_input_export_export  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			nios_output_export_export : out std_logic_vector(31 downto 0)                     -- export
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
	signal NIOS_input	:	std_logic_vector(31 downto 0);
	signal NIOS_output	:	std_logic_vector(31 downto 0);
	
	signal IrisDataType	:	std_logic;
	signal IrisDataOut	:	DataAttributes;
	signal IrisIndex	:	unsigned(6 downto 0);
	
	signal SqrtRadical	:	std_logic_vector(15 downto 0);
	signal SqrtResult	:	std_logic_vector(7 downto 0);
	signal SqrtRemainder:	std_logic_vector(8 downto 0);	 
	
	signal state, nstate: std_logic_vector(1 downto 0) := "01"; --size may change	 
	signal count: integer range 0 to 120 := 0;
	signal training_data: DataArray;	 
	signal wait_count: unsigned(3 downto 0) := (others => '1'); --may need to adjust depending on how long classification takes	 
	signal wait_zero: unsigned(wait_count'range) := (others => '0');
	signal test_data: DataAttributes;		 
	signal classifications: TestClass;	
	signal knn_out: integer range 0 to 2;
	
	
begin
	u0 : component embedded_soc
	port map (
		clk_clk                   => CLOCK_50,    --                clk.clk
		led_export                => LEDR_export, --                led.export
		reset_reset_n             => KEY(0),      --              reset.reset_n
		switches_export           => SW,          --           switches.export
		buttons_export            => KEY,         --            buttons.export
		nios_input_export_export  => NIOS_input,  --  nios_input_export.export
		nios_output_export_export => NIOS_output  -- nios_output_export.export
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
			wait_count <= (others => '1');
			if state(0) = '1' then 	
				IrisDataType <= '0';  --state 0 loads training data	   
				if count < 120 then 
					count <= count + 1; 
					IrisIndex <= to_unsigned(count + 1, 7);
				else count <= 0;
				end if;	
				
				if count > 0 then
					training_data(count - 1) <= IrisDataOut; 
				end if;
				
				
			elsif state(1) = '1' then 			 --may need to change state for this line. this state is for running through the testing data
				IrisDataType <= '1'; -- run through testing data
				wait_count <= wait_count - 1;  
				IrisIndex <= to_unsigned(count + 1, 7);
				test_data <= IrisDataOut;
				if wait_count = wait_zero then
					if count < 40 then
						count <= count + 1;			
						classifications(count + 1) <= knn_out; -- knn_out is the predicted class of the item. possibly different name;
					end if;
					
				end if;
			else count <= 0;	
			end if;	
		end if;
	end process;
	
	
	
	
end architecture arch;