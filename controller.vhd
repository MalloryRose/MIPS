library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity controller is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        opcode : in STD_LOGIC_VECTOR(5 downto 0);
        funct : in STD_LOGIC_VECTOR(5 downto 0); 
        
        MemRead : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        IorD : out STD_LOGIC;
        IRWrite : out STD_LOGIC;
        PCWrite : out STD_LOGIC;
        PCWriteCond : out STD_LOGIC;
        PCSource : out STD_LOGIC_VECTOR(1 downto 0);
        ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
        ALUSrcA : out STD_LOGIC;
        ALUSrcB : out STD_LOGIC_VECTOR(1 downto 0);
        IsSigned : out STD_LOGIC;
        JumpAndLink : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        RegDst : out STD_LOGIC
    );
end controller;

architecture Behavioral of controller is
    type state_type is (
        S0_Fetch,           -- State 0: Instruction fetch
        S01_Wait,
        S1_Decode,         -- State 1: Instruction decode/register fetch
        S2_MemAddr,        -- State 2: Memory address computation
        S3_MemRead,        -- State 3: Memory access for load
        S34_Wait,
        S4_MemWriteback,   -- State 4: Memory read completion
        S5_MemWrite,       -- State 5: Memory access for store
        S6_Execute,        -- State 6: R-type execution
        S67_Wait,
        S7_RTypeComplete,  -- State 7: R-type completion
        S8_IExecute,       -- State 8: I-type execution
        S89_Wait,
        S9_ITypeComplete,  -- State 9: I-type completion
        S10_Jump           -- State 10: Jump completion
    );
    
    signal current_state, next_state : state_type;
    
begin
    -- State register
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= S0_Fetch;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Next state logic and output logic
    process(current_state, opcode)
    begin
        -- Default values
        MemRead <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        IorD <= '0';
        IRWrite <= '0';
        PCWrite <= '0';
        PCWriteCond <= '0';
        PCSource <= "00";
        ALUOp <= "00";
        ALUSrcA <= '0';
        ALUSrcB <= "00";
        RegWrite <= '0';
        RegDst <= '0';
        JumpAndLink <= '0';
        IsSigned <= '0';
        
        case current_state is
            when S0_Fetch =>
                -- Match state 0 from ASM chart
                MemRead <= '1';
                IRWrite <= '1';
                ALUSrcA <= '0';
                IorD <= '0';
                ALUSrcB <= "01";  -- Increment PC by 4
                ALUOp <= "00";    -- Add
                PCWrite <= '1';
                PCSource <= "00";  -- From ALU
                next_state <= S01_Wait;
                
            when S01_Wait =>
                IRWrite <= '1';
                MemRead <= '1';
                next_state <= S1_Decode;
                
            when S1_Decode =>
                -- Match state 1 from ASM chart
                ALUSrcA <= '0';
                ALUSrcB <= "11";  -- Sign-extended, shifted immediate
                ALUOp <= "00";
                
                case opcode is
                    when "000010" => -- J-type (jump)
                        next_state <= S10_Jump;
                    when "100011" | "101011" => -- LW or SW
                        next_state <= S2_MemAddr;
                    when "000000" => -- R-type
                        next_state <= S6_Execute;
                    when others =>
                        next_state <= S8_IExecute;
                end case;
                
            when S2_MemAddr =>
                -- Match state 2 from ASM chart
                ALUSrcA <= '1';
                ALUSrcB <= "10";  -- Sign-extended immediate
                ALUOp <= "00";    -- Add
                
                if opcode = "100011" then    -- LW
                    next_state <= S3_MemRead;
                else                         -- SW
                    next_state <= S5_MemWrite;
                end if;
                
            when S3_MemRead =>
                -- Match state 3 from ASM chart
                MemRead <= '1';
                IorD <= '1';
                next_state <= S34_Wait;
                
            when S34_Wait =>
                MemRead <= '1';
                next_state <= S4_MemWriteback;
                
            when S4_MemWriteback =>
                -- Match state 4 from ASM chart
                RegWrite <= '1';
                RegDst <= '0';    -- rt field
                MemtoReg <= '1';  -- From memory
                next_state <= S0_Fetch;
                
            when S5_MemWrite =>
                -- Match state 5 from ASM chart
                MemWrite <= '1';
                IorD <= '1';
                next_state <= S0_Fetch;
                
            when S6_Execute =>
                -- Match state 6 from ASM chart
                ALUSrcA <= '1';
                ALUSrcB <= "00";  -- From register
                ALUOp <= "10";    -- Determined by function field
                MemtoReg <= '1';
                next_state <= S67_Wait;
                
            when S67_Wait =>
                ALUSrcA <= '1';
                ALUSrcB <= "00";  -- From register
                ALUOp <= "10";    -- Determined by function field
                MemtoReg <= '0';
                next_state <= S7_RTypeComplete;
                
            when S7_RTypeComplete =>
                -- Match state 7 from ASM chart
                ALUSrcA <= '1';
                ALUSrcB <= "00";  -- From register
                ALUOp <= "10";    -- Determined by function field
                RegWrite <= '1';
                RegDst <= '1';    -- rd field
                MemtoReg <= '0';  -- From ALU
                next_state <= S0_Fetch;
                
            when S8_IExecute =>
                -- Match state 8 from ASM chart
                ALUSrcA <= '1';
                ALUSrcB <= "10";  -- From register
                ALUOp <= "11";    -- Determined by function field
                next_state <= S89_Wait;
                
            when S89_Wait =>
                ALUSrcA <= '1';
                ALUSrcB <= "10";  -- From register
                ALUOp <= "11";    -- Determined by function field
                next_state <= S9_ITypeComplete;
                
            when S9_ITypeComplete =>
                -- Match state 9 from ASM chart
                RegWrite <= '1';
                RegDst <= '0';    -- rt field
                MemtoReg <= '0';  -- From ALU
                next_state <= S0_Fetch;

            when S10_Jump =>
                -- State 10: Jump completion
                PCWrite <= '1';
                PCSource <= "10";  -- Select jump target address
                next_state <= S0_Fetch;
                
        end case;
    end process;
    
end Behavioral;