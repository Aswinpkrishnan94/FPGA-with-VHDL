library ieee;
use ieee.std_logic_1164.all;

entity binarycounterFSM is
port(
		clk, rst	: in std_logic;
		count		: out std_logic_vector(3 downto 0)
	 );
end entity;

architecture beh of binarycounterFSM is
type state is(zero, one, two, three, four, five, six, seven, eight, nine);
signal pr_state, nx_state : state;
begin

process(clk, rst)
begin

if(rst = '1') then
pr_state <= zero;
elsif(clk='1' and clk'EVENT) then
pr_state <= nx_state;

end if;
end process;

process(pr_state)
begin

case pr_state is
when zero =>
count <= "0000";
nx_state<= one;

when one =>
count <= "0001";
nx_state<= two;

when two =>
count <= "0010";
nx_state<= three;

when three =>
count <= "0011";
nx_state<= four;

when four =>
count <= "0100";
nx_state<= five;

when five =>
count <= "0101";
nx_state<= six;

when six =>
count <= "0110";
nx_state<= seven;

when seven =>
count <= "0111";
nx_state<= eight;

when eight =>
count <= "1000";
nx_state<= nine;

when nine =>
count <= "1001";
nx_state<= zero;

end case;
end process;
end beh;
