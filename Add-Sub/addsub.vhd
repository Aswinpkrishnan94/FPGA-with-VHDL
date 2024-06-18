library ieee;
use ieee.std_logic_1164.all;

entity addsub is
port(
		sel				: in std_logic;
		a, b, cin, bin	: in std_logic;
		sum,diff			: out std_logic;
		cout, bout		: out std_logic
	 );
end entity;

architecture beh of addsub is
begin

process(sel, a, b, cin, bin)
begin
	if(sel = '0') then
		sum <= a xor b xor cin;
		cout <= (a and b) and (b and cin) and (cin and a);

	else
		diff <= a xor b xor bin;
		bout <= (a and b) and (b and bin) and (bin and (not a));
	end if;
	
end process;	
end beh;
