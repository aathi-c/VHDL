-- This program blinks all LEDs on an 8x8 LED Dot Matrix Display 
-- Written by Rasoul Keshavarzi, Winter 2022 term 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project is 
	port(CLOCK_50_B5B:	in  std_logic ;    -- 50MHz clock on the board 
		 GPIO:			out std_logic_vector(35 downto 0)); 
end entity Project; 

Architecture main of Project is 
signal counter: unsigned(21 downto 0); -- as opposed to 23 downto 0
signal counter2: unsigned(2 downto 0);
signal counter3: unsigned(2 downto 0);
signal clock10: std_logic;
signal clock1: std_logic;
signal clock8: std_logic;
signal row_driver: std_logic_vector(0 to 7) := "10000000";
signal col_driver: std_logic_vector(0 to 7) := "01111111"; 



begin 

 --50mhz to 10hz
counter_process_to_10: process (CLOCK_50_B5B)
begin
	if rising_edge(CLOCK_50_B5B) then
		if counter = to_unsigned(2499999, 22) then --Cycle
			counter <= to_unsigned(0, 22);
			clock10 <= not clock10;
			col_driver <= col_driver(7) & col_driver(0 to 6);
			if col_driver(7) = '0' then
			row_driver <= row_driver(7) & row_driver(0 to 6);
			end if;
		else 
			counter <= counter + 1; --Increment
		end if;
	end if;
end process counter_process_to_10;




	GPIO( 0) <= row_driver(0); 	GPIO( 1) <= row_driver(0); 
	GPIO( 2) <= row_driver(1); 	GPIO( 3) <= row_driver(1); 
	GPIO( 4) <= row_driver(2); 	GPIO( 5) <= row_driver(2); 
	GPIO( 6) <= row_driver(3); 	GPIO( 7) <= row_driver(3); 
	GPIO( 8) <= row_driver(4); 	GPIO( 9) <= row_driver(4); 
	GPIO(10) <= row_driver(5); 	GPIO(11) <= row_driver(5); 
	GPIO(12) <= row_driver(6); 	GPIO(13) <= row_driver(6); 
	GPIO(14) <= row_driver(7); 	GPIO(15) <= row_driver(7); 
	
	GPIO(20) <= col_driver(0); 	GPIO(21) <= col_driver(0); 
	GPIO(22) <= col_driver(1); 	GPIO(23) <= col_driver(1); 
	GPIO(24) <= col_driver(2); 	GPIO(25) <= col_driver(2); 
	GPIO(26) <= col_driver(3); 	GPIO(27) <= col_driver(3); 
	GPIO(28) <= col_driver(4); 	GPIO(29) <= col_driver(4); 
	GPIO(30) <= col_driver(5); 	GPIO(31) <= col_driver(5); 
	GPIO(32) <= col_driver(6); 	GPIO(33) <= col_driver(6); 
	GPIO(34) <= col_driver(7); 	GPIO(35) <= col_driver(7); 

end architecture main;
