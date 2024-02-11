library ieee;
use ieee.std_logic_1164.all;

entity btog is
generic(
			n : integer := 4
		 );
port(
		bin : in std_logic_vector(n-1 downto 0);
		gray: out std_logic_vector(n-1 downto 0)
	 );
end entity;

architecture  beh of btog is
begin

gray(n-1) <= bin(n-1);
gray(n-2 downto 0) <= bin(n-2 downto 0) xor bin(n-1 downto 1);

end beh;
