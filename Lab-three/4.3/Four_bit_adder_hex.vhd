-- First VHDL code for SYDE-192 Lab 
-- It implements three primitive gates of AND, OR, and NOT (inverter) 
library ieee;					-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity Four_bit_adder_hex is 	-- entity definition 
	port( 
			SW: 		in 	std_logic_vector(7 downto 0); 	-- Toggle switches 
			LEDG:		out 	std_logic_vector(4 downto 0); 	-- Red LEDs 
			HEX0:		out 	std_logic_vector(6 downto 0);
			HEX1:		out 	std_logic_vector(6 downto 0);
			HEX2:		out 	std_logic_vector(6 downto 0);
			HEX3:		out 	std_logic_vector(6 downto 0)
			); 
end entity Four_bit_adder_hex;

architecture RTL of Four_bit_adder_hex is 
signal a0, a1, a2, a3, b0, b1, b2, b3:	std_logic;	-- Naming inputs 
signal i0,s0,o0,s1,s2,s3,o1, o2, o3: std_logic;

component Four_bits_adder is
port (

	a, b: in std_logic;
	S: out std_logic
	);
end component;	

begin 
i0 <= '0';
a0 <= SW(0); 
a1 <= SW(1);
a2 <= SW(2);
a3 <= SW(3); 
b0 <= SW(4); 
b1 <= SW(5);
b2 <= SW(6); 
b3 <= SW(7);  


cmpt1: entity work.Full_Adder(RTL) port map(a0, b0, i0, s0, o0);
cmpt2: entity work.Full_Adder(RTL) port map(a1, b1, o0, s1, o1);
cmpt3: entity work.Full_Adder(RTL) port map(a2, b2, o1, s2, o2);
cmpt4: entity work.Full_Adder(RTL) port map(a3, b3, o2, s3, o3);


-- o3 & s3 is the 5 bit output

-- the ans
hex0_inst: entity work.seven_segment(behavioral) port map(s3 & s2 & s1 & s0, '0', HEX0);
hex1_inst: entity work.seven_segment(behavioral) port map("000" & o3, '0', HEX1);

-- the input 
hex2_inst: entity work.seven_segment(behavioral) port map(a3 & a2 & a1 & a0, '0', HEX2);
hex3_inst: entity work.seven_segment(behavioral) port map(b3 & b2 & b1 & b0, '0', HEX3);


  

end architecture; 
			
