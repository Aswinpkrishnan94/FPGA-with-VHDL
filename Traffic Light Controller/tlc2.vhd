library ieee;
use ieee.std_logic_1164.all;

entity traffic_controller is
port(
		clk,	rst		: in std_logic;
		R_E, Y_E, G_E	: out std_logic;
		R_W, Y_W, G_W	: out std_logic;
		R_S, Y_S, G_S	: out std_logic;
		R_N, Y_N, G_N	: out std_logic
	 );
end entity;

architecture beh of traffic_controller is

signal clk_s : std_logic := '0';

component clk_div
port(
		clk_in, rst	: in std_logic;
		clk_out		: out std_logic
	 );
end component;

type state is (zero, one, two, three, four,  five, six);
signal pr_state, nx_state : state;

signal Tr, Ty, Tg : integer := 0;

signal ER, EY, EG, WR, WY, WG, SR, SY, SG, NR, NY, NG	: std_logic;

begin

uut1: clk_div port map(clk, rst, clk_s);

process(clk_s, rst)
    begin
        if rst = '1' then
            pr_state <= zero;
            Tr <= 5;
            Ty <= 3;
            Tg <= 10;
        elsif rising_edge(clk_s) then
            pr_state <= nx_state;
            case pr_state is
                when zero =>
                    if Tr > 0 then
                        Tr <= Tr - 1;
                    else
                        Tr <= 5;  -- Reset the counter
                    end if;
                when one =>
                    if Ty > 0 then
                        Ty <= Ty - 1;
                    else
                        Ty <= 3;  -- Reset the counter
                    end if;
                when two =>
                    if Tg > 0 then
                        Tg <= Tg - 1;
                    else
                        Tg <= 10;  -- Reset the counter
                    end if;
                when three =>
                    if Ty > 0 then
                        Ty <= Ty - 1;
                    else
                        Ty <= 3;  -- Reset the counter
                    end if;
                when four =>
                    if Tg > 0 then
                        Tg <= Tg - 1;
                    else
                        Tg <= 10;  -- Reset the counter
                    end if;
                when five =>
                    if Ty > 0 then
                        Ty <= Ty - 1;
                    else
                        Ty <= 3;  -- Reset the counter
                    end if;
                when six =>
                    if Tg > 0 then
                        Tg <= Tg - 1;
                    else
                        Tg <= 10;  -- Reset the counter
                    end if;
                when others =>
                    -- No action needed
                    null;
            end case;
        end if;
    end process;

    process(pr_state)
    begin
        -- Default values for traffic lights
        ER <= '0';
        EY <= '0';
        EG <= '0';
        WR <= '0';
        WY <= '0';
        WG <= '0';
        SR <= '0';
        SY <= '0';
        SG <= '0';
        NR <= '0';
        NY <= '0';
        NG <= '0';

        nx_state <= pr_state;

        case pr_state is
            when zero =>
                ER <= '1';
                WR <= '1';
                SR <= '1';
                NR <= '1';
                if Tr = 0 then
                    nx_state <= one;
                end if;
            when one =>
                NY <= '1';
                SY <= '1';
                NR <= '0';
                SR <= '0';
                if Ty = 0 then
                    nx_state <= two;
                end if;
            when two =>
                NG <= '1';
                SG <= '1';
                NY <= '0';
                SY <= '0';
                if Tg = 0 then
                    nx_state <= three;
                end if;
            when three =>
                NY <= '1';
                SY <= '1';
                NG <= '0';
                SG <= '0';
                EY <= '1';
                WY <= '1';
                if Ty = 0 then
                    nx_state <= four;
                end if;
            when four =>
                NY <= '0';
                SY <= '0';
                EY <= '0';
                WY <= '0';
                EG <= '1';
                WG <= '1';
                if Tg = 0 then
                    nx_state <= five;
                end if;
            when five =>
                NY <= '1';
                SY <= '1';
                EY <= '1';
                WY <= '1';
                EG <= '0';
                WG <= '0';
                if Ty = 0 then
                    nx_state <= six;
                end if;
            when six =>
                NY <= '0';
                SY <= '0';
                EY <= '0';
                WY <= '0';
                NG <= '1';
                SG <= '1';
                if Tg = 0 then
                    nx_state <= zero;
                end if;
            when others =>
                -- Default state
                ER <= '1';
                WR <= '1';
                SR <= '1';
                NR <= '1';
                nx_state <= zero;
        end case;
    end process;

    -- Output assignments
    R_E <= ER;
    Y_E <= EY;
    G_E <= EG;
    R_W <= WR;
    Y_W <= WY;
    G_W <= WG;
    R_S <= SR;
    Y_S <= SY;
    G_S <= SG;
    R_N <= NR;
    Y_N <= NY;
    G_N <= NG;

end beh;
