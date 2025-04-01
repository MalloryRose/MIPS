library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder is
    Port (
        A : in  std_logic_vector(31 downto 0);
        B : in  std_logic_vector(31 downto 0);
        Y : out std_logic_vector(31 downto 0)
    );
end Adder;

architecture Behavioral of Adder is
begin
    Y <= std_logic_vector(unsigned(A) + unsigned(B));
end Behavioral;