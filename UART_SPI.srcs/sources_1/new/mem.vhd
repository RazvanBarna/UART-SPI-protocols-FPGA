library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity mem is
  Port (
       instr: in std_logic_vector(23 downto 0);
       clk: in std_logic;
       data: out std_logic_vector(7 downto 0)
     );
end mem;

architecture Behavioral of mem is
type metrix is array(0 to 31) of std_logic_vector(7 downto 0);
signal M: metrix := (
    0 => X"AA", 
    1 => X"BB", 
    2 => X"CC", 
    3 => X"DD", 
    others => (others => '0') 
);
signal address, t_instr, data_instr: std_logic_vector(7 downto 0) := (others => '0');

begin
t_instr <= instr(23 downto 16);
address <= instr(15 downto 8);
data_instr <= instr(7 downto 0);

process(clk)
begin
    if rising_edge(clk) then 
       if t_instr = X"52" or t_instr = X"72" then
            data <= M(conv_integer(address));
       elsif t_instr = X"57" or t_instr = X"77" then
            M(conv_integer(address)) <= data_instr;
            data <= data_instr;
       else 
            data <= M(0);
    end if;
    end if;

end process;


end Behavioral;
