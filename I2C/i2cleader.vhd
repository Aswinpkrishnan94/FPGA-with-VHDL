library ieee;
use ieee.std_logic_1164.all;

entity i2cleader is
    generic(
        input_clk : integer := 50000000;
        bus_clk   : integer := 4000000
    );
    port(
        clk, rst, en, rw     : in std_logic;
        addr                 : in std_logic_vector(6 downto 0);
        data_wr              : in std_logic_vector(7 downto 0);
        busy, eop            : out std_logic;
        data_rd              : out std_logic_vector(7 downto 0);
        ack_err              : buffer std_logic;
        sda, scl             : inout std_logic
    );
end entity;

architecture beh of i2cleader is

    constant divider : integer := input_clk / bus_clk/ 4;

    type state_machine is (rdy, start, cmd, slave_ack1, wr, rd, slave_ack2, mstr_ack, stop);
    signal state : state_machine := rdy;

    signal bit_count : integer := 0;
    signal data_clk, data_clk_prev : std_logic := '0';
    signal data_tx, data_rx : std_logic_vector(7 downto 0);
    signal scl_en : std_logic := '0';
    signal scl_clk : std_logic := '0';
    signal sda_int : std_logic := '1';
    signal sda_en : std_logic := '0';
    signal addr_rw : std_logic_vector(7 downto 0);
    signal count : integer := 0;
    signal eop_s : std_logic := '0';

begin

    -- Clock Divider Process
    process(clk, rst)
    begin
        if rst = '1' then
            count <= 0;
            scl_clk <= '0';
            data_clk <= '0';
        elsif rising_edge(clk) then
            data_clk_prev <= data_clk;
            if count = (divider * 4) - 1 then
                count <= 0;
            else
                count <= count + 1;
            end if;
            case count is
                when 0 to (divider - 1) =>
                    scl_clk <= '0';
                    data_clk <= '0';
                when divider to ((divider * 2) - 1) =>
                    scl_clk <= '0';
                    data_clk <= '1';
                when (divider * 2) to ((divider * 3) - 1) =>
                    scl_clk <= '1';
                    data_clk <= '1';
                when others =>
                    scl_clk <= '1';
                    data_clk <= '0';
            end case;
        end if;
    end process;

    -- State Machine Process
    process(clk, rst)
    begin
        if rst = '1' then
            state <= rdy;
            busy <= '0';
            scl_en <= '0';
            sda_int <= '1';
            ack_err <= '0';
            bit_count <= 7;
            data_rd <= (others => '0');
            eop_s <= '0';
        elsif rising_edge(clk) then
            if data_clk = '1' and data_clk_prev = '0' then
                case state is
                    when rdy =>
                        if en = '1' then
                            busy <= '1';
                            addr_rw <= addr & rw;
                            data_tx <= data_wr;
                            state <= start;
                        else
                            busy <= '0';
                            state <= rdy;
                        end if;

                    when start =>
                        busy <= '1';
                        sda_int <= addr_rw(7);
                        bit_count <= 6;
                        state <= cmd;

                    when cmd =>
                        if bit_count = 0 then
                            sda_int <= addr_rw(0);
                            state <= slave_ack1;
                        else
                            sda_int <= addr_rw(bit_count);
                            bit_count <= bit_count - 1;
                        end if;

                    when slave_ack1 =>
                        if addr_rw(0) = '0' then
                            sda_int <= data_tx(7);
                            bit_count <= 6;
                            state <= wr;
                        else
                            sda_int <= '1';
                            bit_count <= 7;
                            state <= rd;
                        end if;

                    when wr =>
                        if bit_count = 0 then
                            sda_int <= data_tx(0);
                            state <= slave_ack2;
                        else
                            sda_int <= data_tx(bit_count);
                            bit_count <= bit_count - 1;
                        end if;

                    when rd =>
                        if bit_count = 0 then
                            data_rd <= data_rx;
                            state <= mstr_ack;
                        else
                            bit_count <= bit_count - 1;
                        end if;

                    when slave_ack2 =>
                        if en = '1' then
                            busy <= '0';
                            state <= start;
                        else
                            state <= stop;
                        end if;

                    when mstr_ack =>
                        if en = '1' then
                            busy <= '0';
                            state <= start;
                        else
                            state <= stop;
                        end if;

                    when stop =>
                        busy <= '0';
                        state <= rdy;

                    when others =>
                        state <= rdy;
                end case;
            elsif data_clk = '0' and data_clk_prev = '1' then
                case state is
                    when start =>
                        scl_en <= '1';
                        ack_err <= '0';

                    when slave_ack1 =>
                        if sda /= '0' then
                            ack_err <= '1';
                        end if;

                    when rd =>
                        data_rx(bit_count) <= sda;

                    when slave_ack2 =>
                        if sda /= '0' then
                            ack_err <= '1';
                        end if;

                    when stop =>
                        scl_en <= '0';

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    -- Output Assignments
    with state select
        sda_en <= '0' when start,
                 '1' when stop,
                 sda_int when others;

    scl <= '0' when (scl_en = '1' and scl_clk = '0') else 'Z';
    sda <= '0' when (sda_en = '0') else 'Z';
    eop <= eop_s;

end beh;
