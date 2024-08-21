library ieee;
use ieee.std_logic_1164.all;

entity adderNbit is
generic(
		n	: integer := 8
		 );
port(
		a, b 	: in std_logic_vector(n-1 downto 0);
		cin	: in std_logic;
		sum	: out std_logic_vector(n-1 downto 0);
		cout	: out std_logic
	  );
end entity;

architecture beh of adderNbit is
begin

process(a,b,cin)
variable carry : std_logic_vector(n downto 0);
begin
carry(0) := cin;
for i in 0 to n-1 loop
sum(i)<= a(i) xor b(i) xor carry(i);
carry(i+1) := (a(i) and carry(i)) or (b(i) and carry(i)) or (a(i) and b(i));
end loop;
cout <= carry(n);
end process;
end beh;
		
