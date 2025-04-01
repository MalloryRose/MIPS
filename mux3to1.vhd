library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux3to1 is
    Port (  A    : in  std_logic_vector(31 downto 0);
			  B    : in  std_logic_vector(31 downto 0);
			  C    : in  std_logic_vector(31 downto 0);
			  sel  : in  std_logic_vector(1 downto 0);
			  output : out std_logic_vector(31 downto 0)
			  );
end mux3to1;

architecture Behavioral of mux3to1 is
begin
    process(A, B, C, sel)
    begin
        case sel is
            when "00" => output <= A;  -- Select A
            when "01" => output <= B;  -- Select B
            when "10" => output <= C;  -- Select C
            when others => output <= A;  -- Default case (error handling)
        end case;
    end process;
end Behavioral;
