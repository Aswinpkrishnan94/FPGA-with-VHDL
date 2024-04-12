library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ps2tx is
port(
		clk, rst	: in std_logic;
		din		: in std_logic_vector(7 downto 0);
		wr_ps2	: std_logic;
		ps2c,ps2d: inout std_logic;
		tx_idle  : out std_logic;
		tx_done  : out std_logic
	 );
end entity;

architecture beh of ps2tx is
type state is(idle, rts, start, data, stop);
signal pr_state, nx_state:state;

signal filter_reg , filter_next : std_logic_vector ( 7 downto 0 ) ;
signal f_ps2c_reg,f_ps2c_next: std_logic;
signal b_reg , b_next : std_logic_vector (8 downto 0 ) ;
signal c_reg , c_next : unsigned (12 downto 0) ;
signal n_reg ,n_next  : unsigned (3 downto 0) ;
signal ps2c_out, ps2d_out : std_logic;
signal par, fall_edge : std_logic;
signal tri_c , tri_d  : std_logic;

begin

--filter and fall edge detection
process(clk, rst)
begin

if(rst = '1') then
filter_reg <= (others => '0');
f_ps2c_reg <= '0';

elsif(clk = '1' and clk'EVENT) then
filter_reg <= filter_next;
f_ps2c_reg <= f_ps2c_next;

end if;
end process;

filter_next <= ps2c&filter_reg(7 downto 1);
f_ps2c_next <= '1' when filter_reg = "11111111" else
					'0' when filter_reg = "00000000" else
					f_ps2c_reg;

fall_edge <= f_ps2c_reg and (not f_ps2c_next);

-- registers
process(clk, rst)
begin

if(rst = '1') then
pr_state <= idle;
n_reg <= (others=>'0');
b_reg <= (others=> '0');
c_reg <= (others=>'0');

elsif(clk = '1' and clk'EVENT) then
pr_state <= nx_state;
n_reg <= n_next;
b_reg <= b_next;
c_reg <= c_next;
end if;
end process;

-- odd parity bit
par <= not(din(7) xor din(6) xor din(5) xor din(4) xor din(3) xor din(2) xor din(1) xor din(0));

process(pr_state, n_reg, b_reg,c_reg,wr_ps2,din,par,fall_edge)
begin

nx_state <= pr_state;
n_next <= n_reg;
b_next <= b_reg;
c_next <= c_reg;
ps2c_out <= '1';
ps2d_out <= '1';
tri_c <= '0';
tri_d <= '0';
tx_idle <= '0';

case pr_state is

when idle =>
	tx_idle <= '1';
	if(wr_ps2 = '1') then
		b_next <= par & din;
		c_next <= (others=>'1');		-- 2^13 -1
		nx_state <= rts;
	end if;
	
when rts =>		-- request to send
	ps2c_out <= '0';
	tri_c <= '1';
	c_next <= c_reg - 1;
	if(c_reg = 0) then
		nx_state <= start;
	end if;

when start =>		-- assert start bit
	ps2d_out <= '0';
	tri_d <= '1';
	if(fall_edge = '1') then
		n_next <= "1000";
		nx_state <= data;
	end if;
	
when data =>
	ps2d_out <= b_reg(0);
	tri_d <= '1';
	if(fall_edge = '1') then
		b_next <= '0' & b_reg(8 downto 1);
		if(n_reg = 0) then
			nx_state <= stop;
		else
			n_next <= n_reg - 1;
		end if;
	end if;
	
when stop =>
	if(fall_edge = '1') then
		nx_state <= idle;
		tx_done <= '1';
	end if;
end case;
end process;

-- tristate buffers
ps2c <= ps2c_out when tri_c = '1' else 'Z';
ps2d <= ps2d_out when tri_d = '1' else 'Z';
end beh;
