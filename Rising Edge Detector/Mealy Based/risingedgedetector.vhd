library ieee;
use ieee.std_logic_1164.all;

entity risingedgedetector is
port(
		clk, rst, level	: in std_logic;
		tick  				: out std_logic
	);
end entity;

architecture beh of risingedgedetector is
TYPE state IS(zero, edge, one);
signal pr_state, nx_state	: state;

begin

process(clk, rst)
begin

if(rst = '1') then
pr_state <= zero;

elsif(clk='1' and clk'EVENT) then
pr_state <= nx_state;

end if;
end process;

process(pr_state, level)
begin

nx_state <= pr_state;
tick <= '0';

case pr_state is

when zero =>
if(level = '1') then
  tick<= '1';    
	nx_state <= one;
end if;

when one =>
if(level = '0') then
	nx_state <= zero;
end if;

end case;
end process;
end beh;	
