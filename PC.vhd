library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port (
        CLK     : in  std_logic;
        Reset   : in  std_logic;
        PCWrite : in  std_logic;
        D       : in  std_logic_vector(31 downto 0);
        Q       : out std_logic_vector(31 downto 0)
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(CLK, Reset)
    begin
        if Reset = '1' then
            pc_reg <= (others => '0');  -- Reset the PC to 0 on reset
        elsif rising_edge(CLK) then
            if PCWrite = '1' then
                pc_reg <= D;  -- Load the value of D into the program counter
--            else
--                pc_reg <= pc_reg + 1;  -- Increment the program counter on each clock cycle
            end if;
        end if;
    end process;

    Q <= pc_reg;  -- Output the value of the program counter
end Behavioral;
