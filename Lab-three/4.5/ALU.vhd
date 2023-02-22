
-- First VHDL code for SYDE-192 Lab 
-- It implements three primitive gates of AND, OR, and NOT (inverter) 
library ieee;					-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity ALU is 	-- entity definition 
	port( 
			SW: 		in 	std_logic_vector(8 downto 0); 	-- Toggle switches  
			HEX0:		out 	std_logic_vector(6 downto 0);
			HEX1:		out 	std_logic_vector(6 downto 0);
			HEX2:		out 	std_logic_vector(6 downto 0);
			HEX3:		out 	std_logic_vector(6 downto 0)
			); 
end entity ALU;

architecture RTL of ALU is 
signal a0, a1, a2, a3, b0, b1, b2, b3:	std_logic;	-- Naming inputs 
signal i0,s0,o0,s1,s2,s3,o1, o2, o3: std_logic;
signal d0,d1,d2,d3,d4,d5,d6, d7: std_logic;
signal cout, cout1,cout2: std_logic;
signal s4,s5,s6,s7,s8,s9,s10,s11, s30, s31, s32, s33: std_logic;
signal o4,o5,o6,o7,o8,o9,o10,o11, o30, o31, o32, o33: std_logic;
signal multiply, finalOut0, finalOut1: std_logic;
signal f1,f2,f3,f4,f5,f6,f7,f8: std_logic;
signal x1,x2,x3,x4,x5,x6,x7,x8, x9, x10, x11, x12, x13: std_logic;

component Full_Adder is
port (

	a, b: in std_logic; -- a, b are inputs. cin is overflow digit of prev full adder, s is the answer of the addition, cout is the overflow of the current full adder
	coutFullAdder: out std_logic
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
multiply <= SW(8);





	
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

cmpt20: entity work.Full_Adder(RTL) port map(a0, b0, i0, s30, o30);
cmpt21: entity work.Full_Adder(RTL) port map(a1, b1, o30, s31, o31);
cmpt22: entity work.Full_Adder(RTL) port map(a2, b2, o31, s32, o32);
cmpt23: entity work.Full_Adder(RTL) port map(a3, b3, o32, s33, o33);

x1 <= d0;
x2 <= d1;
x3 <= d2;
x4 <= d3;
x5 <= d4;
x6 <= d5;
x7 <= d6;
x8 <= d7;
x9 <= s30;
x10 <= s31;
x11 <= s32;
x12 <= s33;
x13 <= o33;

f1 <= x1 when SW(8) = '1' else x9;
f2 <= x2 when SW(8) ='1' else x10;
f3 <= x3 when SW(8)='1' else x11;
f4 <= x4 when multiply ='1' else x12;

f5 <= x8 when multiply = '1' else '0';
f6 <= x7 when multiply = '1' else '0';
f7 <= x6 when multiply = '1' else '0';
f8 <= x5 when multiply = '1' else x13;


-- the ans
hex0_inst: entity work.seven_segment(behavioral) port map(f4 & f3 & f2 & f1, '0', HEX0);
hex1_inst: entity work.seven_segment(behavioral) port map(f5 & f6 & f7 & f8, '0', HEX1);

-- the input 
hex2_inst: entity work.seven_segment(behavioral) port map(a3 & a2 & a1 & a0, '0', HEX2);
hex3_inst: entity work.seven_segment(behavioral) port map(b3 & b2 & b1 & b0, '0', HEX3);


  

end architecture; 
