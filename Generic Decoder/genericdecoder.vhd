library ieee;
use ieee.std_logic_1164.all;

entity genericdecoder is
generic(
			N	: integer := 4;
			M	: integer := 2
		 );
port(
		ena	: in std_logic;
		sel	: in std_logic_vector(M-1 downto 0);
		x		: out std_logic_vector(N-1 downto 0)
	 );
end entity;

architecture beh of genericdecoder is
begin

process(sel,ena)
begin

if(ena = '0') then
x <= "1111";

elsif(ena = '1') then
case sel is

when "00" =>
x <= "1110";

when "01" =>
x <= "1101";

when "10" =>
x <= "1011";

when "11" =>
x <= "0111";

when others =>
x <= "ZZZZ";

end case;

else
x <= "ZZZZ";

end if;

end process;
end beh;
