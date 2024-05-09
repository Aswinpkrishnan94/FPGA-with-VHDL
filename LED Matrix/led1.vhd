library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led1 is
port(
		clk	: in std_logic;
		rows	: out std_logic_vector(7 downto 0);
		cols	: out std_logic_vector(7 downto 0)
	  );
end entity;

architecture beh of led1 is

constant CLK_FREQ :	integer := 50e6;
signal clk_ctr : integer := 0;
signal row_ctr	: unsigned(2 downto 0);

begin

sim_clk_process: process(clk)
begin

if rising_edge(clk) then
	if(clk_ctr = CLK_FREQ - 1) then
		clk_ctr <= 0;
		row_ctr <= row_ctr + 1;
	else
			clk_ctr <= clk_ctr +  1;
	end if;
end if;
end process;

sim_scan : process(row_ctr)
begin

cols(3) <= '1';

rows <= (others => '0');
rows(to_integer(row_ctr)) <= '1';

end process;
end beh;
