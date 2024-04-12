library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ps2rx is
port(
		clk, rst	  : in std_logic;
		ps2c, ps2d : in std_logic;
		rx_en		  : in std_logic;
		rx_done	  : out std_logic;
		dout		  : out std_logic_vector(7 downto 0)
	  );
end entity;

architecture beh of ps2rx is
type state is(idle, dps, load);
signal pr_state, nx_state : state;

signal filter_reg, filter_next : std_logic_vector(7 downto 0);
signal f_ps2c_reg, f_ps2c_next: std_logic;
signal n_reg, n_next: unsigned(3 downto 0);
signal b_reg, b_next:std_logic_vector(10 downto 0);
signal fall_edge : std_logic;

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

-- to extract 8-bit data
process(clk, rst)
begin

if(rst = '1') then
pr_state <= idle;
n_reg <= (others=>'0');
b_reg <= (others=> '0');

elsif(clk = '1' and clk'EVENT) then
pr_state <= nx_state;
n_reg <= n_next;
b_reg <= b_next;

end if;
end process;

--next state logic
process(pr_state, rx_en, n_reg, b_reg, fall_edge, ps2d)
begin

nx_state <= pr_state;
rx_done <= '0';
n_next <= n_reg;
b_next <= b_reg;

case pr_state is

when idle =>
	if(fall_edge = '1' and rx_en = '1') then
		nx_state <= dps;
		n_next <= "1001";
		b_next <= b_reg(10 downto 1)&ps2d;
	end if;
	
when dps =>
	if(fall_edge = '1') then
		b_next <= b_reg(10 downto 1)&ps2d;
		if(n_reg = 0)then
			nx_state <= load;
		else
			n_next <= n_reg + 1;
		end if;
	end if;

when load =>
	nx_state <= idle;
	rx_done <= '1';

end case;
end process;

--output
dout <= b_reg(8 downto 1); -- data bits

end beh;
