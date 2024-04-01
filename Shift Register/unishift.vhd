library ieee;
use ieee.std_logic_1164.all;

entity unishift is
generic(
			N : integer := 8
		 );
port(
		clk, rst	: in std_logic;
		ctrl		: in std_logic_vector(1 downto 0);
		d			: in std_logic_vector(N-1 downto 0);
		q			: out std_logic_vector(N-1 downto 0)
	  );
end entity;

architecture beh of unishift is

signal r_reg, r_next	: std_logic_vector(N-1 downto 0);

begin

-- register
process(clk, rst)
begin

if(rst = '1') then
	r_reg <= (others =>'0');
elsif(clk = '1' and clk'EVENT) then
	r_reg <= r_next;
end if;
end process;

--next state logic
with ctrl select
	r_next <= r_reg when "00",								-- no operation
				 r_reg(N-2 downto 0)&d(0) when "01",	-- shift left
				 d(N-1)&r_reg(N-1 downto 1) when "10", -- shift right
				 d when others;								-- load

q <= r_reg;
end beh;

