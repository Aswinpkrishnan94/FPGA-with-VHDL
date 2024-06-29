library ieee;
use ieee.std_logic_1164.all;

entity registers is
port(
		clk, ce : in std_logic;
		d		  : in std_logic_vector(3 downto 0);
		q		  : out std_logic_vector(3 downto 0)
	  );
end entity;

architecture beh of registers is
begin

process(clk ,ce)
begin

if(ce = '0') then
	q <= (others => 'X');
	
elsif (rising_edge(clk) and ce = '1') then
	q <= d;
end if;

end process;
end beh;