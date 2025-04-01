library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
    Port ( 
        CLK         : in  STD_LOGIC;
        RST         : in  STD_LOGIC;  -- Added reset signal
        memRead     : in  STD_LOGIC;
        memWrite    : in  STD_LOGIC;
        baddr       : in  STD_LOGIC_VECTOR(31 downto 0);
        dataOut     : out STD_LOGIC_VECTOR(31 downto 0);
        dataIn      : in  STD_LOGIC_VECTOR(31 downto 0);
        inPort0_In  : in  STD_LOGIC_VECTOR(31 downto 0);
        inPort1_In  : in  STD_LOGIC_VECTOR(31 downto 0);
        outPort     : out STD_LOGIC_VECTOR(31 downto 0);
        inPort0_en  : in  STD_LOGIC;
        inPort1_en  : in  STD_LOGIC
    );
end Memory;

architecture Behavioral of Memory is
    component RAM
        Port ( 
            address  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock    : IN  STD_LOGIC := '1';
            data     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
            wren     : IN  STD_LOGIC;
            q        : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;

    signal ramDataOut : std_logic_vector(31 downto 0);
    signal outPort_reg : std_logic_vector(31 downto 0);
    signal ram_write_en : std_logic;
    
begin
    -- RAM write enable only when address is in RAM range and memWrite is active
    ram_write_en <= '1' when (memWrite = '1' and baddr /= x"0000FFF8" and 
                             baddr /= x"0000FFFC") else '0';

    RAM_inst : RAM
        Port map (
            address => baddr(9 downto 2),
            clock   => clk,
            data    => dataIn,
            wren    => ram_write_en,
            q       => ramDataOut
        );

    process(CLK)
    begin
        if rising_edge(clk) then
            if RST = '1' then
                outPort_reg <= (others => '0');
                dataOut <= (others => '0');
            else
                -- Memory read operations
                if memRead = '1' then
                    case baddr is
                        when x"0000FFF8" =>  -- INPORT0
                            if inPort0_en = '1' then
                                dataOut <= inPort0_In;
                            end if;
                        when x"0000FFFC" =>  -- INPORT1
                            if inPort1_en = '1' then
                                dataOut <= inPort1_In;
                            end if;
                        when others =>
                            dataOut <= ramDataOut;
                    end case;
                end if;

                -- Memory write operations
                if memWrite = '1' then
                    if baddr = x"0000FFFC" then  -- OUTPORT
                        outPort_reg <= dataIn;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Continuous assignment for outPort
    outPort <= outPort_reg;

end Behavioral;