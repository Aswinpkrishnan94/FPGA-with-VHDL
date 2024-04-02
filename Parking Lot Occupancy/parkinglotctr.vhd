library ieee;
use ieee.std_logic_1164.all;

entity parkinglotctr is
port(
		clk, rst					: in std_logic;
		sw1, sw2					: in std_logic;
		clk_enter, clk_exit 	: out std_logic;
		leds						: out std_logic_vector(7 downto 0)
	 );
end entity;

architecture beh of parkinglotctr is

type state is (both_open, entering, exiting, both_closed);		-- state variables declaration
signal pr_state, nx_state : state;

signal clkenter_evnt, clkexit_evnt	: std_logic;
signal debounced_a, debounced_b 	: std_logic;
signal cnt	: integer := 0;
signal cnt_en : std_logic := '0';


constant CLK_FREQ	: integer := 50000000; -- 50 MHz clock

begin

--counter process
process(clk, rst)
begin

if(rst = '1') then
	cnt <= 0;
	
elsif(clk = '1' and clk'EVENT) then
	if(cnt_en = '1') then
		if(pr_state = entering) then
			cnt <= cnt + 1;
		elsif(pr_state = exiting) then
			cnt <= cnt - 1;
		end if;
	end if;
end if;
end process;

--led multiplexing
process(clk)
begin

if(clk = '1' and clk'EVENT) then
   case cnt is
       when 0 =>
               leds <= "10000000";
       when 1 =>
               leds <= "11110011";
       when 2 =>
               leds <= "01001000";
       when 3 =>
               leds <= "01100000";
       when 4 =>
               leds <= "00110011";
       when 5 =>
               leds <= "00100100";
       when 6 =>
               leds <= "00000100";
       when 7 =>
               leds <= "11110000";
       when 8 =>
               leds <= "00000000";
       when 9 =>
               leds <= "00110000";
       when others =>
               leds <= "11111111";
	end case;
end if;
end process;

--Clock Assert/Deassert while entering and exiting
process(clk)
begin

if(clk = '1' and clk'EVENT) then
		clk_enter <= clkenter_evnt;
		clk_exit  <= clkexit_evnt;
end if;
end process;

--FSM					
process(clk, rst, pr_state, debounced_a, debounced_b, sw1, sw2)
begin

if(rst = '1') then
	pr_state <= both_open;

pr_state <= nx_state;

elsif(clk = '1' and clk'EVENT) then

	case pr_state is
		when both_open =>
			if(sw1 = '1' and sw2 = '0') then
				clkenter_evnt <= '1';
				pr_state <= entering;
				cnt_en <= '1';
			elsif(sw1 = '0' and sw2 = '1') then
				pr_state <= exiting;
				clkexit_evnt <= '1';
				cnt_en <= '1';
			end if;
			
		when entering =>
			if(sw2 = '1') then
				pr_state <= both_closed;
				cnt_en <= '0';
			end if;
		
		when exiting =>
			if(sw1 = '1') then
				pr_state <= both_closed;
				cnt_en <= '0';
			end if;
		
		when both_closed =>
			if(sw1 = '0' and sw2 = '0') then
				pr_state <= both_open;
				clkenter_evnt <= '0';
				clkexit_evnt <= '0';
			end if;
			
	end case;
end if;
end process;
end beh;
