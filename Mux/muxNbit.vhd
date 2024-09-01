library ieee;
use ieee.std_logic_1164.all;

entity muxNbit is
generic(
			n : integer := 8;
			m : integer := 2
		 );
port(
		a, b : in std_logic_vector(n-1 downto 0);
		sel  : in std_logic_vector (m-1 downto 0);
		c	  : out std_logic_vector(n-1 downto 0)
	 );
end entity;

architecture beh of muxNbit is
begin

with sel(m-1 downto 0) select
	c <= (others => '0') when "00",
			a when "01",
			b when "10",
			(others => 'Z') when others;
			
end beh;
