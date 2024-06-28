library ieee;
use ieee.std_logic_1164.all;

entity demux14 is
port(		
		e	 				 : in std_logic_vector(3 downto 0);
		sel 				 : in std_logic_vector(1 downto 0);
		s1, s2, s3, s4	 : out std_logic_vector(3 downto 0)
	  );
end entity;

architecture beh of demux14 is
begin

process(sel, e)
begin

case sel is

when "00" =>
	s1 <= e;
	s2 <= "0000";
	s3 <= "0000";
	s4 <= "0000";
	
when "01" =>
	s2 <= e;
	s1 <= "0000";
	s3 <= "0000";
	s4 <= "0000";
	
when "10" =>
	s3 <= e;
	s1 <= "0000";
	s2 <= "0000";
	s4 <= "0000";
when others =>
	s4 <= e;
	s1 <= "0000";
	s2 <= "0000";
	s3 <= "0000";

end case;
end process;

end beh;