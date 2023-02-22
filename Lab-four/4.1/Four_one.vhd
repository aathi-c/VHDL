library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_one is 
	port ( 	KEY: in std_logic_vector(1 downto 0);
				HEX0, HEX1: out std_logic_vector(6 downto 0);
				LEDG:	out std_logic_vector(4 downto 0)
			);	
end entity Four_one;

architecture RTL of Four_one is
signal clock: std_logic;
signal counter: unsigned(4 downto 0);
signal enable: std_logic := '1';
signal hex_0: unsigned(3 downto 0);
signal hex_1: unsigned(3 downto 0);


component seven_segment is 
	port (data_in: 	in  std_logic_vector(3 downto 0); 
			blanking: in  std_logic;
			segments_out: out std_logic_vector(6 downto 0)
			);
end component;

begin 
		counter <= counter + 1 when rising_edge(KEY(0));
		LEDG(0) <= counter(0);
		LEDG(1) <= counter(1);
		LEDG(2) <= counter(2);
		LEDG(3) <= counter(3);
		LEDG(4) <= counter(4);
		
		
		counter_process: process(counter) --Syntax for starting process, neccessary for if statements
		begin

	
		end process counter_process;
		
		
		hex_0 <= counter(3 downto 0);
		hex_1 <= "000" & counter(4);
		
   	hex0_inst: entity work.seven_segment(RTL) port map(std_logic_vector(hex_0), '0', HEX0);
		hex1_inst: entity work.seven_segment(RTL) port map(std_logic_vector(hex_1), not std_logic(counter(4)) , HEX1);
	
	
	


end architecture RTL;