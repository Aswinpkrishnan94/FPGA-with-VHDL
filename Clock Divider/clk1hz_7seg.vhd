library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk1hz_7seg is
port( 
	clk,reset: in std_logic;
	clock_out: out std_logic;
	dp			: in std_logic;
	sseg		: out std_logic_vector(7 downto 0)
	 );
end entity;
  
architecture beh of clk1hz_7seg is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
signal counter : integer := 0;  
begin
  
process(clk,reset)
begin

if(reset='1') then
count<=1;
counter <= 0;
tmp<='0';

elsif(clk'event and clk='1') then
count <=count+1;
if (count = 25000000) then
	if(counter = 9) then
		counter <= 0;
	else
		counter <= counter + 1;
	end if;
tmp <= NOT tmp;
count <= 1;
end if;
end if;
clock_out <= tmp;
end process;
 
process(counter, dp)
begin

case counter is

when 0 =>
	sseg(6 downto 0) <= "0000001";

when 1 =>
	sseg(6 downto 0) <= "1001111";

when 2 =>
	sseg(6 downto 0) <= "0010010";
	
when 3 =>
	sseg(6 downto 0) <= "0000110";
	
when 4 =>
	sseg(6 downto 0) <= "1001100";
	
when 5 =>
	sseg(6 downto 0) <= "0100100";
	
when 6 =>
	sseg(6 downto 0) <= "0100000";
	
when 7 =>
	sseg(6 downto 0) <= "0001111";

when 8 =>
	sseg(6 downto 0) <= "0000000";
	
when 9 =>
	sseg(6 downto 0) <= "0000100";

when others =>
	sseg(6 downto 0) <= "1111111";
	
end case;

sseg(7) <= dp;
	
end process;
end beh;
