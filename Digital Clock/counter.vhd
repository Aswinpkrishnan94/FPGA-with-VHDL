library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
port(
		clk, rst												: in std_logic;
		sec1, sec2, min1, min2							: out integer range 0 to 9;
		hour1													: out integer range 0 to 9;
		hour2													: out integer range 0 to 2
	  );
end entity;

architecture beh of counter is
signal s1,s2,m1,m2: integer range 0 to 9 := 0;
signal h1, h2 : integer range 0 to 2 := 0;

begin

process(clk ,rst)
begin

if(rst = '1') then
	s1 <= 0;
	s2 <= 0;
	m1 <= 0;
	m2 <= 0;
	h1 <= 0;
	h2 <= 0;

elsif rising_edge(clk) then
	s1 <= s1 + 1;
	if(s1 > 9) then
		s2 <= s2 + 1;
		s1 <= 0;
		if(s2 > 5) then
			m1 <= m1 + 1;
			s2 <= 0;
			if(m1 > 9 ) then
				m2 <= m2 + 1;
				m1 <= 0;
				if(m2 > 5 ) then
					h1 <= h1 + 1;
					m2 <= 0;
					if(h1 > 9) then
						h2 <= h2 + 1;
						h1 <= 0;
						if(h2 > 2 and h1 > 4) then
							h1 <= 0;
							h2 <= 0;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;

end process;
sec1 <= s1;
sec2 <= s2;
min1 <= m1;
min2 <= m2;
hour1 <= h1;
hour2 <= h2;
end beh;
