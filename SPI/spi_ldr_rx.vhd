library ieee;
use ieee.std_logic_1164.all;

entity spi_ldr_rx is
generic(
			n : integer := 8
		 );
port(
		clk, miso, get		 : in std_logic;
		data					 : out std_logic_Vector(n-1 downto 0);
		sck, ss, busy, ready : out std_logic
	 );
end entity;

architecture beh of spi_ldr_rx is

type state_machine is (rdy, rx, stop);
signal state : state_machine;

signal s_ss : std_logic:= '1';
signal s_sck, s_busy, s_ready : std_logic := '0';
signal data_temp : std_logic_vector(n-1 downto 0);
signal clk_div : integer := 0;
signal index : integer := 0;

begin

process(clk)
begin

if rising_edge(clk) then
	if(clk_div = 12) then
		clk_div <= 0;
		s_sck <= not s_sck;
	else
		clk_div <= clk_div + 1;
	end if;
end if;
end process;
sck <= s_sck;

process(s_sck, miso, get)
begin

if rising_edge(s_sck) then
	case state is
		when rdy =>
			s_busy <= '0';
			s_ss <= '1';
			if(get = '1') then
				s_busy <= '1';
				s_ss <= '0';
				s_ready <= '0';
				data_temp <= (others => '0');
				state <= rx;
			end if;
			
		when rx =>
			if(index = 0) then
				state <= stop;
			else
				data_temp(index) <= miso;
				index <= index - 1;
			end if;
			
		when stop =>
			s_busy <= '0';
			s_ss <= '1';
			state <= rdy;
			s_ready <= '1';
	end case;
end if;
end process;
busy <= s_busy;
ss <= s_ss;
ready <= s_ready;
data <= data_temp;
end beh;
