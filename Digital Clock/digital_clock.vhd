ibrary ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity digital_clock is
port(
		clk, rst		: in std_logic;
		sseg1, sseg2, sseg3, sseg4, sseg5, sseg6 : out std_logic_vector(6 downto 0)
	  );
end entity;

architecture beh of digital_clock is

signal s1_bcd, s2_bcd, m1_bcd, m2_bcd, h1_bcd, h2_bcd : std_logic_vector(3 downto 0);

signal clk_s	: std_logic;
signal s1,s2	: integer := 0;
signal m1, m2  : integer := 0;
signal h1, h2  : integer := 0;

component clk_div
port(
		clk_in, rst	: in std_logic;
		clk_out		: out std_logic
	  );
end component;

component counter is
port(
		clk, rst												: in std_logic;
		sec1, sec2, min1, min2, hour1					: out integer range 0 to 9;
		hour2													: out integer range 0 to 2
	  );
end component;

component sseg 
port(
		bcd : in std_logic_vector(3 downto 0);
		sseg: out std_logic_vector(6 downto 0)
	 );
end component;

begin

    uut1: clk_div port map(clk, rst, clk_s);
    uut2: counter port map(clk_s, rst, s1, s2, m1, m2, h1, h2);
	 
    -- Convert integers to std_logic_vector
    s1_bcd <= std_logic_vector(to_unsigned(s1, 4));
    s2_bcd <= std_logic_vector(to_unsigned(s2, 4));
    m1_bcd <= std_logic_vector(to_unsigned(m1, 4));
    m2_bcd <= std_logic_vector(to_unsigned(m2, 4));
    h1_bcd <= std_logic_vector(to_unsigned(h1, 4));
    h2_bcd <= std_logic_vector(to_unsigned(h2, 4));

    uut3: sseg port map(s1_bcd, sseg1);
    uut4: sseg port map(s2_bcd, sseg2);
    uut5: sseg port map(m1_bcd, sseg3);
    uut6: sseg port map(m2_bcd, sseg4);
    uut7: sseg port map(h1_bcd, sseg5);
    uut8: sseg port map(h2_bcd, sseg6);

end beh;
