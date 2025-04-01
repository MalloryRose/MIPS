library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MUX2to1 is
    Port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        sel : in std_logic;
        output : out std_logic_vector(31 downto 0)
    );
end MUX2to1;

architecture Behavioral of MUX2to1 is
begin
    process(A, B, sel)
    begin
        if sel = '0' then
            output <= A;
        else
            output <= B;
        end if;
    end process;
end Behavioral;
