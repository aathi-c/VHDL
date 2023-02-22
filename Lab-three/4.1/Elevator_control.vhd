-- First VHDL code for SYDE-192 Lab 
-- It implements three primitive gates of AND, OR, and NOT (inverter) 
library ieee;					-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity Elevator_control is 	-- entity definition 
	port( 
			SW: 		in 	std_logic_vector(3 downto 0); 	-- Toggle switches 
			LEDG:		out 	std_logic_vector(0 downto 0); 	-- Green LEDs 
			LEDR:		out 	std_logic_vector(1 downto 1) 	-- Red LEDs 
			);
end entity Elevator_control;

architecture main of Elevator_control is 
signal y, z, a, b, enable, e1, e2, e3, e4, d1, direction:	std_logic;	-- Naming inputs 


begin 
a <= SW(0);
b <= SW(1);
y <= SW(2); 
z <= SW(3); 


e1 <= a and (not y) and z;
e2 <= a and (not b) and z;
e3 <= not a and b and y;
e4 <= b and y and (not z);

enable <= e1 or e2 or e3 or e4;


d1 <= y and z;

direction <= not a or d1;


LEDG(0) <= enable;
LEDR(1) <= direction;  

end architecture main; 
			