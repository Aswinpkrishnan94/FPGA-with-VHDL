library ieee;
use ieee.std_logic_1164.all;

entity mux21 is
port(
		e1, e2   : in  std_logic_vector(3 downto 0);
		sel		: in  std_logic;
		s			: out std_logic_vector(3 downto 0)
	  );
end entity;

architecture beh of mux21 is
begin

with sel select
	s <= e1	when '0',
		  e2  when others;
end beh;