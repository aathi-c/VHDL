library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Four_five is 
	port ( 	CLOCK_50_B5B: in std_logic;
				HEX0, HEX3:	out std_logic_vector(6 downto 0);
				LEDR: out std_logic_vector(4 downto 0);
				LEDG: out std_logic_vector(7 downto 0)
			);	
end entity Four_five; 


architecture RTL of Four_five is 

signal hex_0: std_logic_vector(3 downto 0);
signal hex_3: std_logic_vector(3 downto 0);


type state_names is (greenEW, leftTurnEW, amberEW, redEW);
type state_namesNS is (greenNS, leftTurnNS, amberNS, redNS);

signal state, next_state: state_names ;
signal stateNS, next_stateNS: state_namesNS ;
signal counter: unsigned(21 downto 0);
signal counter2: unsigned(2 downto 0);
signal time_count: unsigned(4 downto 0);
signal clock10: std_logic;
signal dummy: std_logic;
signal clock1: std_logic;

signal state_count: unsigned(3 downto 0) := "0000";
signal time_spent: unsigned(4 downto 0);
signal time_spent_NS: unsigned(4 downto 0);
signal lowest_time_spent: unsigned(4 downto 0);


component seven_segment is 
	port (data_in: 	in  std_logic_vector(3 downto 0); 
			blanking: in  std_logic;
			segments_out: out std_logic_vector(6 downto 0)
			);
end component;

begin 

TLC: process (time_count)
begin

case state is
	when greenEW =>
		LEDG(4) <= '1';
		LEDR(4) <= '0';
		time_spent <= time_count - to_unsigned(1, 5);	
	when leftTurnEW =>
		LEDG(4) <= clock10;
		LEDR(4) <= '0';
		time_spent <= time_count;
		if time_count = to_unsigned(0, 5) then
			time_spent <= to_unsigned(1, 5);
		else
			time_spent <= to_unsigned(2, 5);
		end if;
	when amberEW =>
		LEDG(4) <= '0';
		LEDR(4) <= clock10;
		time_spent <= time_count - to_unsigned(6, 5);
	when redEW =>
		LEDG(4) <= '0';
		LEDR(4) <= '1';
		time_spent <= time_count - to_unsigned(9, 5);
	when others => dummy <= '1';
end case;

case stateNS is
	when greenNS =>
		LEDG(7) <= '1';
		LEDR(0) <= '0';
		time_spent_NS <= time_count - to_unsigned(12, 5);
	when leftTurnNS =>
		LEDG(7) <= clock10;
		LEDR(0) <= '0';
		time_spent_NS <= time_count - to_unsigned(10, 5);
	when amberNS =>
		LEDG(7) <= '0';
		LEDR(0) <= clock10;
		time_spent_NS <= time_count - to_unsigned(17, 5);
	when redNS =>
		LEDG(7) <= '0';
		LEDR(0) <= '1';
		time_spent_NS <= time_count - to_unsigned(20, 5);
	when others => dummy <= '1';
end case;	
end process TLC;

assignment: process (time_count)
begin
		if time_count >= to_unsigned(0, 5) and time_count <= to_unsigned(1, 5) then
			next_state <= leftTurnEW;	
		elsif time_count > to_unsigned(1, 5) and time_count <= to_unsigned(6, 5) then
			next_state <= greenEW;		
		elsif time_count > to_unsigned(6, 5) and time_count <= to_unsigned(9, 5) then
			next_state <= amberEW;
		else 
			next_state <= redEW;
		end if;
		if time_count >= to_unsigned(0, 5) and time_count <= to_unsigned(10, 5) then
			next_stateNS <= redNS;
		elsif time_count > to_unsigned(10, 5) and time_count <= to_unsigned(12, 5) then
			next_stateNS <= leftTurnNS;		
		elsif time_count > to_unsigned(12, 5) and time_count <= to_unsigned(17, 5) then
			next_stateNS <= greenNS;
		elsif time_count > to_unsigned(17, 5) and time_count <= to_unsigned(20, 5) then
			next_stateNS <= amberNS;
		else
			next_stateNS <= redNS;
		end if;
		
		-- state count logic
		if time_count >= to_unsigned(0, 5) and time_count <= to_unsigned(1, 5) then
			state_count <= to_unsigned(0, 4);
		elsif time_count > to_unsigned(1, 5) and time_count <= to_unsigned(6, 5) then
			state_count <= to_unsigned(1, 4);
		elsif time_count > to_unsigned(6, 5) and time_count <= to_unsigned(9, 5) then
			state_count <= to_unsigned(2, 4);
		elsif time_count > to_unsigned(9, 5) and time_count <= to_unsigned(10, 5) then
			state_count <= to_unsigned(3, 4);
		elsif time_count > to_unsigned(10, 5) and time_count <= to_unsigned(12, 5) then
			state_count <= to_unsigned(4, 4);
		elsif time_count > to_unsigned(12, 5) and time_count <= to_unsigned(17, 5) then
			state_count <= to_unsigned(5, 4);
		elsif time_count > to_unsigned(17, 5) and time_count <= to_unsigned(20, 5) then
			state_count <= to_unsigned(6, 4);
		else
			state_count <= to_unsigned(7, 4);
		end if;		
end process assignment;

update: process (time_count)
begin
	state <= next_state;
	stateNS <= next_stateNS;
	
	if time_spent <= time_spent_NS then
		lowest_time_spent <= time_spent;
	else
		lowest_time_spent <= time_spent_NS;
	end if;	
end process update;
	
	

-- 50mhz to 10mhz
counter_process_to_10: process (CLOCK_50_B5B)
begin
	if rising_edge(CLOCK_50_B5B) then
		if counter = to_unsigned(2499999, 22) then --Cycle
			counter <= to_unsigned(0, 22);
			clock10 <= not clock10;
		else
			counter <= counter + 1; --Increment
		end if;
	end if;
end process counter_process_to_10;

-- 10mhz to 1 mhz
counter_process_to_1: process (clock10)
begin
	if clock10 = '1' then
		if counter2 = to_unsigned(4, 3) then --Cycle
			counter2 <= to_unsigned(0,3);
			clock1 <= not clock1;
		else
			counter2 <= counter2 + 1; --Increment
		end if;
	end if;
end process counter_process_to_1;

--increments time each second and resets it
time_counter: process (clock1)
begin
	if clock1 = '1' then
		if time_count = to_unsigned(22, 5) then --Cycle
			time_count <= to_unsigned(0, 5);
		else
			time_count <= time_count + 1; --Increment
		end if;
	end if;
end process time_counter;



hex_0 <= std_logic_vector(lowest_time_spent(3 downto 0) - to_unsigned(1, 4));
hex0_inst: entity work.seven_segment(RTL) port map(hex_0, '0', hex0);

hex_3 <= std_logic_vector(state_count);
hex3_inst: entity work.seven_segment(RTL) port map(hex_3, '0', hex3);

end architecture RTL; 