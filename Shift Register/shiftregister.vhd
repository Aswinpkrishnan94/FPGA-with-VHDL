library ieee;
use ieee.std_logic_1164.all;

entity shiftregister is
port(	
		d, clk, rst	: in std_logic;
		q				: out std_logic
	 );
end entity;

architecture beh of shiftregister is
signal internal : std_logic_vector(3 downto 0);
begin

process(clk, rst)
begin

if(rst = '1') then
internal <= (others =>'0');

elsif(clk='1' and clk'EVENT) then
internal <= d&internal(3 downto 1);
end if;

end process;
q <= internal(0);
end beh;
