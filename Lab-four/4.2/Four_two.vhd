library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_two is 
	port ( 	CLOCK_50_B5B: in std_logic;
				LEDR:	out std_logic_vector(9 downto 0);
				LEDG:	out std_logic_vector(7 downto 0);
				KEY: in std_logic_vector(1 downto 0)
			);	
end entity Four_two; 


architecture RTL of Four_two is 

signal counter: unsigned(31 downto 0); --random 8 bit number






begin 
	counter <= counter + 1 when rising_edge(CLOCK_50_B5B); --increment at each rising_edge == 1 cycle
	LEDR(9 downto 0) <= std_logic_vector(counter(31 downto 22));
	LEDG(7 downto 0) <= std_logic_vector(counter(21 downto 14));


end architecture RTL; 