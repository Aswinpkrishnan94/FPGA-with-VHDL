library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led2 is
port(
		clk	: in std_logic;
		rows	: out std_logic_vector(7 downto 0);
		cols	: out std_logic_vector(7 downto 0)
	  );
end entity;

architecture beh of led2 is

constant CLK_FREQ :	integer := 50e6;
constant SCAN_FREQ : integer := 400;

signal clk_ctr : integer := 0;
signal row_ctr	: unsigned(2 downto 0);

type matrix_type is array(0 to 7) of std_logic_vector(7 downto 0);
constant matrix:matrix_type := (('1', '1', '1', '1', '1', '1', '1', '0'),						-- Character F
										  ('0', '1', '1', '0', '0', '0', '1', '0'),
										  ('0', '1', '1', '0', '1', '0', '0', '0'),
										  ('0', '1', '1', '1', '1', '0', '0', '0'),
										  ('0', '1', '1', '0', '1', '0', '0', '0'),
										  ('0', '1', '1', '0', '0', '0', '0', '0'),
										  ('1', '1', '1', '1', '0', '0', '0', '0'),
										  ('0', '0', '0', '0', '0', '0', '0', '0'));


begin

sim_clk_process: process(clk)
begin

if rising_edge(clk) then
	if(clk_ctr = (CLK_FREQ/(SCAN_FREQ*8)) - 1) then			-- 8 rows. to run faster to display the character
		clk_ctr <= 0;
		row_ctr <= row_ctr + 1;
	else
			clk_ctr <= clk_ctr +  1;
	end if;
end if;
end process;

sim_scan : process(row_ctr)
begin

cols <= matrix(to_integer(row_ctr));
rows <= (others => '0');
rows(to_integer(row_ctr)) <= '1';

end process;
end beh;
