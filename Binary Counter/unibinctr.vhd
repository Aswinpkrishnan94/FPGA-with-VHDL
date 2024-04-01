library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unibinctr is
generic(
			N : integer := 8
		  );
port(
		clk, rst					: in std_logic;
		sync_clr, load, en,up	: in std_logic;
		d							: in std_logic_vector(N-1 downto 0);
		max_tick, min_tick	: out std_logic;
		q							: out std_logic_vector(N-1 downto 0)
	  );
end entity;

architecture beh of unibinctr is

signal r_reg, r_next	: unsigned(N-1 downto 0);

begin

-- register
process(clk, rst)
begin

if(rst = '1') then
	r_reg <= (others=>'0');
elsif(clk = '1' and clk'EVENT) then
	r_reg <= r_next;
end if;
end process;

-- next state logic
r_next <= (others => '0') when sync_clr = '1' else
			 unsigned(d)	when load = '1' else
			 r_reg + 1 when en = '1' and up = '1' else
			 r_reg - 1 when en = '1' and up = '0' else
			 r_reg;
			 


q <= std_logic_vector(r_reg);
max_tick <= '1' when r_reg = 2**N-1 else '0';
min_tick <= '1' when r_reg = 0 else '0';

end beh;
