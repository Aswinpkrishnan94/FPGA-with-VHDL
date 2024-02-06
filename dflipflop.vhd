LIBRARY ieee;
USE IEEE.std_logic_1164.all;

entity dflipflop is
port(
		clk, rst		: in std_logic;
		d				: in std_logic;
		q				: out std_logic
	 );
end entity;

architecture beh of dflipflop is
begin

process(clk, rst)
begin

if(rst = '1') then
q <= '0';

elsif(clk = '1' AND clk'EVENT) then
q <= d;

end if;
end process;
end beh;