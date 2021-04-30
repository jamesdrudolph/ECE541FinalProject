library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity knn_class is
	port (
		CLK			:	in	std_logic;							   -- This uses 40 training values at a time in the order then appear in IrisDataManager
		TrainingData:	in	DataSlice;							   -- Thus the class of each training data point is the same so it need not be output
		TestData	:	in	DataAttributes;			  
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
	
	
begin
	
	knn: for i in 1 to 40 generate		  --calculate distances
		e: component EuclideanDistance
		port map(CLK, TrainingData(i), TestData, dist_std(i)); 
		dist_un(i) <= unsigned(dist_std(i));
	end generate;
	
	
	d1: for j in 1 to 39 generate
		process(clk)
		begin  
			if rising_edge(clk) then
				if dist_un(j) > dist_un(j + 1) then
					dist_un(j) <= dist_un(j + 1);
					dist_un(j + 1) <= dist_un(j);	
					comp(j) <= '0';
				else
					comp(j) <= '1';
				end if;
			end if;
		end process;
	end generate;		
	
	min_dists <= dist_un(1 to 5);				   
	done <= '1' when comp = done_const else '0';
	
end architecture;
