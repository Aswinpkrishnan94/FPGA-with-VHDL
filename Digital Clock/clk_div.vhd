library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
port(
		clk_in, rst	: in std_logic;
		clk_out		: out std_logic
	 );
end entity;

architecture beh of clk_div is

constant clock_hz: integer := 50000000;
signal counter : integer := 0;
signal clk_tmp : std_logic := '0';

begin

process(clk_in ,rst)
begin
	
if(clk_in = '1' and clk_in'EVENT) then

	if(rst = '1') then	
		counter <= 0;
		clk_tmp <= '0';
		
	elsif(counter = clock_hz/2 - 1) then
		counter <= 0;
		clk_tmp <= not clk_tmp;
		
	else
		counter <= counter + 1;
	end if;
end if;

end process;
clk_out <= clk_tmp;
end beh;
