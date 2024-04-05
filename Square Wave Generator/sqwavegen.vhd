library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqwavegen is
port(
		clk, rst	: in std_logic;
		m, n		: in std_logic_vector(3 downto 0);
		q			: out std_logic
	  );
end entity;

architecture beh of sqwavegen is

constant CLK_PRD : time := 20 ns;
constant ON_TIME : time := 100 ns;
constant OFF_TIME: time := 100 ns;				
signal state : std_logic := '0';						-- state of output
signal count : natural range 0 to 15 := 0;		-- 4 bit counter

begin

process(clk, rst)
begin

if(rst = '1') then
	q <= '0';
	state <= '0';
	count <= 0;
	
elsif(clk = '1' and clk'EVENT) then
	if(state = '0') then
		if(count >= to_integer(unsigned(n))) then
			state <= '1';
			count <= 0;
		else
			count <= count + 1;
		end if;
	else
		if(count >= to_integer(unsigned(m))) then
			state <= '0';
			count <= 0;
		else
			count <= count + 1;
		end if;
	end if;
	q <= state;
end if;
end process;
end beh;
