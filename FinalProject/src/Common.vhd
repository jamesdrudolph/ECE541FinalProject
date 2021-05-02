library ieee;
use ieee.numeric_std.all;	
use ieee.std_logic_1164.all;

package Common is
	type DataAttributes is array(0 to 4) of integer; -- range 0 to 127;	  
	type DataArray is array(0 to 119) of DataAttributes; 
	type TestClass is array(1 to 30) of integer range 0 to 2;  
	type DataSlice is array(1 to 40) of DataAttributes;		
	type classarr is array(natural range <>) of integer range 0 to 2;	
	type distarr is array(natural range <>) of unsigned(7 downto 0);
	type std_array is array(1 to 40) of std_logic_vector(7 downto 0);  
	type distarr_array is array(0 to 2) of distarr(1 to 5);
end Common;
