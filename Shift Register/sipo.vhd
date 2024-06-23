library ieee;
use ieee.std_logic_1164.all;

entity sipo is
generic(
			n : integer := 4
		 );
port(
		clk, rst 	: in std_logic;
		d				: in std_logic;
		q				: out std_logic_vector(n-1 downto 0)
	 );
end entity;

architecture beh of sipo is
signal temp : std_logic_vector(3 downto 0);
begin

process(clk, rst, d) 
begin

if(clk = '1' and clk'EVENT) then
 if(rst = '0') then
	temp <= (others => '0');
 else
	temp(3 downto 1) <= temp(2 downto 0);
	temp(0) <= d;
 end if;
end if;
end process;
q <= temp;
end beh;