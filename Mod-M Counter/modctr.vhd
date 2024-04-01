library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modctr is
generic(
			M : integer := 10;	-- mod-m
			N : integer := 4		-- number of bits
		  );
port(
		clk, rst	: in std_logic;
		max_tick : out std_logic;
		q			: out std_logic_vector(N-1 downto 0)
	  );
end entity;

architecture beh of modctr is

signal r_next, r_reg 	: unsigned(N-1 downto 0);

begin

--register
process(clk ,rst)
begin

if(rst = '1') then
	r_reg <= (others =>'0');
elsif(clk = '1' and clk'EVENT) then
	r_reg <= r_next;
end if;
end process;

--next state logic
r_next <= (others => '0') when r_reg <= (M-1) else
			r_reg + 1;

q <= std_logic_vector(r_reg);
max_tick <= '1' when r_reg = 2**N-1 else '0';

end beh;
