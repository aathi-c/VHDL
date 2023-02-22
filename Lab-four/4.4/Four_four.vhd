library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_four is 
	port ( 	CLOCK_50_B5B: in std_logic;
				HEX0, HEX1:	out std_logic_vector(6 downto 0);
				HEX2, HEX3:	out std_logic_vector(6 downto 0);
				KEY: in std_logic_vector(1 downto 0)
			);	
end entity Four_four; 


architecture RTL of Four_four is 

signal generated_new: unsigned(7 downto 0);
signal generated_old: unsigned(7 downto 0);

signal random_8: unsigned(7 downto 0); --random 8 bit number
signal enable: std_logic := '0';       --to implement blanking
signal enable2: std_logic := '0';       --to implement blanking

signal hex_0: unsigned(3 downto 0);
signal hex_1: unsigned(3 downto 0);
signal hex_2: unsigned(3 downto 0);
signal hex_3: unsigned(3 downto 0);



component seven_segment is 
	port (data_in: 	in  std_logic_vector(3 downto 0); 
			blanking: in  std_logic;
			segments_out: out std_logic_vector(6 downto 0)
			);
end component;

begin 
	random_8 <= random_8 + 1 when rising_edge(CLOCK_50_B5B); --increment at each rising_edge == 1 cycle
	generated_old <= generated_new when rising_edge(KEY(0));
	generated_new <= random_8 when rising_edge(KEY(0));
	enable <= '1' when rising_edge(KEY(0)); --Key is pressed, therefore turn LED on
	enable2 <= '1' when rising_edge(KEY(0)) and generated_old /= "00000000" ; --Key is pressed, therefore turn LED on
	
	hex_2 <= generated_old(3 downto 0);
	hex_3 <= generated_old(7 downto 4);
	
	hex_0 <= generated_new(3 downto 0);
	hex_1 <= generated_new(7 downto 4);
	
	hex0_inst: entity work.seven_segment(RTL) port map(std_logic_vector(hex_0), not enable, hex0);
	hex1_inst: entity work.seven_segment(RTL) port map(std_logic_vector(hex_1), not enable, hex1);
	hex2_inst: entity work.seven_segment(RTL) port map(std_logic_vector(hex_2), not enable2, hex2);
	hex3_inst: entity work.seven_segment(RTL) port map(std_logic_vector(hex_3), not enable2, hex3);

end architecture RTL; 