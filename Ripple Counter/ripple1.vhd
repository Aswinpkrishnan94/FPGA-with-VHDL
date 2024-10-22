library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ripple1 is
generic(
			n : integer := 4
		 );
port(
		clk ,rst : in std_logic;
		q			: out std_logic_vector(n-1 downto 0)
	 );
end entity;

architecture beh of ripple1 is

signal counter : integer := 0;

begin

process(clk ,rst)
begin

if rising_edge(clk) then
	if(rst = '1') then
		counter <= 0;
	else
		counter <= counter + 1;
		if(counter = 15) then
			counter <= 0;
		end if;
	end if;
end if;
end process;
q <= std_logic_vector(to_unsigned(counter, 4));
end  beh;
