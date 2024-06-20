library ieee;
use ieee.std_logic_1164.all;

entity clkdiv2 is
port(
		clk_in, rst		: in std_logic;
		clk_out			: out std_logic
	  );
end entity;

architecture beh of clkdiv2 is
constant timer : integer := 50000000;
signal clk : std_logic := '0';
signal count : integer := 0;
begin

process(clk_in, rst)
begin

if(rst = '0') then
	count <= 0;
	clk <= '0';
elsif(clk_in = '1' and clk_in'EVENT) then
	if(count = timer)then
		clk <= not clk;
		count <= 0;
	else
		count <= count + 1;
	end if;
end if;
clk_out <= clk;
end process;
end beh;
