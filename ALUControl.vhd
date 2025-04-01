library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is
    Port (
        IR       : in  std_logic_vector(5 downto 0);   
        ALUOp    : in  std_logic_vector(1 downto 0);   
        OPSelect : out std_logic_vector(4 downto 0);   
        HI_en    : out std_logic;                      
        LO_en    : out std_logic;                      
        ALU_LOHI : out std_logic_vector(1 downto 0)    
    );
end ALUControl;

architecture Behavioral of ALUControl is
begin
    process(ALUOp, IR)
    begin
        -- Default values
        OPSelect <= "00000";  
        HI_en <= '0';
        LO_en <= '0';
        ALU_LOHI <= "00";     

        case ALUOp is
            when "00" =>   -- Memory operations (LW/SW)
                OPSelect <= "00000";  

            when "01" =>   -- Branch operations
                if IR = "000100" then
                    OPSelect <= "10000";     -- BEQ
                elsif IR = "000101" then
                    OPSelect <= "10001";     -- BNE
                elsif IR = "000110" then
                    OPSelect <= "10010";     -- BLEZ
                elsif IR = "000111" then
                    OPSelect <= "10011";     -- BGTZ
                elsif IR = "000001" then
                    OPSelect <= "10100";     -- BLTZ
                else
                    OPSelect <= "00000";
                end if;

            when "10" =>   -- R-type instructions
                if IR = "100000" then
                    OPSelect <= "00000";     -- ADD
                elsif IR = "100010" then
                    OPSelect <= "00001";     -- SUB
                elsif IR = "011000" then     -- MULT
                    OPSelect <= "00010";
                    HI_en <= '1';
                    LO_en <= '1';
                elsif IR = "011001" then     -- MULTU
                    OPSelect <= "00011";
                    HI_en <= '1';
                    LO_en <= '1';
                elsif IR = "100100" then
                    OPSelect <= "00100";     -- AND
                elsif IR = "100101" then
                    OPSelect <= "00101";     -- OR
                elsif IR = "100110" then
                    OPSelect <= "00110";     -- XOR
                elsif IR = "000010" then
                    OPSelect <= "00111";     -- SRL
                elsif IR = "000000" then
                    OPSelect <= "01000";     -- SLL
                elsif IR = "000011" then
                    OPSelect <= "01001";     -- SRA
                elsif IR = "101010" then
                    OPSelect <= "01010";     -- SLT
                elsif IR = "101011" then
                    OPSelect <= "01011";     -- SLTU
                elsif IR = "010000" then     -- MFHI
                    OPSelect <= "01100";
                    ALU_LOHI <= "10";
                elsif IR = "010010" then     -- MFLO
                    OPSelect <= "01101";
                    ALU_LOHI <= "01";
                elsif IR = "001000" then
                    OPSelect <= "01110";     -- JR
                else
                    OPSelect <= "00000";
                end if;

            when "11" =>   -- I-type instructions
                if IR = "001000" then
                    OPSelect <= "00000";     -- ADDI
                elsif IR = "001100" then
                    OPSelect <= "00100";     -- ANDI
                elsif IR = "001101" then
                    OPSelect <= "00101";     -- ORI
                elsif IR = "001110" then
                    OPSelect <= "00110";     -- XORI
                elsif IR = "001010" then
                    OPSelect <= "01010";     -- SLTI
                elsif IR = "001011" then
                    OPSelect <= "01011";     -- SLTIU
                else
                    OPSelect <= "00000";
                end if;

            when others =>
                OPSelect <= "00000";
        end case;
    end process;
end Behavioral;