library ieee;
use ieee.std_logic_1164.all;

entity tlc is
port(
		clk, rst 				  	     : in std_logic;
		T									  : in std_logic;
		Rns, Yns, Gns, Rew, Yew, Gew : out std_logic
	 );
end entity;

architecture beh of tlc is

type state is (zero, one, two, three);
signal pr_state, nx_state : state;

constant Tyns_const : integer := 3;
constant Tgns_const : integer := 10;

constant Tyew_const : integer := 3;
constant Tgew_const : integer := 5;
 
signal Tyns, Tgns, Tyew, Tgew : integer := 0;

begin

process(clk, rst) 
begin

if(rst = '1') then
	pr_state <= zero;
	
elsif(clk = '1' and clk'EVENT) then
	pr_state <= nx_state;
end if;

end process;

process(pr_state, T)
begin


Rns <= '0';
Yns <= '0';
Gns <= '1';

Rew <= '1';
Yew <= '0';
Gew <= '0';

nx_state <= pr_state;

case pr_state is

when zero =>
	Gns <= '1';
	Rew <= '1';
	if(T = '1') then
		if(Tgns > 0) then
			Tgns <= Tgns - 1;
		else
			Tgns <= Tgns_const;
			nx_state <= one;
		end if;
	else
		nx_state <= zero;
	end if;
	
when one =>
	Rew <= '1';
	Yns <= '1';
	if(T = '0') then
		if(Tyns > 0) then
			Tyns <= Tyns - 1;
		else
			nx_state <= two;
			Tyns <= Tyns_const;
		end if;
	else
		nx_state <= one;
	end if;
	
when two =>
	Gew <= '1';
	Rns <= '1';
	if(T = '0') then
		if(Tgew > 0) then
			Tgew <= Tgew - 1;
		else
			nx_state <= three;
			Tgew <= Tgew_const;
		end if;
	else
		nx_state <= two;
	end if;
	
when three =>
	Yew <= '1';
	Rns <= '1';
	if(T = '0') then
		if(Tyew > 0) then
			Tyew <= Tyew - 1;
		else
			nx_state <= zero;
			Tyew <= Tyew_const;
		end if;	
	else
		nx_state <= three;
	end if;
	
when others =>
	Rns <='1';
	Rew <= '1';
	nx_state <= zero;
	
end case;

end process;

end beh;
