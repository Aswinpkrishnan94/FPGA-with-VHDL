library ieee;
use ieee.std_logic_1164.all;

entity spi_ldr_tx is
generic(
			n : integer := 8
		  );
port(
		clk, send			  : in std_logic;
		data					  : in std_logic_vector(n-1 downto 0);
		sck, mosi, ss, busy : out std_logic
	 );
end entity;

architecture beh of spi_ldr_tx is

constant clock_in : integer := 50000000;
signal clk_div : integer := 0;
signal index : integer := 0;
signal s_ck	: std_logic := '0';

type state_machine is (rdy, start, tx, stop);
signal state : state_machine := rdy;

signal s_busy : std_logic := '0';
signal s_ss : std_logic := '1';
signal s_mosi : std_logic := '0';

begin

process(clk)
begin

if (clk_div = 12) then
	clk_div <= 0;
	s_ck <= not s_ck;
else
	clk_div <= clk_div + 1;
end if;
end process;
sck <= s_ck;

process(send, data, clk)
begin

if rising_edge(clk) then

	case state is

		when rdy =>
		   s_busy <= '0';
         s_ss <= '1';
			if (send = '1') then
				state <= start;
				index <= n-1;
				s_busy <= '1';
			end if;
			
		when start =>
			s_ss <= '0';
			s_mosi <= data(index);
			index <= index - 1;
			state <= tx;
	
		when tx =>
			if (index = 0) then
             state <= stop;
         else
             s_mosi <= data(index);
             index <= index - 1;
         end if;
			
		when stop =>
			s_busy <= '0';
			s_ss <= '1';
			state <= rdy;
			
		when others =>
         state <= rdy;
			
	end case;
end if;
end process;
ss <= s_ss;
mosi <= s_mosi;
busy <= s_busy;
end beh;
