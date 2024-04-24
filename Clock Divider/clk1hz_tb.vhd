library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk1hz_tb is
  end entity;

architecture beh of clk1hz_tb is

  component clk1hz is
    port(
          clk_in, rst : in std_logic;
          clk_out     : out std_logic
        );
  end component;

  signal clk_in, rst  : std_logic := '0';
  signal clk_out : std_logic;               -- 1 Hz Clock output
  constant clk_period : time := 20 ns;      -- 50 Mhz Clock input

begin

uut: clk1hz
  port  map(
             clk_in => clk_in,
             rst => rst,
             clk_out => clk_out
            );

sim_reset_process: process
begin
  rst <= '1';
  wait for 100 ns;
  rst <= '0';
wait for 100 ns;

end process;

sim_clock_process : process
begin
  clk_in <= '1';
  wait for clk_period/2;
  clk_in <= '0';
  wait for clk_period/2;
end process;

end beh;
