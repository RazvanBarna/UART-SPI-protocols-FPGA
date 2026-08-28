
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity clock_div is
    Port (clk: in std_logic;
          clk_out: out std_logic );
end clock_div;

architecture Behavioral of clock_div is
--signal aux : std_logic_vector(9 downto 0):=(others =>'0');
signal aux : integer :=0;
signal aux_out : std_logic :='0';

begin
process(clk)
begin
    if rising_edge(clk) then
        if aux = 54 then 
            aux <= 0;
            aux_out <='1';
            else
                 aux_out <='0'; 
                 aux <= aux +1;
        end if;
        end if;
        end process;

clk_out <=aux_out;

end Behavioral;
