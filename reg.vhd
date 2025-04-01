-- Register Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    Port (
        CLK   : in  std_logic;
        RST   : in  std_logic;  -- Added reset signal
        en    : in  std_logic;
        D     : in  std_logic_vector(31 downto 0);
        Q     : out std_logic_vector(31 downto 0)
    );
end reg;

architecture Behavioral of reg is
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                Q <= (others => '0');  -- Reset all bits to 0
            elsif en = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;