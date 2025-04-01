library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips_processor is
    Port (
        -- Primary interfaces
        CLK         : in  std_logic;
        Reset       : in  std_logic;
        inPort0_In  : in  std_logic_vector(31 downto 0);
        inPort1_In  : in  std_logic_vector(31 downto 0);
        inPort0_en  : in  std_logic;
        inPort1_en  : in  std_logic;
        outPort     : out std_logic_vector(31 downto 0);
    
        -- Essential debug signals from datapath
        debug_PC        : out std_logic_vector(31 downto 0);
        debug_IR        : out std_logic_vector(31 downto 0);
        debug_ALUResult : out std_logic_vector(31 downto 0);
        debug_MemData   : out std_logic_vector(31 downto 0);

      
    
        debug_MemRead     : out std_logic;
        debug_MemWrite    : out std_logic;
        debug_RegWrite    : out std_logic;
        debug_MemAddr     : out std_logic_vector(31 downto 0);
        debug_ALUOp       : out std_logic_vector(1 downto 0);
        debug_Branch      : out std_logic;
		  debug_WriteData_Final : out std_logic_vector(31 downto 0);
		  debug_MDR_out : out std_logic_vector(31 downto 0)

    );
end mips_processor;

architecture Behavioral of mips_processor is
    -- Internal control signals
    signal IR_Data       : std_logic_vector(31 downto 0);
    signal PCWrite       : std_logic;
    signal PCWriteCond   : std_logic;
    signal IorD          : std_logic;
    signal MemRead       : std_logic;
    signal MemWrite      : std_logic;
    signal MemToReg      : std_logic;
    signal IRWrite       : std_logic;
    signal JumpAndLink   : std_logic;
    signal IsSigned      : std_logic;
    signal PCSource      : std_logic_vector(1 downto 0);
    signal ALUOp         : std_logic_vector(1 downto 0);
    signal ALUSrcA       : std_logic;
    signal ALUSrcB       : std_logic_vector(1 downto 0);
    signal RegWrite      : std_logic;
    signal RegDst        : std_logic;
    signal Branch        : std_logic;
    
    -- Internal datapath signals
    signal Address       : std_logic_vector(31 downto 0);
    signal ALU_Result    : std_logic_vector(31 downto 0);
    signal Branch_Taken  : std_logic;
    signal Zero          : std_logic;

begin
    -- Controller instance
    controller_inst: entity work.controller
        port map (
            CLK          => CLK,
            Reset        => Reset,
            Opcode       => IR_Data(31 downto 26),
            funct => IR_Data(5 downto 0),
           
           
            PCWrite      => PCWrite,
            PCWriteCond  => PCWriteCond,
            IorD         => IorD,
            MemRead      => MemRead,
            MemWrite     => MemWrite,
            MemToReg     => MemToReg,
            IRWrite      => IRWrite,
            JumpAndLink  => JumpAndLink,
            IsSigned     => IsSigned,
            PCSource     => PCSource,
            ALUSrcA      => ALUSrcA,
            ALUSrcB      => ALUSrcB,
            ALUOp        => ALUOp,
            RegWrite     => RegWrite,
            RegDst       => RegDst
            
        );

    -- Datapath instance
    datapath_inst: entity work.datapath
        port map (
            CLK          => CLK,
            Reset        => Reset,
            PCWrite      => PCWrite,
            PCWriteCond  => PCWriteCond,
            IorD         => IorD,
            MemRead      => MemRead,
            MemWrite     => MemWrite,
            MemToReg     => MemToReg,
            IRWrite      => IRWrite,
            JumpAndLink  => JumpAndLink,
            IsSigned     => IsSigned,
            PCSource     => PCSource,
            ALUSrcA      => ALUSrcA,
            ALUSrcB      => ALUSrcB,
            RegWrite     => RegWrite,
            RegDst       => RegDst,
            ALUOp        => ALUOp,
            Branch       => Branch,
            inPort0_In   => inPort0_In,
            inPort1_In   => inPort1_In,
            inPort0_en   => inPort0_en,
            inPort1_en   => inPort1_en,
            outPort      => outPort,
            Address      => Address,
            debug_PC     => debug_PC,
            debug_IR     => IR_Data,
            debug_ALUResult => ALU_Result,
            debug_MemData   => debug_MemData,
				debug_WriteData_Final => debug_WriteData_Final,
		      debug_MDR_out => debug_MDR_out
        );

    -- Debug signal assignments
    debug_IR        <= IR_Data;
    debug_MemRead   <= MemRead;
    debug_MemWrite  <= MemWrite;
    debug_RegWrite  <= RegWrite;
    debug_MemAddr   <= Address;
    debug_ALUOp     <= ALUOp;
    debug_Branch    <= Branch;

end Behavioral;