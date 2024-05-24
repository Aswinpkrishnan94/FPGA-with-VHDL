library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity basic_comparator is
port(
		a,b : integer range 0 to 255;
		sel : in std_logic;
		x1,x2,x3	: out std_logic
    );
end entity;

architecture beh of basic_comparator is
signal signed_a	: signed(7 downto 0);
signal signed_b   : signed(7 downto 0);
begin
signed_a <= to_signed(a);
signed_b <= to_signed(b);
 
 process(sel)
    begin
        if sel = '0' then
            x1 <= (not a) and (not b);
            x2 <= a and b;
            x3 <= a or b;
        else
            x1 <= (not a_signed) and (not b_signed);
            x2 <= a_signed and b_signed;
            x3 <= a_signed or b_signed;
        end if;
end process;
end beh;
