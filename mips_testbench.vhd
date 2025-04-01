library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
use IEEE.NUMERIC_BIT.ALL;        -- Add this package
use IEEE.NUMERIC_BIT_UNSIGNED.ALL;  -- Add this package

entity mips_testbench is
end mips_testbench;

architecture Behavioral of mips_testbench is
    -- Component Declaration
    component mips_processor is
        Port (
            CLK         : in  std_logic;
            Reset       : in  std_logic;
            inPort0_In  : in  std_logic_vector(31 downto 0);
            inPort1_In  : in  std_logic_vector(31 downto 0);
            inPort0_en  : in  std_logic;
            inPort1_en  : in  std_logic;
            outPort     : out std_logic_vector(31 downto 0);
            -- Debug ports
            debug_PC           : out std_logic_vector(31 downto 0);
            debug_IR           : out std_logic_vector(31 downto 0);
            debug_MemRead      : out std_logic;
            debug_MemWrite     : out std_logic;
            debug_MemAddr      : out std_logic_vector(31 downto 0);
            debug_MemData      : out std_logic_vector(31 downto 0);
            debug_ALUResult    : out std_logic_vector(31 downto 0);
            debug_RegWriteEn   : out std_logic;
            debug_CurrentState : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

    -- Test bench signals
    signal CLK         : std_logic := '0';
    signal Reset       : std_logic := '1';
    signal inPort0_In  : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort1_In  : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort0_en  : std_logic := '0';
    signal inPort1_en  : std_logic := '0';
    signal outPort     : std_logic_vector(31 downto 0);

    -- Debug signals
    signal debug_PC           : std_logic_vector(31 downto 0);
    signal debug_IR           : std_logic_vector(31 downto 0);
    signal debug_MemRead      : std_logic;
    signal debug_MemWrite     : std_logic;
    signal debug_MemAddr      : std_logic_vector(31 downto 0);
    signal debug_MemData      : std_logic_vector(31 downto 0);
    signal debug_ALUResult    : std_logic_vector(31 downto 0);
    signal debug_RegWriteEn   : std_logic;
    signal debug_CurrentState : std_logic_vector(3 downto 0);

    -- File handle for detailed logging
    file debug_file: TEXT open WRITE_MODE is "mips_debug.txt";

begin
    -- Clock process
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Instantiate the Unit Under Test (UUT)
    UUT: mips_processor port map (
        CLK               => CLK,
        Reset             => Reset,
        inPort0_In        => inPort0_In,
        inPort1_In        => inPort1_In,
        inPort0_en        => inPort0_en,
        inPort1_en        => inPort1_en,
        outPort           => outPort,
        debug_PC          => debug_PC,
        debug_IR          => debug_IR,
        debug_MemRead     => debug_MemRead,
        debug_MemWrite    => debug_MemWrite,
        debug_MemAddr     => debug_MemAddr,
        debug_MemData     => debug_MemData,
        debug_ALUResult   => debug_ALUResult,
        debug_RegWriteEn  => debug_RegWriteEn,
        debug_CurrentState=> debug_CurrentState
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        Reset <= '1';
        inPort0_In <= (others => '0');
        inPort1_In <= (others => '0');
        inPort0_en <= '0';
        inPort1_en <= '0';

        wait for 100 ns;
        Reset <= '0';
        wait for CLK_PERIOD;

        -- Test Case 1: Load value into inPort0
        inPort0_In <= x"0000_000A";
        inPort0_en <= '1';
        wait for CLK_PERIOD;
        inPort0_en <= '0';
        wait for CLK_PERIOD * 5;

        -- Test Case 2: Load value into inPort1
        inPort1_In <= x"0000_000F";
        inPort1_en <= '1';
        wait for CLK_PERIOD;
        inPort1_en <= '0';
        wait for CLK_PERIOD * 5;

        wait for CLK_PERIOD * 50;
        wait;
    end process;

   monitor_proc: process(CLK)
        variable l : line;
    begin
        if rising_edge(CLK) then
            write(l, string'("Time: " & time'image(now)));
            writeline(debug_file, l);
            
            write(l, string'("State: " & to_string(to_integer(unsigned(debug_CurrentState)))));
            writeline(debug_file, l);
            
            write(l, string'("PC: " & to_string(to_integer(unsigned(debug_PC)))));
            writeline(debug_file, l);
            
            write(l, string'("IR: " & to_string(to_integer(unsigned(debug_IR)))));
            writeline(debug_file, l);
            
            write(l, string'("MemRead: " & std_logic'image(debug_MemRead) & 
                           " MemWrite: " & std_logic'image(debug_MemWrite)));
            writeline(debug_file, l);
            
            write(l, string'("MemAddr: " & to_string(to_integer(unsigned(debug_MemAddr))) & 
                           " MemData: " & to_string(to_integer(unsigned(debug_MemData)))));
            writeline(debug_file, l);
            
            write(l, string'("ALU Result: " & to_string(to_integer(unsigned(debug_ALUResult)))));
            writeline(debug_file, l);
            
            write(l, string'("RegWriteEn: " & std_logic'image(debug_RegWriteEn)));
            writeline(debug_file, l);
            
            write(l, string'("OutPort: " & to_string(to_integer(unsigned(outPort)))));
            writeline(debug_file, l);
            
            write(l, string'("-----------------------------------------"));
            writeline(debug_file, l);
        end if;
    end process;

end Behavioral;