library ieee;
use ieee.std_logic_1164.all;

entity siso is
generic(
			n : integer := 4
		 );
port(
		clk, rst 	: in std_logic;
		d				: in std_logic;
		q				: out std_logic
	 );
end entity;

architecture beh of siso is
signal temp : std_logic_vector(n-1 downto 0);
begin

process(clk, rst, d) 
begin

if(clk = '1' and clk'EVENT) then
 if(rst = '0') then
	temp <= (others => '0');
 else
	temp <= d & temp(n-1 downto 1);
 end if;
end if;
end process;
q <= temp(3);
end beh;