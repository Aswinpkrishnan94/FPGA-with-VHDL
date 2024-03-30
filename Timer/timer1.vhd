library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer1 is
generic(
			fclk : integer := 5		-- clk frequency in Hz
		 );
port(
		clk, rst, run    	: in std_logic;
		dig1, dig2, dig3	: out std_logic_vector(7 downto 0)
	 );
end entity;

architecture beh of timer1 is
signal oneHz_clk	: std_logic;
signal seconds1   : integer range 0 to 10;
signal seconds2 	: integer range 0 to 6;
signal minutes  	: integer range 0 to 10;
begin

-- 1 Hz Clock Generation
process(clk)
variable count : integer range 0 to fclk;
begin

if(clk='1' and clk'EVENT) then
	count := count+1;
	if(count=fclk/2) then
		oneHz_clk <= '1';
	elsif(count=fclk) then
		oneHz_clk <= '0';
		count :=0;
	end if;
end if;
end process;

-- BCD Counters
process(oneHz_clk, rst, run)
variable count1, count3 : integer range 0 to 10 := 0;
variable count2 : integer range 0 to 6 := 0;

begin

if(rst = '1') then
count1 := 0;
count2 := 0;
count3 := 0;

elsif(oneHz_clk='1' and oneHz_clk'EVENT) then
	
if(run = '1') then	
	count1 := count1 + 1;
	if(count1 = 10) then
		count2 := count2 + 1;
		count1 := 0;
		if(count2 = 6) then
			count3 := count3 + 1;
			count2 := 0;
			if(count3 = 10) then
				count3 := 0;
			end if;
		end if;
	end if;
end if;
end if;

seconds1 <= count1;
seconds2 <= count2;
minutes  <= count3;

end process;

-- BCD TO SSD
process(seconds1, seconds2, minutes)
begin

case seconds1 is
	when 0 =>	
	dig1 <= "11111100";
	when 1 =>	
	dig1 <= "01100000";
	when 2 =>	
	dig1 <= "11011010";
	when 3 =>	
	dig1 <= "11110010";
	when 4 =>	
	dig1 <= "01100110";
	when 5 =>	
	dig1 <= "10110110";
	when 6 =>	
	dig1 <= "10111110";
	when 7 =>	
	dig1 <= "11100000";
	when 8 =>	
	dig1 <= "11111110";
	when 9 =>	
	dig1 <= "11110110";
	when others => NULL;
end case;

case seconds2 is
	when 0 =>	
	dig2 <= "11111100";
	when 1 =>	
	dig2 <= "01100000";
	when 2 =>	
	dig2 <= "11011010";
	when 3 =>	
	dig2 <= "11110010";
	when 4 =>	
	dig2 <= "01100110";
	when 5 =>	
	dig2 <= "10110110";
	when others => NULL;
end case;

case minutes is
	when 0 =>	
	dig3 <= "11111101";
	when 1 =>	
	dig3 <= "01100001";
	when 2 =>	
	dig3 <= "11011011";
	when 3 =>	
	dig3 <= "11110011";
	when 4 =>	
	dig3 <= "01100111";
	when 5 =>	
	dig3 <= "10110111";
	when 6 =>	
	dig3 <= "10111111";
	when 7 =>	
	dig3 <= "11100001";
	when 8 =>	
	dig3 <= "11111111";
	when 9 =>	
	dig3 <= "11110111";
	when others => NULL;
end case;	
end process;	
end beh;
