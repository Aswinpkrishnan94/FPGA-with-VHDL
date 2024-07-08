library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sseg is
port(
		bcd : in std_logic_vector(3 downto 0);
		sseg: out std_logic_vector(6 downto 0)
	  );
end entity;

architecture beh of sseg is
begin

process(bcd)
begin

case bcd is

when "0000" =>
	sseg <= "1000000";

when "0001" =>
	sseg <= "1111001";

when "0010" =>
	sseg <= "0100100";
	
when "0011" =>
	sseg <= "0110000";
	
when "0100" =>
	sseg <= "0011001";
	
when "0101" =>
	sseg <= "0010010";
	
when "0110" =>
	sseg <= "0000010";
	
when "0111" =>
	sseg <= "1111000";

when "1000" =>
	sseg <= "0000000";
	
when "1001" =>
	sseg <= "0010000";
	
when "1010" =>
	sseg <= "0001000";

when "1011" =>
	sseg <= "0000011";
	
when "1100" =>
	sseg <= "1000110";
	
when "1101" =>
	sseg <= "0100001";

when "1110" =>
	sseg <= "0000110";
	
when "1111" =>
	sseg <= "0001110";

when others =>
	sseg <= "1111111";

end case;
end process;
end beh;
