library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bridge_uart_spi is
  Port (
        done_uart, clk : in std_logic;
        ss: out std_logic_vector(1 downto 0);
        mclk, mosi: out std_logic;
        uart_in: in std_logic_vector(7 downto 0)
        );
end bridge_uart_spi;

architecture Behavioral of bridge_uart_spi is
type state is (IDLE, START, SEND_LOW, SEND_HIGH, DONE);  -- split send in high and low to generate mclk
signal init_state : state :=IDLE;
signal shift_reg : std_logic_vector(7 downto 0):= (others => '0');
signal cnt: integer range 0 to 7 :=7;
signal spi_clk: std_logic := '0';

component clock_div is
    Port (clk: in std_logic;
          clk_out: out std_logic );
end component;

begin

C1: clock_div port map(clk => clk, clk_out => spi_clk);

process(clk)
begin
    if rising_edge(clk) then
        if spi_clk = '1' then 
            case init_state is
                when IDLE =>
                    ss <= "11";
                    mclk <= '0';
                    mosi <= '0';
                    cnt <= 7;
                    if done_uart = '1' then
                        init_state <= START;
                    end if;
                 when START =>
                    ss <= "01";
                    shift_reg <= uart_in;
                    init_state <= SEND_LOW;
                 when SEND_LOW => 
                    mosi <= shift_reg(cnt);
                    mclk <= '0';
                    init_state <= SEND_HIGH;
                 when SEND_HIGH =>
                    mclk <= '1';
                    if cnt = 0 then 
                        init_state <= DONE;
                    else 
                        cnt <= cnt -1;
                        init_state <= SEND_LOW;
                    end if;
                 when DONE =>
                    ss <= "11";
                    mclk <= '0';
                    init_state <= IDLE;
            end case;
            end if;
            end if;
end process;




end Behavioral;
