library ieee;
use ieee.std_logic_1164.all;

entity sram_ctrl is
port(
	-- main system
		clk ,rst   					: in  std_logic;
		addr							: in  std_logic_vector(17 downto 0);
		mem, rw	  					: in  std_logic;
		data_f2s  					: in  std_logic_vector(15 downto 0);
		ready		  					: out std_logic;
		data_s2f_r, data_s2f_ur : out std_logic_vector(15 downto 0);
	-- to/from chip
		ad			  					: out std_logic_vector(17 downto 0);
		we_n, oe_n 					: out std_logic;
	-- sram chip
		data				  			: inout std_logic_vector(15 downto 0);
		ce_n, lb_n, ub_n			: out std_logic
	  );
end entity;

architecture beh of sram_ctrl is
type state is(idle, rd1, rd2, wr1, wr2);
signal pr_state, nx_state : state;

signal df2s_reg, df2s_next, ds2f_reg, ds2f_next : std_logic_vector(15 downto 0);
signal addr_reg, addr_next : std_logic_vector(17 downto 0);
signal we_buf, oe_buf, tri_buf : std_logic;
signal we_reg, oe_reg, tri_reg : std_logic;
begin

-- registers
process(clk, rst)
begin

if(rst = '1') then
	pr_state <= idle;
	df2s_reg <= (others =>'0');
	ds2f_reg <= (others =>'0');
	addr_reg <= (others =>'0');
	we_reg	<= '1';
	oe_reg   <= '1';
	tri_reg  <= '1';
	
elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
	df2s_reg <= df2s_next;
	ds2f_reg <= ds2f_next;
	addr_reg <= addr_next;
	we_reg <= we_buf;
	oe_reg <= oe_buf;
	tri_reg <= tri_buf;
end if;
end process;

-- next state logic
process(pr_state, df2s_reg, ds2f_reg, we_reg, oe_reg, tri_reg, addr_reg, mem, rw, data, addr)
begin

nx_state <= pr_state;
df2s_next<= df2s_reg;
ds2f_next<=ds2f_reg;
ready <= '0';

case pr_state is

when idle =>
	if(mem = '0') then	-- when memory operation is not initiated
		nx_state <= idle;
	else
		addr_next <= addr;
		if(rw = '1') then		-- write
			nx_state <= wr1;
			df2s_next <= data_f2s;
		else		-- read
			nx_state <= rd1;
		end if;
	end if;
	
	ready <= '1';
	
when wr1 =>
	nx_state <= wr2;
	
when wr2=>
	nx_state <= idle;
	
when rd1 =>
	nx_state <= rd1;
	
when rd2 =>
	ds2f_next <= data;
	nx_state <= idle;
end case;
end process;

-- look ahead logic
process(nx_state)
begin

tri_buf <= '1';
we_buf <= '1';
oe_buf <= '1';

case nx_state is

when idle=>
when wr1=>
	we_buf<= '0';
	tri_buf <= '0';
when wr2=>
	tri_buf <= '0';
when rd1 =>
	oe_buf <= '0';
when rd2 =>
	oe_buf <= '0';
	
end case;
end process;

-- main system
data_s2f_r <= ds2f_reg;
data_s2f_ur <= data;

-- to SRAM
we_n <= we_reg;
oe_n <= oe_reg;
ad <= addr_reg;

--from chip
ce_n <= '0';
lb_n <= '0';
ub_n <= '0';

data <= df2s_reg when tri_reg = '0' else (others=>'Z');
end beh;

