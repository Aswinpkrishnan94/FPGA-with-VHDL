library ieee;
use ieee.std_logic_1164.all;

entity genencoder is
generic(
			n	: integer := 8;
			m	: integer := 3
		  );
port(
			x	: in std_logic_vector(n-1 downto 0);
			y	: out std_logic_vector(m-1 downto 0)
	 );
end entity;

architecture beh of genencoder is
begin

y	<= "000" when x = "00000001" else
		"001" when x = "00000010" else
		"010" when x = "00000100" else
		"011" when x = "00001000" else
		"100" when x = "00010000" else
		"101" when x = "00100000" else
		"110" when x = "01000000" else
		"111" when x = "10000000" else
		"ZZZ";
end beh;
