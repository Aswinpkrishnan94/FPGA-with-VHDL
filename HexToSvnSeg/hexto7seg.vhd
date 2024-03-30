library ieee;
use ieee.std_logic_1164.all;

entity hexto7seg is
generic(
			N : integer := 4
		  );
port(
		hex    : in std_logic_vector(3 downto 0);
		dp		 : in std_logic;
		sseg	 : out std_logic_vector(7 downto 0)
	);
end entity;

architecture beh of hexto7seg is
begin

with hex select
sseg(6 downto 0) <= "0000001" when "0000",    -- digit 0
							      "1001111" when "0001",    -- digit 1
							      "0010010" when "0010",    -- digit 2
							      "0000110" when "0011",    -- digit 3
							      "1001100" when "0100",    -- digit 4
							      "0100100" when "0101",    -- digit 5
							      "0100000" when "0110",    -- digit 6
							      "0001111" when "0111",    -- digit 7
							      "0000000" when "1000",    -- digit 8
							      "0000100" when "1001",    -- digit 9
							      "0000010" when "1010",    -- digit 10 (A)
							      "1100000" when "1011",    -- digit 11 (B)
							      "0110001" when "1100",    -- digit 12 (C)
							      "1000010" when "1101",    -- digit 13 (D)
							      "0110000" when "1110",    -- digit 14 (E)
							      "0111000" when others;    -- digit 15 (F)

sseg(7) <= dp;

end beh;
							 
						 
