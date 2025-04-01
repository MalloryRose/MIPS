
-- Instruction Register Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IR is
    Port (
        CLK     : in  std_logic;
        RST     : in  std_logic;  -- Added reset signal
        IRWrite : in  std_logic;
        D       : in  std_logic_vector(31 downto 0);
        Q       : out std_logic_vector(31 downto 0)
    );
end IR;

architecture Behavioral of IR is
    signal ir_reg : std_logic_vector(31 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                ir_reg <= (others => '0');  -- Reset instruction register
            elsif IRWrite = '1' then
                ir_reg <= D;  -- Load the instruction into the register
            end if;
        end if;
    end process;
    
    Q <= ir_reg;  -- Output the current instruction
end Behavioral;