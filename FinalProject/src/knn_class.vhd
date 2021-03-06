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
	signal dist_un, distu: distarr(1 to 40) := (others => (others => '0')); 
	signal comp: std_logic_vector(1 to 39);
	constant done_const: std_logic_vector(1 to 39) := (others => '1');
	signal switch: std_logic_vector(1 downto 0) := "00";	   
	signal count: integer range 0 to 10 := 10;
	
begin
	
	knn: for i in 1 to 40 generate		  --calculate distances
		e: component EuclideanDistance
		port map(CLK, TrainingData(i), TestData, dist_std(i)); 
		distu(i) <= unsigned(dist_std(i));
	end generate;	   
	
	process(clk, rst)
	begin
		if rst = '1' then
			switch <= "00";
			count <= 10; 
			comp <= (others => '0');
			dist_un <= (others => (others => '0'));
		elsif rising_edge(clk) then	
			switch(0) <= not switch(0);
			case switch(1) is
				when '0' =>
					if count = 0 then
						switch(1) <= '1';
						dist_un <= distu;
					else
						count <= count - 1;
				end if;
				when others =>	
					case switch(0) is
						when '0' =>
							for j in 1 to 20 loop
								if dist_un(2*j-1) > dist_un(2*j) then
									dist_un(2*j) <= dist_un(2*j-1);
									dist_un(2*j-1) <= dist_un(2*j);
									comp(j) <= '0';
								else
									comp(j) <= '1';
								end if; 
						end loop;
						when others =>
							for n in 1 to 19 loop
								if dist_un(2*n) > dist_un(2*n+1) then	
									dist_un(2*n) <= dist_un(2*n+1);
									dist_un(2*n+1) <= dist_un(2*n);
									comp(n+20) <= '0';
								else
									comp(n+20) <= '1';
								end if;
						end loop;
				end case;
			end case;  
			
		end if;
	end process;
	
	
	min_dists <= dist_un(1 to 5);				   
	done <= '1' when comp = done_const else '0';
	
end architecture;
