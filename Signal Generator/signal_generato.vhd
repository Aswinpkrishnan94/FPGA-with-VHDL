library ieee;
use ieee.std_logic_1164.all;

entity signal_generator is
port(
		clk, rst	: in std_logic;
		go, stop : in std_logic;
		up, down : out std_logic
	 );
end entity;

architecture beh of signal_generator is

type state is (A, WAIT_UP, B,  WAIT_DOWN);
signal pr_state, nx_state:state;

signal delay : integer := 10000;

begin

process(clk, rst)
begin

if(rst = '1') then
	pr_state <= A;
elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;

end if;
end process;

process(pr_state)
begin

nx_state <= pr_state;
up <= '0';
down <= '0';

case pr_state is

when A =>
	if(go = '1') then
		nx_state <= WAIT_UP;
	elsif(stop = '1') then
		nx_state <= A;
	end if;
	
when WAIT_UP =>
	if(delay>0) then
		delay <= delay - 1;
	else
		nx_state <= B;
	end if;
	
when B =>
	delay <= 10000;
	if(go = '0') then
		up <= '0';
		nx_state <= WAIT_DOWN;
	else
		nx_state <= A;
	end if;
	
when WAIT_DOWN =>
	if(delay>0) then
		delay <= delay - 1;
	else
		down <= '1';
		nx_state <= A;
	end if;

end case;

end process;

end beh;
		
	
