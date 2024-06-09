library ieee;
use ieee.std_logic_1164.all;

entity stringdetector is
port(
		clk ,rst : in std_logic;
		d			: in std_logic;
		q			: out std_logic
	 );
end entity;

architecture beh of stringdetector is

type state is (zero, one, two, three);
signal pr_state, nx_state : state;

begin

process(clk ,rst)
begin

if(rst = '1') then
	pr_state <= zero;
	
elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
	
end if;
end process;

process(pr_state, d)
begin

case pr_state is

when zero =>
	q <= '0';
	if(d = '1') then
		nx_state <= one;
	else
		nx_state <= zero;
		
	end if;
	
when one =>
	q <= '0';
	if(d = '1') then
		nx_state <= two;
	else
		nx_state <= zero;
	end if;
	
when two =>
	q <= '0';
	if(d = '1') then
		nx_state <= three;
		q <= '1';
	else
		nx_state <= zero;
	end if;
	
when three =>
	q <= '1';
	if(d = '0') then
		nx_state <= zero;
	else
		nx_state <= three;
	end if;
	
end case;
end process;

end beh;
