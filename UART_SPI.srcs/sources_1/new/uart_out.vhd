library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_out is
    Port ( clk : in STD_LOGIC;
           start_tx : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           s_out : out STD_LOGIC;
           ready : out STD_LOGIC );
end uart_out;

architecture Behavioral of uart_out is
    component clock_div is
        Port ( clk : in STD_LOGIC; clk_out : out STD_LOGIC );
    end component;

    signal clk_en : STD_LOGIC;
    type state_type is (IDLE, START_BIT, SEND_DATA, STOP_BIT, DONE_TX);
    signal state : state_type := IDLE;
    
    signal sample_cnt : integer range 0 to 15 := 0;
    signal bit_idx : integer range 0 to 7 := 0;
    signal s_aux : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    C0: clock_div port map(clk => clk, clk_out => clk_en);

    process(clk)
    begin
        if rising_edge(clk) then
            if clk_en = '1' then
                case state is
                    when IDLE =>
                        s_out <= '1';
                        ready <= '1';
                        if start_tx = '1' then
                            s_aux <= data_in;
                            sample_cnt <= 0;
                            ready <= '0';
                            state <= START_BIT;
                        end if;

                    when START_BIT =>
                        s_out <= '0';
                        if sample_cnt = 15 then
                            sample_cnt <= 0;
                            bit_idx <= 0;
                            state <= SEND_DATA;
                        else
                            sample_cnt <= sample_cnt + 1;
                        end if;

                    when SEND_DATA =>
                        s_out <= s_aux(bit_idx);
                        if sample_cnt = 15 then
                            sample_cnt <= 0;
                            if bit_idx = 7 then
                                state <= STOP_BIT;
                            else
                                bit_idx <= bit_idx + 1;
                            end if;
                        else
                            sample_cnt <= sample_cnt + 1;
                        end if;

                    when STOP_BIT =>
                        s_out <= '1';
                        if sample_cnt = 15 then
                            state <= DONE_TX;
                        else
                            sample_cnt <= sample_cnt + 1;
                        end if;

                    when DONE_TX =>
                        ready <= '1';
                        state <= IDLE;

                    when others => state <= IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;