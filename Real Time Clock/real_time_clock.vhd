library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity real_time_clock is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        clk_1hz     : buffer std_logic;  -- 1 Hz clock signal
        sseg_h1h2   : out std_logic_vector(13 downto 0);
        sseg_m1m2   : out std_logic_vector(13 downto 0);
        sseg_s1s2   : out std_logic_vector(13 downto 0);
        am_pm       : out std_logic
    );
end entity real_time_clock;

architecture rtl of real_time_clock is
    -- Constants
    constant CLOCK_FREQ : integer := 1000000;  -- 1 MHz clock frequency
    constant CLK_DIVIDER : integer := 10000;   -- Divide clock to get 1 Hz for seconds

    -- Signals for hours, minutes, and seconds
    signal hours   : integer range 0 to 23 := 0;
    signal minutes : integer range 0 to 59 := 0;
    signal seconds : integer range 0 to 59 := 0;

    -- Signals for AM/PM indication
    signal am_pm_flag : std_logic := '0';  -- '0' for AM, '1' for PM

    -- Signals for seven-segment displays
    signal sseg_h1, sseg_h2 : std_logic_vector(6 downto 0);
    signal sseg_m1, sseg_m2 : std_logic_vector(6 downto 0);
    signal sseg_s1, sseg_s2 : std_logic_vector(6 downto 0);

    -- Signal for 1 Hz clock
    signal counter : integer range 0 to CLOCK_FREQ := 0;

begin 
    -- Clock generator process
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
            if counter = CLOCK_FREQ / 2 then
                counter <= 0;
                clk_1hz <= not clk_1hz;  -- Generate 1 Hz clock signal
            end if;
        end if;
    end process;

    -- Clock divider process to generate 1 Hz clock signal
    process(clk_1hz)
    begin
        if rising_edge(clk_1hz) then
            if reset = '1' then
                seconds <= 0;
                minutes <= 0;
                hours <= 0;
            else
                seconds <= seconds + 1;
                if seconds = 60 then
                    seconds <= 0;
                    minutes <= minutes + 1;
                    if minutes = 60 then
                        minutes <= 0;
                        hours <= hours + 1;
                        if hours = 24 then
                            hours <= 0;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Update AM/PM indication
    am_pm_flag <= '1' when hours >= 12 else '0';

    -- Adjust hours for display based on AM/PM
    sseg_h1 <= std_logic_vector(to_unsigned((hours mod 12) / 10, sseg_h1'length));
    sseg_h2 <= std_logic_vector(to_unsigned((hours mod 12) mod 10, sseg_h2'length));

    -- Seven-segment display decoder for minutes
    sseg_m1 <= std_logic_vector(to_unsigned(minutes / 10, sseg_m1'length));
    sseg_m2 <= std_logic_vector(to_unsigned(minutes mod 10, sseg_m2'length));

    -- Seven-segment display decoder for seconds
    sseg_s1 <= std_logic_vector(to_unsigned(seconds / 10, sseg_s1'length));
    sseg_s2 <= std_logic_vector(to_unsigned(seconds mod 10, sseg_s2'length));

    -- Output signals to seven-segment displays
    sseg_h1h2 <= sseg_h1 & sseg_h2;
    sseg_m1m2 <= sseg_m1 & sseg_m2;
    sseg_s1s2 <= sseg_s1 & sseg_s2;

    -- Output AM/PM indication
    am_pm <= am_pm_flag;

end architecture rtl;
