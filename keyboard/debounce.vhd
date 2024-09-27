library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
port(
		clk, rst : in std_logic;
		sw			: in std_logic;
		db			: out std_logic
	 );
end entity;
architecture beh of debounce is
constant N : integer := 19;		-- 2^N*20 ns = 10 ms
signal q_reg, q_next : unsigned(N-1 downto 0);
signal m_tick : std_logic;
type state is (Zero, wait1_1, wait1_2, wait1_3, one, wait0_1, wait0_2, wait0_3);
signal pr_state, nx_state : state;
begin

-- counter to generate 10 ms tick
process(clk, rst)
begin

if(rst = '1') then
	q_reg <= (others => '0');
elsif(clk = '1' and clk'EVENT) then
	q_reg <= q_next;
end if;
end process;

-- next state logic
q_next <= q_reg + 1;
-- output tick
m_tick <= '1' when q_reg = 0 else
			 '0';
			 
-- debouncing FSM
process(clk, rst)
begin

if(rst = '1') then
	pr_state <= zero;
elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
end if;
end process;

process(pr_state, m_tick, sw)
begin

nx_state <= pr_state;
db <= '0';

case pr_state is

when zero =>
	if(sw = '1') then
		nx_state <= wait1_1;
	end if;
	
when wait1_1 =>
	if(sw = '0') then
		nx_state <= zero;
	else
		if(m_tick = '1') then
			nx_state <= wait1_2;
		end if;
	end if;

when wait1_2 =>
	if(sw = '0') then
		nx_state <= zero;
	else
		if(m_tick = '1') then
			nx_state <= wait1_3;
		end if;
	end if;

when wait1_3 =>
	if(sw = '0') then
		nx_state <= zero;
	else
		if(m_tick = '1') then
			nx_state <= one;
		end if;
	end if;

when one =>
	db <= '1';
	if(sw = '0') then
		nx_state <= wait0_1;
	end if;

when wait0_1 =>
	db <= '1';
	if(sw = '1') then
		nx_state <= one;
	else
		if(m_tick = '1') then
			nx_state <= wait0_2;
		end if;
	end if;
	
when wait0_2 =>
db <= '1';
	if(sw = '1') then
		nx_state <= one;
	else
		if(m_tick = '1') then
			nx_state <= wait0_3;
		end if;
	end if;
	
when wait0_3 =>
	db <= '1';
	if(sw = '1') then
		nx_state <= one;
	else
		if(m_tick = '1') then
			nx_state <= zero;
		end if;
	end if;
end case;
end process;		
end beh;
		
