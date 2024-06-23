library ieee;
use ieee.std_logic_1164.all;

entity pipo is
port(
		clk, rst 	: in std_logic;
		d				: in std_logic;
		q				: out std_logic
	 );
end entity;

architecture beh of pipo is
signal temp : std_logic_vector(3 downto 0);
begin

process(clk, rst, d) 
begin

if(rst = '0') then
	q <= '0';
	
elsif(clk = '1' and clk'EVENT) then
	q <= d;

end if;
end process;
end beh;