library ieee;
use ieee.std_logic_1164.all;

entity genparitygenerator is
generic(
			n : integer := 8
		  );
port(
		input	: in bit_vector(n-2 downto 0);
		output : out bit_vector(n-1 downto 0)
	);
end entity;

architecture beh of genparitygenerator is
begin

process(input)
variable temp1: bit;
variable temp2: bit_vector(output'range);
begin

temp1:= '0';
for i in input'range loop
temp1 := temp1 xor input(i);
temp2(i) := input(i);
end loop;
temp2(output'high) := temp1;
output <= temp2;

end process;
end beh;