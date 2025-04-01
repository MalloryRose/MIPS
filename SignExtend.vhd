-- Sign Extension Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtend is
    Port (
        D        : in  std_logic_vector(15 downto 0);
        IsSigned : in  std_logic;
        Q        : out std_logic_vector(31 downto 0)
    );
end SignExtend;

architecture Behavioral of SignExtend is
begin
    Q <= (31 downto 16 => D(15)) & D when IsSigned = '1' else
         x"0000" & D;
end Behavioral;
