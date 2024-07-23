library ieee;
use ieee.std_logic_1164.all;

entity spi_fol_rx is
generic(
			n : integer := 8
		 );
port(
		sck,ss,mosi 		 : in std_logic;
		data					 : out std_logic_Vector(n-1 downto 0);
		busy, ready 	    : out std_logic
	 );
end entity;

architecture beh of spi_fol_rx is

type state_machine is (rdy, rx, stop);
signal state : state_machine := rdy;

signal data_temp : std_logic_vector(n-1 downto 0);
signal index : integer := n - 1;
signal s_busy, s_ready : std_logic;

begin

process(sck)
begin

if rising_edge(sck) then
	case state is
		when rdy =>
			s_busy <= '0';
			s_ready <= '0';
			if(ss = '0') then
				s_busy <= '1';
				data_temp(index) <= mosi;
				index <= index - 1;
			end if;
			
		when rx =>
			if(index = 0) then
				state <= stop;
			else
				data_temp(index) <= mosi;
				index <= index - 1;
			end if;
			
		when stop =>
			s_busy <= '0';
			s_ready <='1';
			data_temp <= (others => '0');
			index <= n-1;
			state <= rdy;
	end case;
end if;
end process;
busy <= s_busy;
ready <= s_ready;
end beh;
