library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity knn_class is
	port (
		CLK			:	in	std_logic;							   -- This uses 40 training values at a time in the order then appear in IrisDataManager
		TrainingData:	in	DataSlice;							   -- Thus the class of each training data point is the same so it need not be output
		TestData	:	in	DataAttributes;			  
		min_dists	:	out distarr(1 to 5)
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
	signal dist1: distarr(1 to 20);
	signal dist2: distarr(1 to 10);
	
	
begin
	
	knn: for i in 1 to 40 generate		  --calculate distances
		e: component EuclideanDistance
		port map(CLK, TrainingData(i), TestData, dist_std(i)); 
		dist_un(i) <= unsigned(dist_std(i));
	end generate;
	
	d1: for j in 1 to 20 generate
		process(dist_un)
		begin
			if dist_un(2 * j - 1) > dist_un(2 * j) then
				dist1(j) <= dist_un(2 * j);
			else
				dist1(j) <= dist_un(2 * j - 1);	 
			end if;
		end process;
	end generate;	
	
	d2: for n in 1 to 10 generate
		process(dist1)
		begin
			if dist1(2 * n - 1) > dist1(2 * n) then
				dist2(n) <= dist1(2 * n);
			else
				dist2(n) <= dist1(2 * n - 1);
			end if;
		end process;
	end generate;
	
	d3: for m in 1 to 5 generate
		process(dist2)
		begin
			if dist2(2 * m - 1) > dist2(2 * m) then
				min_dists(m) <= dist2(2 * m);
			else
				min_dists(m) <= dist2(2 * m - 1);
			end if;
		end process;
	end generate;
	
	
	
	
end architecture;
