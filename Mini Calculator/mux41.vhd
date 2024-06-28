library ieee;
use ieee.std_logic_1164.all;

entity mux41 is
port(
		e1, e2, e3, e4   : in  std_logic_vector(3 downto 0);
		sel				  : in  std_logic_vector(1 downto 0);
		s					  : out std_logic_vector(3 downto 0)
	  );
end entity;

architecture beh of mux41 is
begin

with sel select
	s <= e1	when "00",
		  e2  when "01",
		  e3  when "10",
		  e4  when others;
end beh;