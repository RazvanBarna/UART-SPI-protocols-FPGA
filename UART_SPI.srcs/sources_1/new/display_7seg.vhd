library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity display_7seg is
  Port (
      clk: in std_logic;
      an: out std_logic_vector(3 downto 0);
      seg: out std_logic_vector(6 downto 0);
      data_in: in std_logic_vector(7 downto 0)
    );
end display_7seg;

architecture Behavioral of display_7seg is
signal refresh : std_logic_vector(19 downto 0) := (others => '0');
signal led_sel: std_logic_vector(1 downto 0) := "00";
signal hex_digit: std_logic_vector(3 downto 0) := "0000";
begin

process(clk)
begin
    if rising_edge(clk) then 
        refresh <= refresh + 1;
    end if;
end process;

led_sel <= refresh(19 downto 18); --freq div

process(led_sel, data_in)
    begin
        case led_sel is
            when "00" => 
                an <= "1110"; 
                hex_digit <= data_in(3 downto 0);
            when "01" => 
                an <= "1101"; -- Aprindem cifra 1
                hex_digit <= data_in(7 downto 4); 
            when "10" => 
                an <= "1011"; 
                hex_digit <= "0000"; 
            when "11" => 
                an <= "0111";
                hex_digit <= "0000"; 
            when others => 
                an <= "1111";
                hex_digit <= "0000";
        end case;
    end process;
    
process(hex_digit)
    begin
        case hex_digit is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when "1010" => seg <= "0001000"; -- A
            when "1011" => seg <= "0000011"; -- B
            when "1100" => seg <= "1000110"; -- C
            when "1101" => seg <= "0100001"; -- D
            when "1110" => seg <= "0000110"; -- E
            when "1111" => seg <= "0001110"; -- F
            when others => seg <= "1111111";
        end case;
    end process;


end Behavioral;
