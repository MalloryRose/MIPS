-- Jump Address Concatenation Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JumpAddr is
    Port (
        PC_31_28 : in  std_logic_vector(3 downto 0);
        Instr_25_0: in  std_logic_vector(25 downto 0);
        JumpAddr : out std_logic_vector(31 downto 0)
    );
end JumpAddr;

architecture Behavioral of JumpAddr is
begin
    JumpAddr <= PC_31_28 & Instr_25_0 & "00";
end Behavioral;