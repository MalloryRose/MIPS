
-- Memory Data Register Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MDR is
    Port (
        CLK : in  std_logic;
        RST : in  std_logic;  -- Added reset signal
        D   : in  std_logic_vector(31 downto 0);
        Q   : out std_logic_vector(31 downto 0)
    );
end MDR;

architecture Behavioral of MDR is
    signal mdr_reg : std_logic_vector(31 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                mdr_reg <= (others => '0');  -- Reset the register
            else
                mdr_reg <= D;  -- Load the data from D into the MDR on clock edge
            end if;
        end if;
    end process;
    Q <= mdr_reg;  -- Output the current value of the MDR
end Behavioral;