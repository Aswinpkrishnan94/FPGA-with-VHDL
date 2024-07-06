library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is
generic(
			baud_rate : integer := 9600
		 );
port(
		clk, send		: in std_logic;
		data				: in std_logic_vector(7 downto 0);
		ready, tx		: out std_logic
	 );
end entity;

architecture beh of uart_tx is

constant period : integer := 50000000/baud_rate;		-- number of clock cycles needed for particular baud rate
constant bit_index_max : integer := 10;

type state_machine is (ready_bit, load_bit, send_bit);
signal state : state_machine := ready_bit;

signal timer :integer := 0;
signal tx_data : std_logic_vector(9 downto 0);
signal bit_index : integer range 0 to bit_index_max := 0;
signal tx_bit : std_logic := '1';

begin

process(clk)
begin

if rising_edge(clk) then
	case state is
	
		when ready_bit =>
			timer <= 0;
			bit_index <= 0;
			tx_bit <= '1';
			
			if(send = '1') then
				tx_data <= '1' & data & '0';
				state <= load_bit;
			end if;
			
		when load_bit =>
			state <= send_bit;
			bit_index <= bit_index + 1;
			tx_bit <= tx_data(bit_index);
			
		when send_bit =>
			if(timer = period) then
				timer <= 0;
			if(bit_index = bit_index_max) then
				state <= ready_bit;
			else
				state <= load_bit;
			end if;
			else
				timer <= timer + 1;
			end if;
	end case;
end if;
end process;
tx <= tx_bit;
ready <= '1' when (state = ready_bit) else '0';
end beh;
			
			
