library ieee;
use ieee.std_logic_1164.all;

entity freqdiv is
generic(
			n : integer := 2
		 );
port(
		clk_in	: in std_logic;
		clk_out	: out std_logic
	 );
end entity;

architecture beh of freqdiv is
begin

process(clk_in)
variable count : integer := 0;
begin

if(clk_in = '1' and clk_in'EVENT) then
	count := count+1;
	if(count = n/2) then
		clk_out <= '1';
	elsif(count = n) then
		clk_out <='0';
		count := 0;
	end if;
end if;
end process;
end beh;
