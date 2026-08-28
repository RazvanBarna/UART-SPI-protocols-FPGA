

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity sim is
--  Port ( );
end sim;

architecture Behavioral of sim is
component test_uart is
  Port (
        clk, rx : in std_logic;
        tx,err : out std_logic
         );
end component;

signal rx,tx,clk,err : std_logic :='0';

begin

process
begin
clk<='0';
wait for 5 ns;
clk<= '1';
wait for 5 ns;
end process;

C0: test_uart port map(clk => clk,rx => rx, tx =>tx, err =>err);

s: process
begin

rx <= '1';
wait for 1 ns;
rx <= '0';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;
rx <= '1';
wait for 1 ns;

end process;

end Behavioral;
