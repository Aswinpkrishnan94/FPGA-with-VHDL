library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparatorNbit is
generic(
		n : integer := 8
		);
port(
		a, b : in std_logic_vector(n-1 downto 0);
		eq	  : out std_logic
	 );
end entity;

architecture beh of comparatorNbit is
begin

eq <= '1' when a=b else
		'0';
end beh;
