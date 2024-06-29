library ieee;
use ieee.std_logic_1164.all;

entity controller is
port(
		instr : in std_logic_vector(7 downto 0);
		sel_alu: out std_logic_vector(2 downto 0);
		sel_mux1: out std_logic;
		sel_demux, sel_mux2 : out std_logic_vector(1 downto 0);
		ce1, ce2, ce3,ce4 : out std_logic
	 );
end entity;

architecture beh of controller is
signal s : std_logic_vector(1 downto 0);
begin
sel_alu <= instr(2)&instr(1)&instr(0);
sel_mux1 <= instr(3);
sel_mux2 <= instr(5) & instr(4);
sel_demux <= instr(7) &instr(6); 

process(s)
begin

case s is

when "00" =>
ce1 <= '1';
ce2 <= '0';
ce3 <= '0';
ce4 <= '0';

when "01" =>
ce1 <= '0';
ce2 <= '1';
ce3 <= '0';
ce4 <= '0';

when "10" =>
ce1 <= '0';
ce2 <= '0';
ce3 <= '1';
ce4 <= '0';

when others =>
ce1 <= '0';
ce2 <= '0';
ce3 <= '0';
ce4 <= '1';

end case;
end process;
end beh;