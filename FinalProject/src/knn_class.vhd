library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity knn_class is
	port (
		CLK			:	in	std_logic;							   -- This uses 40 training values at a time in the order then appear in IrisDataManager
		TrainingData:	in	DataSlice;							   -- Thus the class of each training data point is the same so it need not be output
		TestData	:	in	DataAttributes;
		rst			:	in 	std_logic;
		min_dists	:	out distarr(1 to 5);
		done		: 	out std_logic
		);
end entity knn_class;					 

architecture arch of knn_class is	   
	
	component EuclideanDistance is
		port (
			CLK			:	in	std_logic;
			TrainingData:	in	DataAttributes;
			TestData	:	in	DataAttributes;
			Distance	:	out	std_logic_vector(7 downto 0)
			);
	end component EuclideanDistance;  
	
	signal dist_std: std_array;
	signal dist_un: distarr(1 to 40); 
	signal comp: std_logic_vector(1 to 39);
	constant done_const: std_logic_vector(1 to 39) := (others => '1');
	signal switch: std_logic_vector(1 downto 0) := "00";	   
	signal count: integer range 0 to 10 := 10;
	
begin
	
	knn: for i in 1 to 40 generate		  --calculate distances
		e: component EuclideanDistance
		port map(CLK, TrainingData(i), TestData, dist_std(i)); 
	end generate;	   
	
	process(clk, rst)
	begin
		if rst = '1' then
			switch <= "00";
			count <= 10;
		elsif rising_edge(clk) then
			case switch(1) is
				when '0' =>
					if count = 0 then
						switch(1) <= '1';
					else
						count <= count - 1;
					end if;
				when others =>	
				switch(0) <= not switch(0);
			end case;
		end if;
	end process;
	
	
	
	
	d1: for j in 1 to 19 generate
		process(clk, rst)
		begin  		
			if rst = '1' then 
				comp(j) <= '0';	
				comp(j + 20) <= '0'; 
				
			elsif rising_edge(clk) then
				case switch is
					when "0-" =>
						dist_un(j) <= unsigned(dist_std(j));
					dist_un(j + 20) <= unsigned(dist_std(j + 20)); 
					when "10" =>
						if dist_un(2*j-1) > dist_un(2*j) then
							dist_un(2*j) <= dist_un(2*j-1);
							dist_un(2*j-1) <= dist_un(2*j);
							comp(j) <= '0';
						else
							comp(j) <= '1';
					end if;
					when others =>
						if dist_un(2*j) > dist_un(2*j+1) then	
							dist_un(2*j) <= dist_un(2*j+1);
							dist_un(2*j+1) <= dist_un(2*j);
							comp(j+20) <= '0';
						else
							comp(j+20) <= '1';
					end if;
				end case;
			end if;
			
			
		end process;
	end generate;	
	
	process(clk, rst)
	begin  		
		if rst = '1' then 
			comp(20) <= '0';	
		elsif rising_edge(clk) then
			case switch is
				when "0-" =>
					dist_un(20) <= unsigned(dist_std(20));
				dist_un(40) <= unsigned(dist_std(40)); 
				when "10" =>
					if dist_un(39) > dist_un(40) then
						dist_un(40) <= dist_un(39);
						dist_un(39) <= dist_un(40);
						comp(20) <= '0';
					else
						comp(20) <= '1';
				end if;
				when others =>
				null;
			end case;
		end if;
	end process;
	
	min_dists <= dist_un(1 to 5);				   
	done <= '1' when comp = done_const else '0';
	
end architecture;
