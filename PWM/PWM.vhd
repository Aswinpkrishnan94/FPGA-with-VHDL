library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity PWM is
    generic (
        CLOCK_FREQ: natural := 50_000_000;  -- Clock frequency in Hz (50 MHz by default)
        PWM_RESOLUTION: natural := 4         -- PWM resolution (4-bit by default)
    );
    port (
        clk, rst: in std_logic;
        w: in unsigned(PWM_RESOLUTION-1 downto 0);  -- Duty cycle control signal (4-bit)
        leds: out std_logic_vector(7 downto 0)
    );
end entity;

architecture beh of PWM is

    constant CLOCK_PERIOD: time := 1 ns / real(CLOCK_FREQ);
    constant PERIOD: natural := 2**PWM_RESOLUTION - 1;

    signal counter: natural range 0 to PERIOD := 0;
    signal duty_cycle: natural range 0 to PERIOD := 0;
    signal pwm_out: std_logic;

begin

    -- PWM Circuit and Duty Cycle Calculation
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            pwm_out <= '0';
        elsif rising_edge(clk) then
            if counter = PERIOD then
                counter <= 0;
                pwm_out <= '1';
            elsif counter = duty_cycle then
                pwm_out <= '0';
            end if;
            counter <= counter + 1;
        end if;
    end process;

    -- Convert duty cycle to integer
    duty_cycle <= to_integer(unsigned(w));

    -- LED Time Multiplexing
    process(clk, rst)
    begin
        if rst = '1' then
            leds <= (others => '0');  -- Reset LEDs on reset
        elsif rising_edge(clk) then
            if counter = PERIOD then
                leds <= (others => '0');  -- Turn off LEDs at the beginning of each period
            elsif pwm_out = '1' then
                leds <= (others => '1');  -- Turn on LEDs during the PWM high period
            end if;
        end if;
    end process;

end beh;
