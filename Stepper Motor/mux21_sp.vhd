library ieee;
use ieee.std_logic_1164.all;

entity mux21_sp is
port(
		clk_out_sp, clk_out_cp, c   : in std_logic;
		clk_sp_cp						 : out std_logic
	  );
end entity;

architecture beh of mux21_sp is
begin

with c select
	clk_sp_cp <= clk_out_sp	 when '0',
					 clk_out_cp  when others;
end beh;
