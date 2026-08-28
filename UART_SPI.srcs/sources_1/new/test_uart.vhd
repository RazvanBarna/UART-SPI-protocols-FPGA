
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_uart is
  Port (
        clk, rx : in std_logic;
        tx,err : out std_logic;
        an: out std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0);
        spi_ss   : out std_logic_vector(1 downto 0);
           spi_mclk : out std_logic;
           spi_mosi : out std_logic
         );
end test_uart;

architecture Behavioral of test_uart is

signal data_bus : std_logic_vector(7 downto 0);
signal ready_sig : std_logic;
    
component uart_in is
 Port (s_in: in std_logic;
       s_out: out std_logic_vector(7 downto 0);
       err, done: out std_logic;
       clk: in std_logic );
end component;

component uart_out is
  Port (data_in : in std_logic_vector(7 downto 0);
        s_out : out std_logic;
        ready: out std_logic;
        start_tx,clk: in std_logic
         );
end component;

component bridge_uart_spi is
  Port (
        done_uart, clk : in std_logic;
        ss: out std_logic_vector(1 downto 0);
        mclk, mosi: out std_logic;
        uart_in: in std_logic_vector(7 downto 0)
        );
end component;

component display_7seg is
  Port (
      clk: in std_logic;
      an: out std_logic_vector(3 downto 0);
      seg: out std_logic_vector(6 downto 0);
      data_in: in std_logic_vector(7 downto 0)
    );
end component;

begin
C0: uart_in port map(s_in =>rx, s_out => data_bus, err => err,done => ready_sig, clk => clk);
C1: uart_out port map( data_in => data_bus, start_tx => ready_sig, clk =>clk, s_out => tx, ready => open);
C2: bridge_uart_spi port map(clk => clk, done_uart => ready_sig, uart_in => data_bus, ss => spi_ss, mclk => spi_mclk, mosi => spi_mosi);
C3: display_7seg port map(clk => clk, an => an, seg => cat, data_in => data_bus);

end Behavioral;
