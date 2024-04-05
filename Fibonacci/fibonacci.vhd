library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fibonacci is
port(
		clk, rst				: in std_logic;
		start					: in std_logic;
		i						: in std_logic_vector(4 downto 0);
		ready, done_tick	: out std_logic;
		f						: out std_logic_vector(19 downto 0)
	  );
end entity;

architecture beh of fibonacci is

type state is(idle, op, done);
signal pr_state, nx_state : state;

constant N	: integer := 20;
signal t0_reg, t0_next, t1_reg, t1_next	: unsigned(N-1 downto 0);		-- temporary registers
signal n_reg, n_next								: unsigned(4 downto 0);			-- index register

begin

--FSMD
process(clk, rst)
begin

if(rst = '1') then
	pr_state <= idle;
	t0_reg <= (others => '0');
	t1_reg <= (others => '0');
	n_reg	 <= (others => '0');

elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
	t0_reg <= t0_next;
	t1_reg <= t1_next;
	n_reg <= n_next;
end if;
end process;

--FSMD next state logic
process(start, pr_state, t0_reg, t1_reg, n_reg, start, i, n_next)
begin

ready <= '0';
done_tick <= '0';
nx_state <= pr_state;
t0_next <= t0_reg;
t1_next <= t1_reg;
n_next <= n_reg;

case pr_state is

when idle =>
	ready <= '1';
	if(start = '1') then
		nx_state <= op;
		t0_next <= (others => '0');
		t1_next <= (0 => '1', others => '0');
		n_next <= unsigned(i);
	end if;

when op =>
	if(n_reg = 0) then
		t1_next <= (others => '0');
		nx_state <= done;
	elsif(n_reg = 1) then
		nx_state <= done;
	else
		t1_next <= t0_reg + t1_reg;
		t0_next <= t1_reg;
		n_next <= n_reg - 1;
	end if;

when done =>
	done_tick <= '1';
	nx_state <= idle;

end case;
end process;

f <= std_logic_vector(t1_reg);

end beh;
