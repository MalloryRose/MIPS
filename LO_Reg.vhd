-- LO Register Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LO_Reg is
    Port (
        CLK   : in  std_logic;
        LO_en : in  std_logic;
        D     : in  std_logic_vector(31 downto 0);
        Q     : out std_logic_vector(31 downto 0)
    );
end LO_Reg;

architecture Behavioral of LO_Reg is
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if LO_en = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;