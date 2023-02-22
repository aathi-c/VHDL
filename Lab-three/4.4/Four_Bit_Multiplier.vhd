
-- First VHDL code for SYDE-192 Lab 
-- It implements three primitive gates of AND, OR, and NOT (inverter) 
library ieee;					-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity Four_Bit_Multiplier is 	-- entity definition 
	port( 
			SW: 		in 	std_logic_vector(7 downto 0); 	-- Toggle switches  
			HEX0:		out 	std_logic_vector(6 downto 0);
			HEX1:		out 	std_logic_vector(6 downto 0);
			HEX2:		out 	std_logic_vector(6 downto 0);
			HEX3:		out 	std_logic_vector(6 downto 0)
			); 
end entity Four_Bit_Multiplier;

architecture RTL of Four_Bit_Multiplier is 
signal a0, a1, a2, a3, b0, b1, b2, b3:	std_logic;	-- Naming inputs 
signal i0,s0,o0,s1,s2,s3,o1, o2, o3: std_logic;
signal d0,d1,d2,d3,d4,d5,d6, d7: std_logic;
signal cout, cout1,cout2: std_logic;
signal s4,s5,s6,s7,s8,s9,s10,s11: std_logic;
signal o4,o5,o6,o7,o8,o9,o10,o11: std_logic;

component Full_Adder is
port (

	a, b: in std_logic; -- a, b are inputs. cin is overflow digit of prev full adder, s is the answer of the addition, cout is the overflow of the current full adder
	coutFullAdder: out std_logic
	);
end component;	
--
--component seven_segment is
--port (
--
--	x, y: in std_logic;
--	hexOutput: out std_logic
--	);
--end component;	

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







-- 4 bit adder 1

cmpt1: entity work.Full_Adder(RTL) port map(a0 and b1, a1 and b0, '0', s0, o0);
cmpt2: entity work.Full_Adder(RTL) port map(a1 and b1, a2 and b0, o0, s1, o1);
cmpt3: entity work.Full_Adder(RTL) port map(a2 and b1, a3 and b0, o1, s2, o2);
cmpt4: entity work.Full_Adder(RTL) port map(a3 and b1, '0', o2, s3, o3);

cout <= o3;



-- 4 bit adder 2

cmpt5: entity work.Full_Adder(RTL) port map(a0 and b2, s1, '0', s4, o4); --  unsure about the carry in here being cout
cmpt6: entity work.Full_Adder(RTL) port map(a1 and b2, s2, o4, s5, o5);
cmpt7: entity work.Full_Adder(RTL) port map(a2 and b2, s3, o5, s6, o6);
cmpt8: entity work.Full_Adder(RTL) port map(a3 and b2, cout, o6, s7, o7);

cout1 <= o7;



-- 4 bit adder 3

cmpt9: entity work.Full_Adder(RTL) port map(a0 and b3, s5, '0', s8, o8); --  unsure about the carry in here being cout OR MAKE 0
cmpt10: entity work.Full_Adder(RTL) port map(a1 and b3, s6, o8, s9, o9);
cmpt11: entity work.Full_Adder(RTL) port map(a2 and b3, s7, o9, s10, o10);
cmpt12: entity work.Full_Adder(RTL) port map(a3 and b3, cout1, o10, s11, o11);

cout2 <= o11;


d0 <= a0 and b0;
d1 <= s0;
d2 <= s4;
d3 <= s8;
d4 <= s9;
d5 <= s10;
d6 <= s11;
d7 <= cout2;


-- o3 & s3 is the 5 bit output

-- the ans
hex0_inst: entity work.seven_segment(behavioral) port map(d3 & d2 & d1 & d0, '0', HEX0);
hex1_inst: entity work.seven_segment(behavioral) port map(d7 & d6 & d5 & d4, '0', HEX1);

-- the input 
hex2_inst: entity work.seven_segment(behavioral) port map(a3 & a2 & a1 & a0, '0', HEX2);
hex3_inst: entity work.seven_segment(behavioral) port map(b3 & b2 & b1 & b0, '0', HEX3);


  

end architecture; 
