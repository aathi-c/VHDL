library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_three is 
	port ( 	CLOCK_50_B5B: in STD_LOGIC;
				LEDG:	out std_logic_vector(5 downto 0);
				LEDR:	out std_logic_vector(0 downto 0)
			);	
end entity Four_three;

architecture RTL of Four_three is
signal clock: std_logic;
signal counter: unsigned(24 downto 0);
signal counter2: unsigned(31 downto 0); --random 8 bit number

begin 

	counter2 <= counter2 + 1 when rising_edge(CLOCK_50_B5B); --increment at each rising_edge == 1 cycle
	counter_process: process (CLOCK_50_B5B) --Syntax for starting process, neccessary for if statements
	begin
		if rising_edge(CLOCK_50_B5B) then

		
			if counter = to_unsigned(24999999, 25) then --Cycle
				counter <= to_unsigned(0, 25);
				clock <= not clock;
				
			else
				counter <= counter + 1; --Increment
				
			end if;
			
			
		end if;
		
	end process counter_process; --Syntax for declaring end of process

	
	LEDG(5) <= clock; --Assign to LED
	LEDR(0) <= counter2(25);

end architecture RTL;
