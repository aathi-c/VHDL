-- This program blinks all LEDs on an 8x8 LED Dot Matrix Display
-- Written by Rasoul Keshavarzi, Winter 2022 term
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project_2 is
port(CLOCK_50_B5B: in  std_logic ;
GPIO: out std_logic_vector(35 downto 0));
end entity Project_2;

Architecture main of Project_2 is

signal row_driver: std_logic_vector(0 to 7) := "10000000";
signal col_driver: std_logic_vector(0 to 7) := "01111111";

signal r_bits: std_logic_vector(0 to 63) := "0111110010000010100010101000101001001110000000000000000000000000" ;


signal counter10: unsigned(24 downto 0);
signal clock10: std_logic;

begin
	update: process (CLOCK_50_B5B)
	begin
	if rising_edge(CLOCK_50_B5B) then
		if counter10 = to_unsigned(249, 25) then
			counter10 <= to_unsigned(0, 25);
			clock10 <= not clock10;
			r_bits <= r_bits(8 to 63) & r_bits(0 to 7);
			row_driver <= (r_bits(0 to 7));
				col_driver <= col_driver(7) & col_driver(0 to 6);
				else
					counter10 <= counter10 + 1;
				end if;
	end if;

end process update;
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
