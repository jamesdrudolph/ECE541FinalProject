library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity FinalProject is
	port (
		CLOCK_50	:	in	std_logic;
		KEY			:	in	std_logic_vector(3 downto 0);
		SW			:	in	std_logic_vector(9 downto 0);
		LEDR		:	out	std_logic_vector(9 downto 0);
		HEX0 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
		HEX1 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
		HEX2 		:	OUT STD_LOGIC_VECTOR(0 to 6);
		HEX3 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
		HEX4 		: 	OUT STD_LOGIC_VECTOR(0 to 6);
		HEX5 		: 	OUT STD_LOGIC_VECTOR(0 to 6)
		);
end entity FinalProject;

architecture arch of FinalProject is	
		component embedded_soc is
		port (
			clk_clk            : in  std_logic                     := 'X';             -- clk
			led_export         : out std_logic_vector(9 downto 0);                     -- export
			reset_reset_n      : in  std_logic                     := 'X';             -- reset_n
			switches_export    : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			buttons_export     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			nios_input_export  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			nios_output_export : out std_logic_vector(31 downto 0)                     -- export
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
	
	component knn_class is
		port (
			CLK			:	in	std_logic;							   
			TrainingData:	in	DataSlice;							   
			TestData	:	in	DataAttributes;
			rst			:	in 	std_logic;
			min_dists	:	out distarr(1 to 5);
			done		: 	out std_logic
			);
	end component knn_class;
	
	component classifier is
		port (
			CLK			:	in	std_logic;							   
			rst			:	in 	std_logic;
			mins		: 	in	distarr_array; 
			class		: 	out integer range 0 to 2;
			done		: 	out std_logic
			);
	end component classifier;
	
	
	signal LEDR_export	:	std_logic_vector(9 downto 0);
	signal nios_input_export : std_logic_vector(31 downto 0);
	signal nios_output_export : std_logic_vector(31 downto 0);
	
	signal IrisDataType	:	std_logic;
	signal IrisDataOut	:	DataAttributes;
	signal IrisIndex	:	unsigned(6 downto 0);
	
	signal SqrtRadical	:	std_logic_vector(15 downto 0);
	signal SqrtResult	:	std_logic_vector(7 downto 0);
	signal SqrtRemainder:	std_logic_vector(8 downto 0);	 
	
	signal state, nstate: std_logic_vector(3 downto 0) := "0001"; --size may change	 
	signal count: integer range 0 to 120 := 0;
	signal training_data: DataArray;	 
	--signal wait_count: unsigned(2 downto 0) := (others => '1'); --may need to adjust depending on how long classification takes	 
	--signal wait_zero: unsigned(wait_count'range) := (others => '0');
	signal test_data: DataAttributes;		 
	signal classifications: TestClass;	
	signal knn_out: integer range 0 to 2;	  
	signal rst_k, rst_c: std_logic;
	signal done_k, done_c: std_logic;
	signal kData: DataSlice;
	signal min_dists: distarr(1 to 5);
	
	signal mins: distarr_array;		 
	constant data_offset: integer := 40;	
	signal offset_count: integer range 0 to 2 := 0;	 
	signal offset: integer range 0 to 80;
	signal data_sel: unsigned(4 downto 0);
	signal readyState: std_logic;	  -- signal to change states 
	--signal class_out: integer range 0 to 2;
	
begin
		
	u0 : component embedded_soc
	port map (
		clk_clk            => CLOCK_50,            --         clk.clk
		led_export         => LEDR_export,         --         led.export
		reset_reset_n      => KEY(0),      --       reset.reset_n
		switches_export    => SW,    --    switches.export
		buttons_export     => KEY,     --     buttons.export
		nios_input_export  => nios_input_export,  --  nios_input.export
		nios_output_export => nios_output_export  -- nios_output.export
	);
	
	u1 : component IrisDataManager
	port map (
		CLK					=> CLOCK_50,
		SelectDataType		=> IrisDataType,
		SelectDataIndex		=> IrisIndex,
		SelectDataOut		=> IrisDataOut
		);	  
	
	k1 : component knn_class
	port map (
		clk					=> CLOCK_50,
		TrainingData		=> kData,							   
		TestData			=> test_data,
		rst					=> rst_k,
		min_dists			=> min_dists,
		done				=> done_k
		);	   
	
	c1: component classifier
	port map (
		CLK					=> CLOCK_50,							   
		rst					=> rst_c,
		mins				=> mins, 
		class				=> knn_out,
		done				=> done_c
		);
	
	offset <= data_offset * offset_count;	
	s1: for i in 1 to 40 generate
		kData(i) <= training_data(i - 1 + offset);
	end generate;  
	
	LEDR(9 downto 4) <= (others => '0');
	LEDR(3 downto 0) <= state; 
	
	HEX1 <= (others => '0');
	HEX2 <= (others => '0');
	HEX3 <= (others => '0');
	HEX4 <= (others => '0');
	HEX5 <= (others => '0');
	
	data_sel <= unsigned(SW(4 downto 0));
	readyState <= KEY(1);
	
	process(data_sel, classifications)
	begin
		if to_integer(data_sel) = 0 or to_integer(data_sel) > 30 then
			HEX0 <= (others => '0');
		else
			case classifications(to_integer(data_sel)) is
				when 0 => HEX0 <= "0000001";
				when 1 => HEX0 <= "1001111";
				when 2 => HEX0 <= "0010010";
				when others => HEX0 <= (others => '0');
			end case;
		end if;
	end process;
	
	
	process(CLOCK_50)
	begin	
		if KEY(0) = '0' then
			state <= "0001";
			count <= 0;
		elsif rising_edge(CLOCK_50) then
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
				rst_k <= '1';
				rst_c <= '1';
				
			elsif state(1) = '1' then 			 --may need to change state for this line. this state is for running through the testing data
				IrisDataType <= '1'; -- run through testing data	
				rst_k <= '0'; 
				if done_k = '1' then 
					if offset_count < 2 then
						offset_count <= offset_count + 1;
					else
						offset_count <= 0; 
						rst_c <= '0';
					end if;		 
					mins(offset_count) <= min_dists;
					rst_k <= '1';  
				end if;
				
				IrisIndex <= to_unsigned(count, 7);
				test_data <= IrisDataOut;
				if done_c = '1' then
					if count < 29 then
						count <= count + 1;			
					end if;
					rst_c <= '1';  
					classifications(count + 1) <= knn_out; -- knn_out is the predicted class of the item. possibly different name
				end if;
			else count <= 0;
			end if;	
		end if;	  
	
	end process; 
	
	process(state, count)
	begin	
		nstate <= (others => '0');
		case state is
			when "0001" =>						   -- state 0 loads training data
				if count = 120 then
					nstate(1) <= '1';
				else
					nstate(0) <= '1';
			end if;
			when "0010" =>							-- state 2\1 goes through testing data and classifies
				if count = 29 then
					nstate(2) <= '1'; 
				else
					nstate(1) <= '1';
			end if;		
			when "0100" =>                       -- state 3 "wait state" do not continue until readyState signal  
			if readyState = '0' then
				nstate <="1000";
			else 
				nstate <="0100";
			end if;
			when "1000" =>
			nstate <= "0001";					  -- state 4 still being developed. perhaps wait for console input
			when others => 
			nstate(0) <= '1';
		end case; 
		
	end process;
	
	
end architecture arch;