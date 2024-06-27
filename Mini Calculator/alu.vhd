library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
port(
		a, b 								: in unsigned(3 downto 0);
		opcode							: in std_logic_vector(2 downto 0);
		res								: out std_logic_vector(3 downto 0);
		A_SUP_B, A_INF_B, A_EQU_B  : out std_logic;
		OVF, ZERO, NEG					: out std_logic
	  );
end entity;

architecture beh of alu is
signal s : unsigned(3 downto 0);
begin

with opcode(2 downto 0) select
	s	 	<= a and b  when "000",
				a nand b when "001",
				a or b	when "010",
				a nor b  when "011",
				a xor b	when "100",
				not a		when "101",
				a + b		when "110",
				a - b		when others;
			
process(a, b)
begin

if(a < b) then
		A_INF_B <= '1';
		A_SUP_B <= '0';
		A_EQU_B <= '0';
		
elsif(a > b) then
		A_INF_B <= '0';
		A_SUP_B <= '1';
		A_EQU_B <= '0';
		
else
		A_INF_B <= '0';
		A_SUP_B <= '0';
		A_EQU_B <= '1';
		
end if;
end process;

process(s)
begin

OVF <= '0';
ZERO <= '0';
NEG <= '0';

if(s = 0) then
	ZERO <= '1';
else
	ZERO <= '0';
end if;

if(s < 0) then
	NEG <= '1';
else
	NEG <= '0';
end if;

if(S > "1111") then
	OVF <= '1';
else
	OVF <= '0';
end if;
end process;
res <= std_logic_vector(s);
end beh;
