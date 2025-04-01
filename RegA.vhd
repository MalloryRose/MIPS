-- Register A Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegA is
    Port (
        CLK : in  std_logic;
        D   : in  std_logic_vector(31 downto 0);
        Q   : out std_logic_vector(31 downto 0)
    );
end RegA;

architecture Behavioral of RegA is
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            Q <= D;
        end if;
    end process;
end Behavioral;