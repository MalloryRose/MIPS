library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity mips_processor_tb is
end mips_processor_tb;

architecture Behavioral of mips_processor_tb is
    constant CLK_PERIOD : time := 10 ns;
    
    -- Primary interface signals
    signal CLK          : std_logic := '0';
    signal Reset        : std_logic := '1';
    signal inPort0_In   : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort1_In   : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort0_en   : std_logic := '0';
    signal inPort1_en   : std_logic := '0';
    signal outPort      : std_logic_vector(31 downto 0);
    
    -- Essential debug signals from datapath
    signal debug_PC        : std_logic_vector(31 downto 0);
    signal debug_IR        : std_logic_vector(31 downto 0);
    signal debug_ALUResult : std_logic_vector(31 downto 0);
    signal debug_MemData   : std_logic_vector(31 downto 0);

    -- Essential control and state signals
    signal debug_CurrentState : std_logic_vector(3 downto 0);
    signal debug_MemRead     : std_logic;
    signal debug_MemWrite    : std_logic;
    signal debug_RegWrite    : std_logic;
    signal debug_MemAddr     : std_logic_vector(31 downto 0);
    signal debug_ALUOp       : std_logic_vector(1 downto 0);
    signal debug_Branch      : std_logic;
	 
	  signal debug_WriteData_Final : std_logic_vector(31 downto 0);
		signal   debug_MDR_out :  std_logic_vector(31 downto 0);

begin
    -- Unit Under Test instantiation
    UUT: entity work.mips_processor
        port map (
            -- Primary interfaces
            CLK         => CLK,
            Reset       => Reset,
            inPort0_In  => inPort0_In,
            inPort1_In  => inPort1_In,
            inPort0_en  => inPort0_en,
            inPort1_en  => inPort1_en,
            outPort     => outPort,
            
            -- Debug signals
            debug_PC           => debug_PC,
            debug_IR          => debug_IR,
            debug_ALUResult   => debug_ALUResult,
            debug_MemData     => debug_MemData,
            debug_MemRead     => debug_MemRead,
            debug_MemWrite    => debug_MemWrite,
            debug_RegWrite    => debug_RegWrite,
            debug_MemAddr     => debug_MemAddr,
            debug_ALUOp       => debug_ALUOp,
            debug_Branch      => debug_Branch,
				debug_WriteData_Final => debug_WriteData_Final,
		      debug_MDR_out => debug_MDR_out
        );

    -- Clock generation process
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stimulus_proc: process
        variable l: line;
    begin
        -- Initialize with reset
        Reset <= '1';
        wait for CLK_PERIOD * 2;
        
        -- Release reset and write initialization message
        Reset <= '0';
        write(l, string'("Starting Deliverable 5 Program Execution"));
        writeline(output, l);
        
        -- Set input port values
        inPort0_In <= x"0000000C";  -- Initial test value
        inPort0_en <= '1';
        wait for CLK_PERIOD;
        inPort0_en <= '0';
        
        inPort1_In <= x"FAFAFAFA";  -- Second test value
        inPort1_en <= '1';
        wait for CLK_PERIOD;
        inPort1_en <= '0';

        -- Allow program to execute
        wait for CLK_PERIOD * 100;
        
        write(l, string'("Program Execution Complete"));
        writeline(output, l);
        wait;
    end process;

    -- Monitor process for execution tracking
    monitor_proc: process(CLK)
        variable l: line;
    begin
        if rising_edge(CLK) then
            -- Time and state information
            write(l, string'("Time: " & time'image(now)));
            writeline(output, l);
            
            write(l, string'("Current State: " & integer'image(to_integer(unsigned(debug_CurrentState)))));
            writeline(output, l);
            
            -- Instruction execution tracking
            write(l, string'("PC: " & integer'image(to_integer(unsigned(debug_PC)))));
            writeline(output, l);
            
            write(l, string'("Instruction: " & integer'image(to_integer(unsigned(debug_IR)))));
            writeline(output, l);
            
            -- Memory operations
            if debug_MemWrite = '1' then
                write(l, string'("Memory Write - Address: " & integer'image(to_integer(unsigned(debug_MemAddr)))));
                write(l, string'(" Data: " & integer'image(to_integer(unsigned(debug_MemData)))));
                writeline(output, l);
            end if;
            
            -- ALU operations
            write(l, string'("ALU Result: " & integer'image(to_integer(unsigned(debug_ALUResult)))));
            writeline(output, l);
            
            -- Register operations
            if debug_RegWrite = '1' then
                write(l, string'("Register Write Enabled - ALU Result: " & integer'image(to_integer(unsigned(debug_ALUResult)))));
                writeline(output, l);
            end if;
            
            write(l, string'("-----------------------------------------"));
            writeline(output, l);
        end if;
    end process;

end Behavioral;