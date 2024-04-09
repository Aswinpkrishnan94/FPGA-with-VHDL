library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uartrx is
generic(
			n	: integer := 8;	-- no of data bits
			m	: integer := 16	-- no of stop bits
		 );
port(
		clk, rst	: in std_logic;
		rx			: in std_logic;
		stick		: in std_logic;
		rx_done	: out std_logic;
		dout		: out std_logic_vector(n-1 downto 0)
	  );
end entity;

architecture beh of uartrx is

type state is(idle, start, data, stop);
signal pr_state, nx_state : state;

signal s_reg, s_next	: unsigned(3 downto 0);
signal n_reg, n_next	: unsigned(2 downto 0);
signal b_reg, b_next	: std_logic_vector(7 downto 0);

begin

--register
process(clk, rst)
begin

if(rst = '1') then
	pr_state <= idle;
	s_reg <= (others => '0');
	n_reg <= (others => '0');
	b_reg <= (others => '0');

elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
	s_reg <= s_next;
	n_reg <= n_reg;
	b_reg <= b_next;

end if;
end process;

--next state logic
process(pr_state, s_reg, n_reg, b_reg, stick, rx)
begin

nx_state <= pr_state;
s_next <= s_reg;
n_next <= n_reg;
b_next <= b_reg;
rx_done <= '0';

case pr_state is

when idle =>
	if(rx = '0') then
		s_next <= (others => '0');
		nx_state <= start;
	end if;

when start =>
	if(stick = '1') then
		if(s_reg = 7) then
			nx_state <= data;
			s_next <= (others=>'0');
			n_next <= (others => '0');
		else
			s_next <= s_reg + 1;
		end if;
	end if;

when data =>
	if(stick = '1') then
		if(s_reg = 15) then
			s_next <= (others => '0');
			b_next <= rx&b_reg(7 downto 1);
			if(n_reg = n-1) then
				nx_state <= stop;
			else
				n_next <= n_reg + 1;
			end if;
		else
			s_next <= s_reg + 1;
		end if;
	end if;
	
when stop =>
	if(stick = '1') then
		if(s_reg = m-1) then
			nx_state <= idle;
			rx_done <= '1';
		else
			s_next <= s_reg + 1;
		end if;
	end if;

end case;
end process;
dout <= b_reg;
end beh;
