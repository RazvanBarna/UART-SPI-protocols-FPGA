library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_in is
    Port ( clk : in STD_LOGIC;
           s_in : in STD_LOGIC;
           s_out : out STD_LOGIC_VECTOR (7 downto 0);
           err : out STD_LOGIC;
           done : out STD_LOGIC );
end uart_in;

architecture Behavioral of uart_in is
    component clock_div is
        Port ( clk : in STD_LOGIC; 
                clk_out : out STD_LOGIC );
    end component;

    signal clk_en : STD_LOGIC;
    type state_type is (IDLE, START_DETECT, READ_DATA, VERIFY_STOP, DONE_STATE, ERROR_STATE);
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
                        done <= '0';
                        err <= '0';
                        if s_in = '0' then 
                            sample_cnt <= 0;
                            state <= START_DETECT;
                        end if;

                    when START_DETECT =>
                        if sample_cnt = 7 then 
                                sample_cnt <= 0;
                                bit_idx <= 0;
                                state <= READ_DATA;
                        else
                            sample_cnt <= sample_cnt + 1;
                        end if;

                    when READ_DATA =>
                        if sample_cnt = 15 then 
                            s_aux(bit_idx) <= s_in;
                            sample_cnt <= 0;
                            if bit_idx = 7 then
                                state <= VERIFY_STOP;
                            else
                                bit_idx <= bit_idx + 1;
                            end if;
                        else
                            sample_cnt <= sample_cnt + 1;
                        end if;

                    when VERIFY_STOP =>
                        if sample_cnt = 15 then
                            if s_in = '1' then
                                state <= DONE_STATE;
                            else
                                state <= ERROR_STATE;
                            end if;
                        else
                            sample_cnt <= sample_cnt + 1;
                        end if;

                    when DONE_STATE =>
                        done <= '1';
                        s_out <= s_aux;
                        state <= IDLE;

                    when ERROR_STATE =>
                        err <= '1';
                        state <= IDLE;

                    when others => state <= IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;