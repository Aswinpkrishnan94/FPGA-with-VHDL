library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity barrel_shifter is
generic(
			n : integer := 8
		 );
port(
		input  : in std_logic_vector(n-1 downto 0);
		sel	 : in std_logic;
		shift  : in std_logic_vector(n-1 downto 0);
		output : out std_logic_vector(n-1 downto 0)
	 );
end entity;

architecture beh of barrel_shifter is
signal left_shift, right_shift : std_logic_vector(n-1 downto 0);
begin

left_shift <= std_logic_vector(shift_left(unsigned(input), to_integer(unsigned(shift))));
right_shift <= std_logic_vector(shift_right(unsigned(input), to_integer(unsigned(shift))));

with sel select
	output <= left_shift when '0',
				 right_shift when others;
end beh;
