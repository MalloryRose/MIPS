library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity datapath_tb is
end datapath_tb;

architecture Behavioral of datapath_tb is
    constant CLK_PERIOD : time := 10 ns;
    
    -- Input signals
    signal CLK         : std_logic := '0';
    signal Reset       : std_logic := '1';
    signal PCWrite     : std_logic := '0';
    signal PCWriteCond : std_logic := '0';
    signal IorD        : std_logic := '0';
    signal MemRead     : std_logic := '0';
    signal MemWrite    : std_logic := '0';
    signal MemToReg    : std_logic := '0';
    signal IRWrite     : std_logic := '0';
    signal JumpAndLink : std_logic := '0';
    signal IsSigned    : std_logic := '1';
    signal PCSource    : std_logic_vector(1 downto 0) := "00";
    signal ALUSrcA     : std_logic := '0';
    signal ALUSrcB     : std_logic_vector(1 downto 0) := "00";
    signal ALUOp       : std_logic_vector(1 downto 0) := "00";
    signal RegWrite    : std_logic := '0';
    signal RegDst      : std_logic := '0';
    signal Branch      : std_logic := '0';
    signal inPort0_In  : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort1_In  : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort0_en  : std_logic := '0';
    signal inPort1_en  : std_logic := '0';
    
    -- Output signals
    signal outPort     : std_logic_vector(31 downto 0);
    signal Address     : std_logic_vector(31 downto 0);
    
    -- Debug signals
    signal debug_PC          : std_logic_vector(31 downto 0);
    signal debug_IR          : std_logic_vector(31 downto 0);
    signal debug_RegB        : std_logic_vector(31 downto 0);
    signal debug_ALUResult   : std_logic_vector(31 downto 0);
 
    signal debug_MemData     : std_logic_vector(31 downto 0);
    signal debug_WriteData   : std_logic_vector(31 downto 0);

begin
    -- Instantiate the datapath
    UUT: entity work.datapath
        port map (
            CLK => CLK,
            Reset => Reset,
            PCWrite => PCWrite,
            PCWriteCond => PCWriteCond,
            IorD => IorD,
            MemRead => MemRead,
            MemWrite => MemWrite,
            MemToReg => MemToReg,
            IRWrite => IRWrite,
            JumpAndLink => JumpAndLink,
            IsSigned => IsSigned,
            PCSource => PCSource,
            ALUSrcA => ALUSrcA,
            ALUSrcB => ALUSrcB,
            ALUOp => ALUOp,
            RegWrite => RegWrite,
            RegDst => RegDst,
            Branch => Branch,
            inPort0_In => inPort0_In,
            inPort1_In => inPort1_In,
            inPort0_en => inPort0_en,
            inPort1_en => inPort1_en,
            outPort => outPort,
            Address => Address,
            debug_PC => debug_PC,
            debug_IR => debug_IR,         
            debug_ALUResult => debug_ALUResult,
            debug_MemData => debug_MemData
     
        );

    -- Clock process
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Debug monitoring process
    debug_proc: process(CLK)
        variable l: line;
    begin
        if rising_edge(CLK) then
            write(l, string'("======== Clock Cycle: " & integer'image(now / CLK_PERIOD) & " ========"));
            writeline(output, l);

            write(l, string'("PC: " & integer'image(to_integer(unsigned(debug_PC)))));
            writeline(output, l);

            write(l, string'("Instruction: " & integer'image(to_integer(unsigned(debug_IR)))));
            writeline(output, l);

            write(l, string'("RegB: " & integer'image(to_integer(unsigned(debug_RegB)))));
            writeline(output, l);

            write(l, string'("ALU Result: " & integer'image(to_integer(unsigned(debug_ALUResult)))));
            writeline(output, l);

      
            write(l, string'("Memory Data: " & integer'image(to_integer(unsigned(debug_MemData)))));
            writeline(output, l);

            write(l, string'("Write Data: " & integer'image(to_integer(unsigned(debug_WriteData)))));
            writeline(output, l);

            write(l, string'("OutPort: " & integer'image(to_integer(unsigned(outPort)))));
            writeline(output, l);

            write(l, string'("=========================================="));
            writeline(output, l);
        end if;
    end process;

    -- Test sequence process
    test_proc: process
    begin
        -- Initial reset
        Reset <= '1';
        wait for CLK_PERIOD*2;
        Reset <= '0';
        
        -- Test store word to outPort (0xFFFC)
        PCWrite <= '1';
        MemRead <= '1';
        IRWrite <= '1';
        wait for CLK_PERIOD*2;

        -- Set up memory write operation
		  PCWrite <= '0';
        IorD <= '1';
        MemWrite <= '1';
        inPort0_In <= x"DEADBEEF";  -- Test data
        inPort0_en <= '1';
        wait for CLK_PERIOD*2;

        wait;
    end process;

end Behavioral;