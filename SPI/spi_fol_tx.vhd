library ieee;
use ieee.std_logic_1164.all;

entity spi_fol_tx is
generic(
			n : integer := 8
		 );
port(
		sck, ss		: in std_logic;
		data     	: in std_logic_vector(n-1 downto 0);
		busy, miso	: out std_logic
	 );
end entity;

architecture beh of spi_fol_tx is

type state_machine is (rdy, tx, stop);
signal state : state_machine := rdy;

signal index : integer := n-1;

begin

process(sck)
begin

if falling_Edge(sck) then
	case state is
		when rdy =>
			if(ss = '0') then
				busy <= '1';
				miso <= data(index);
				index <= index - 1;
				state <= tx;
			end if;
		 
		when tx =>
			if(index = 0) then
				state <= stop;
			else
				miso <= data(index);
				index <= index - 1;
			end if;
			
		when stop =>	
			busy <= '0';
			index <= n-1;
			state <= rdy;
	end case;
end if;
end process;
end beh;
