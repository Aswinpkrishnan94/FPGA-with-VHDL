library ieee;
use ieee.std_logic_1164.all;
use work.utils.all;
	 
entity uart_rx is
generic(
			baud_rate : integer := 9600
		 );
port(
		clk, rx		: in std_logic;
		ready, error: out std_logic;
		data			: out std_logic_vector(7 downto 0);
		parity		: out std_logic
	  );
end entity;

architecture beh of uart_rx is

constant period : integer := 50000000/baud_rate;

type state_machine is (rdy, start, receive, waiting, check);
signal state : state_machine := rdy;

signal timer : integer := 0;
signal bit_index : integer range 0 to 8;
signal rx_data : std_logic_vector(8 downto 0);

begin

process(clk)
begin

if rising_edge(clk) then
	case state is
		when rdy =>
			if(rx = '0') then
				state <= start;
				bit_index <= 0;
			end if;
			
		when start =>
			if(timer = period/2) then
				state <= waiting;
				timer <= 0;
				error <= '0';
				ready <= '0';
			else
				timer <= timer + 1;
			end if;
			
		when waiting =>
			if(timer = period) then
				timer <= 0;
			if(rx = '1') then
				state <= rdy;
			else
				state <= receive;
			end if;
			else
				timer <= timer + 1;
			end if;
			
		when receive =>
			rx_data(bit_index) <= rx;
			bit_index <= bit_index + 1;
			if(bit_index = 8) then
				state <= check;
			else
				state <= waiting;
			end if;
			
		when check =>
			if((xor_reduce(rx_data(7 downto 0))) = rx_data(8)) then
				ready <= '1';
				state <= waiting;
				data <= rx_data(7 downto 0);
				parity <= rx_data(8);
			else
				ready <= '0';
				data(7 downto 0) <= (others => '-');
				error <= '0';
				state <= rdy;
			end if;
	end case;
end if;			
end process;
end beh;
