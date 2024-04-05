library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifobuffer is
generic(
			N : integer := 8;			-- No of bits
			W : integer := 4			-- No of Address bits
		  );
port(
		clk, rst			: in std_logic;
		wr, rd			: in std_logic;
		data_in			: in std_logic_vector(N-1 downto 0);
		empty, full		: out std_logic;
		data_out			: out std_logic_vector(N-1 downto 0)
	  );
end entity;

architecture beh of fifobuffer is

-- Implement storage location matrix. Two input control signal registers, Two output control signal registers

type matrix is array(2**W-1 downto 0) of std_logic_vector(N-1 downto 0);
signal array_reg : matrix;

signal wr_ptr_reg, wr_ptr_next 	: std_logic_vector(W-1 downto 0);
signal rd_ptr_reg, rd_ptr_next	: std_logic_vector(W-1 downto 0);
signal wr_ptr_succ, rd_ptr_succ	: std_logic_vector(W-1 downto 0);

signal empty_reg, empty_next, full_reg, full_next	: std_logic;

signal wr_op : std_logic_vector(1 downto 0);
signal wr_en : std_logic;

begin

-- register File
process(clk ,rst)
begin

if(rst = '1') then
	array_reg <= (others => (others => '0'));

elsif(clk = '1' and clk'EVENT) then
	if(wr_en = '1') then
		array_reg(to_integer(unsigned(wr_ptr_reg))) <= data_in;
	end if;
end if;
end process;

-- read port
	data_out <= array_reg(to_integer(unsigned(rd_ptr_reg)));
	
-- write only when FIFO is not full
	wr_en <= wr and (not full_reg);
	
-- FIFO Control Logic
process(clk, rst)
begin

if(rst = '1') then
	wr_ptr_reg <= (others => '0');
	rd_ptr_reg <= (others => '0');
	full_reg   <= '0';
	empty_reg  <= '1';

elsif(clk = '1' and clk'EVENT) then
	wr_ptr_reg <= wr_ptr_next;
	rd_ptr_reg <= rd_ptr_next;
	full_reg <= full_next;
	empty_reg <= empty_next;
end if;
end process;

-- successive pointer values
wr_ptr_succ	<= std_logic_vector(unsigned(wr_ptr_reg)+1);
rd_ptr_succ	<= std_logic_vector(unsigned(rd_ptr_reg)+1);

-- next state logic for read, write
wr_op <= wr & rd;
process(wr_ptr_reg, wr_ptr_succ, rd_ptr_reg, rd_ptr_succ, wr_op, empty_reg, full_reg)
begin

wr_ptr_next <= wr_ptr_reg;
rd_ptr_next <= rd_ptr_reg;
empty_next <= empty_reg; 
full_next <= full_reg;

case wr_op is

when "00" => -- no operation
when "01" => -- read
	if(empty_reg /= '1') then 	-- not empty
		rd_ptr_next <= rd_ptr_succ;
		full_next <='0';
		
		if(rd_ptr_succ = wr_ptr_reg) then
			empty_next <= '1';
		end if;
	end if;

when "10" => -- write
	if(full_reg /= '1') then 	-- not full
		wr_ptr_next <= wr_ptr_succ;
		empty_next <= '0';
		
		if(wr_ptr_succ = rd_ptr_reg) then
			full_next <= '1';
		end if;
	end if;
	
when others =>	-- write/read
	wr_ptr_next <= wr_ptr_succ;
	rd_ptr_next <= rd_ptr_succ;

end case;
end process;

full <= full_reg;
empty <= empty_reg;

end beh;
	
