-- Shift Left 2 Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftLeft2 is
    Port (
        D : in  std_logic_vector(31 downto 0);
        Q : out std_logic_vector(31 downto 0)
    );
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin
    Q <= D(29 downto 0) & "00";
end Behavioral;