library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZeroExtend is
    Port (
        input  : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0)
    );
end ZeroExtend;

architecture Behavioral of ZeroExtend is
begin
    output <= x"0000" & input;
end Behavioral;