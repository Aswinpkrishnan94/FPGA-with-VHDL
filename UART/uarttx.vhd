library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uarttx is
generic(
			n	: integer := 8;	-- no of data bits
			m	: integer := 16	-- no of stop bits
		 );
port(
		clk, rst : in std_logic;
		stick	: in std_logic;
		tx_start : in std_logic;
		din : in std_logic_vector(n-1 downto 0);
		tx_done : out std_logic;
		tx	: out std_logic
	  );
end entity;

architecture beh of uarttx is

type state is(idle, start, data, stop);
signal pr_state, nx_state : state;

signal s_reg, s_next	: unsigned(3 downto 0);
signal n_reg, n_next	: unsigned(2 downto 0);
signal b_reg, b_next	: std_logic_vector(7 downto 0);
signal tx_reg, tx_next	: std_logic;

begin

--register
process(clk, rst)
begin

if(rst = '1') then
	pr_state <= idle;
	s_reg <= (others => '0');
	n_reg <= (others => '0');
	b_reg <= (others => '0');
	tx_reg <= '1';
	
elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
	s_reg <= s_next;
	n_reg <= n_reg;
	b_reg <= b_next;
	tx_reg <= tx_next;
end if;
end process;

--next state logic
process(pr_state, s_reg, n_reg, b_reg, stick, tx_reg, tx_start,din)
begin

nx_state <= pr_state;
s_next <= s_reg;
n_next <= n_reg;
b_next <= b_reg;
tx_next <= tx_reg;
tx_done <= '0';

case pr_state is

when idle =>
	tx_next <= '1';
	if(tx_start = '1') then
		s_next <= (others => '0');
		b_next <= din;
		nx_state <= start;
	end if;

when start =>
	tx_next <= '0';
	if(stick = '1') then
		if(s_reg = 15) then
			nx_state <= data;
			s_next <= (others=>'0');
			n_next <= (others => '0');
		else
			s_next <= s_reg + 1;
		end if;
	end if;

when data =>
	tx_next <= b_reg(0);
	if(stick = '1') then
		if(s_reg = 15) then
			s_next <= (others => '0');
			b_next <= '0'&b_reg(7 downto 1);
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
	tx_next <= '1';
	if(stick = '1') then
		if(s_reg = m-1) then
			nx_state <= idle;
			tx_done <= '1';
		else
			s_next <= s_reg + 1;
		end if;
	end if;

end case;
end process;
tx <= tx_reg;
end beh;
