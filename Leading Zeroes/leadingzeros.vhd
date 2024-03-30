library ieee;
use ieee.std_logic_1164.all;

entity leadingzeros is
generic(
			n	: integer := 8
		 );
port(
		inp	: in std_logic_vector(n-1 downto 0);
		op		: out integer range 0 to n
	  );
end entity;

architecture beh of leadingzeros is
begin

process(inp)
variable count : integer := 0;
begin

  -- Iterate through the input vector until first occurence of '1'. If found, exit the loop else count the zeros leading to first '1'
l1: for i in 0 to n-1 loop
		if(inp(i)='1') then
			EXIT;
		else
			count := count+1;
		end if;
	 end loop l1;
op <= count;
end process;
end beh;
