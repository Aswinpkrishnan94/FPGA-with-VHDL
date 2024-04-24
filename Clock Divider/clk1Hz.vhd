library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk1hz is
  port(
        clk_in, rst : in std_logic;      -- input clock
        clk_out     : out std_logic      -- output clock
      );
end entity;

architecture beh of clk1Hz is
  signal counter : integer := 1;         -- (50000000/2 = 25000000)
  signal temp    : std_logic:= '0';

begin

  process(clk_in, rst)
  begin

    if(rst = '1') then
        counter <= 1;
        temp <= '0';

   elsif(clk = '1' and clk'EVENT) then
         if(counter = 25000000) then
           temp <= not temp;
           counter <= 1;
         else
           counter <= counter + 1;
         end if;
   end if;

  clk_out <= temp;      -- 1 Hz Clock output

  end process;
  end beh;
