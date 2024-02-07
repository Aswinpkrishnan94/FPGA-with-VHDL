library ieee;
use ieee.std_logic_1164.all;

entity rom is
port(
		address : in integer range 0 to 7;
		data	  : out bit_vector(3 downto 0)
	 );
end entity;

architecture beh of rom is
type rom is array(0 to 7) of bit_vector(3 downto 0);
constant my_rom : rom	:= ("1111", "1110", "1101", "1100",
									 "1011", "1010", "1001", "1000");

begin

data <= my_rom(address);

end beh;