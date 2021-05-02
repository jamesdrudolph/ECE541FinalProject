library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity classifier is
	port (
		CLK			:	in	std_logic;							   
		rst			:	in 	std_logic;
		mins		: 	in	distarr_array; 
		class		: 	out integer range 0 to 2;
		done		: 	out std_logic
		);
end entity classifier;	 

architecture arch of classifier is
	signal count0, count1, count2: integer range 0 to 5 := 0;
	signal round: integer range 1 to 5 := 1;
	
begin
	
	process(count0, count1, count2)
	begin
		if count0 > count1 and count0 > count2 then
			class <= 0; 
		elsif count1 > count2 then
			class <= 1;	 
		else
			class <= 2;
		end if;
	end process;
	
	process(clk, rst)
	begin
		if rst = '1' then
			count0 <= 0;
			count1 <= 0;
			count2 <= 0;
			round <= 1;	
			done <= '0';
		elsif rising_edge(clk) then
			--need to make acutally sequential so it counts properly 
			case round is
				when 5 =>
				done <= '1';
				when others => 
				done <= '0';
			end case;
			
			if round < 5 then
				round <= round + 1;	
			end if;
			
			if count0 + count1 + count2 < 5 then	  
				-- This is probably not technically correct but it will most likely produce a decent result	
				if mins(0)(round) < mins(1)(round) and mins(0)(round) < mins(2)(round) then	 
					count0 <= count0 + 1;
				elsif mins(1)(round) < mins(2)(round) then
					count1 <= count1 + 1;	  	
				else 
					count2 <= count2 + 1;
				end if;
				
			end if;			
		end if;
	end process;
	
	
end architecture;
