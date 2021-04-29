library ieee;
use ieee.numeric_std.all;

package Common is
	type DataAttributes is array(0 to 4) of integer range 0 to 127;	  
	type DataArray is array(0 to 119) of DataAttributes; 
	type TestClass is array(1 to 40) of integer range 0 to 2;
end Common;
