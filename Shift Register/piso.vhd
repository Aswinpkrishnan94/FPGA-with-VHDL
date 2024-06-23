library ieee;
use ieee.std_logic_1164.all;

entity piso is
generic(
			n : integer := 4
		 );
port(
		clk, load, shift		 	: in std_logic;
		d								: in std_logic_vector(n-1 downto 0);
		q								: out std_logic
	 );
end entity;

architecture beh of piso is
signal temp : std_logic_vector(n-1 downto 0);
begin

process(clk, load, shift, d) 
begin

if rising_edge(clk) then
	if(load = '1') then
		temp <= d;
	elsif(shift = '1') then
			temp<= temp(n-2 downto 0) & '0';
	end if;
end if;
end process;
q <= temp(n-1);
end beh;