library ieee;
use ieee.std_logic_1164.all;

entity genparitydetector is
generic(
			n : integer := 8
		  );
port(
		input	: in bit_vector(n-1 downto 0);
		output : out bit
	);
end entity;

architecture beh of genparitydetector is
begin

process(input)
variable temp : bit;
begin 

temp := '0';
for i in input'range loop
temp := temp xor input(i);
end loop;

output <= temp;
end process;
end beh;