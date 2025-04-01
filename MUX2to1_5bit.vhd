-- 2-to-1 Multiplexer (5-bit) for Register Selection
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2to1_5bit is
    Port (
        A      : in  std_logic_vector(4 downto 0);
        B      : in  std_logic_vector(4 downto 0);
        sel    : in  std_logic;
        output : out std_logic_vector(4 downto 0)
    );
end Mux2to1_5bit;

architecture Behavioral of Mux2to1_5bit is
begin
    output <= A when sel = '0' else B;
end Behavioral;