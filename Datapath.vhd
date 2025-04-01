library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
	
    Port (
        CLK         : in  std_logic;
        Reset       : in  std_logic;
        PCWrite     : in  std_logic;
        PCWriteCond : in  std_logic;
        IorD        : in  std_logic;
        MemRead     : in  std_logic;
        MemWrite    : in  std_logic;
        MemToReg    : in  std_logic;
        IRWrite     : in  std_logic;
        JumpAndLink : in  std_logic;
        IsSigned    : in  std_logic;
        PCSource    : in  std_logic_vector(1 downto 0);
        ALUSrcA     : in  std_logic;
        ALUSrcB     : in  std_logic_vector(1 downto 0);
        RegWrite    : in  std_logic;
        RegDst      : in  std_logic;
        ALUOp       : in  std_logic_vector(1 downto 0);
        Branch      : in  std_logic;
        inPort0_In  : in  std_logic_vector(31 downto 0);
        inPort1_In  : in  std_logic_vector(31 downto 0);
        inPort0_en  : in  std_logic;
        inPort1_en  : in  std_logic;
        outPort     : out std_logic_vector(31 downto 0);
        Address     : out std_logic_vector(31 downto 0);
		  


        debug_PC          : out std_logic_vector(31 downto 0);
        debug_IR          : out std_logic_vector(31 downto 0);
        debug_ALUResult   : out std_logic_vector(31 downto 0);
        debug_MemData     : out std_logic_vector(31 downto 0);
		  debug_WriteData_Final : out std_logic_vector(31 downto 0);
		  debug_MDR_out : out std_logic_vector(31 downto 0)
       
        
   
		
       
		  
		  
    );
end datapath;

architecture Behavioral of datapath is

    -- Control Signals
    signal HI_Enable      : std_logic;
    signal LO_Enable      : std_logic;

    -- Data Path Signals
    signal PC_Out         : std_logic_vector(31 downto 0);
    signal PC_Next        : std_logic_vector(31 downto 0);
    signal IR_Out         : std_logic_vector(31 downto 0);
    signal RegA_Out       : std_logic_vector(31 downto 0);
    signal RegB_Out       : std_logic_vector(31 downto 0);
    signal ALU_Result     : std_logic_vector(31 downto 0);
    signal ALU_HI_Result  : std_logic_vector(31 downto 0);
    signal HI_Reg_Out     : std_logic_vector(31 downto 0);
    signal LO_Reg_Out     : std_logic_vector(31 downto 0);
    signal Sign_Ext_Out   : std_logic_vector(31 downto 0);
    signal Shift_Left2_Out: std_logic_vector(31 downto 0);
    signal Jump_Addr_Out  : std_logic_vector(31 downto 0);
    signal ALU_SrcA_Out   : std_logic_vector(31 downto 0);
    signal ALU_SrcB_Out   : std_logic_vector(31 downto 0);
    signal WriteReg_Addr  : std_logic_vector(4 downto 0);
    signal MemAddress     : std_logic_vector(31 downto 0);
    signal MemDataOut     : std_logic_vector(31 downto 0);
    signal MDR_Out        : std_logic_vector(31 downto 0);
    signal Branch_Taken   : std_logic;
    signal Read_Data0     : std_logic_vector(31 downto 0);
    signal Read_Data1     : std_logic_vector(31 downto 0);
    signal Write_Data     : std_logic_vector(31 downto 0);
    signal WriteData_Final: std_logic_vector(31 downto 0);
    signal ALU_Control_Out: std_logic_vector(4 downto 0);
    signal ALU_LO_HI_Out  : std_logic_vector(1 downto 0);
    signal ALUOut_Out     : std_logic_vector(31 downto 0);
	 signal ZeroExt_Out         : std_logic_vector(31 downto 0);
	 signal ShiftLeft2_Jump_Out : std_logic_vector(31 downto 0);  -- For jump address calculation
	  -- Add this assignment before the PC instantiation
    signal PC_Enable : std_logic;
	 signal Jump_Shift_Input : std_logic_vector(31 downto 0);
	

begin

	 -- Debug signal assignments
    debug_PC          <= PC_Out;
    debug_IR          <= IR_Out;
    debug_ALUResult   <= ALU_Result;
    debug_MemData     <= MemDataOut;
	 debug_WriteData_Final <= WriteData_Final;
	 debug_MDR_Out <= MDR_Out;
	 
    

		 
	 
	PC_Enable <= PCWrite or (PCWriteCond and Branch_Taken);
	 Jump_Shift_Input <= IR_Out(25 downto 0) & "000000";
	
	
	
    -- Program Counter
    pc_reg: entity work.PC
        port map (
            CLK     => CLK,
            Reset   => Reset,
            PCWrite => PC_Enable,
            D       => PC_Next,
            Q       => PC_Out
        );

    -- IorD Multiplexer
    iord_mux: entity work.Mux2to1
        port map (
            A      => PC_Out,
            B      => ALUOut_Out,
            sel    => IorD,
            output => MemAddress
        );

    -- Memory Module
    memory_inst: entity work.Memory
        port map (
            CLK        => CLK,
				RST			=> Reset,
            memRead    => MemRead,
            memWrite   => MemWrite,
            baddr      => MemAddress,
            dataOut    => MemDataOut,
            dataIn     => RegB_Out,
            inPort0_In => inPort0_In,
            inPort1_In => inPort1_In,
            outPort    => outPort,
            inPort0_en => inPort0_en,
            inPort1_en => inPort1_en
        );

    -- Instruction Register
    ir_reg: entity work.IR
        port map (
            CLK     => CLK,
				RST	  => Reset,
            IRWrite => IRWrite,
            D       => MemDataOut,
            Q       => IR_Out
        );

    -- Register File with corrected connections
    register_file: entity work.RegisterFile
        port map (
            clk         => CLK,
            rst         => Reset,
            rd_addr0    => IR_Out(25 downto 21),
            rd_addr1    => IR_Out(20 downto 16),
            wr_addr     => WriteReg_Addr,
            wr_en       => RegWrite,
            wr_data     => WriteData_Final,
            rd_data0    => Read_Data0,
            rd_data1    => Read_Data1,
            PC_4        => ALU_Result,
            JumpAndLink => JumpAndLink
        );

    -- Register A
    reg_a: entity work.Reg
        port map (
            CLK => CLK,
				RST => Reset,
            en  => '1',
            D   => Read_Data0,
            Q   => RegA_Out
        );

    -- Register B
    reg_b: entity work.Reg
        port map (
            CLK => CLK,
				RST => Reset,
            en  => '1',
            D   => Read_Data1,
            Q   => RegB_Out
        );

    -- Memory Data Register
    mdr: entity work.MDR
        port map (
            CLK => CLK,
				RST => Reset,
            D   => MemDataOut,
            Q   => MDR_Out
        );

    -- HI Register
    hi_reg: entity work.Reg
        port map (
            CLK => CLK,
				RST => Reset,
            en  => HI_Enable,
            D   => ALU_HI_Result,
            Q   => HI_Reg_Out
        );

    -- LO Register
    lo_reg: entity work.Reg
        port map (
            CLK => CLK,
				RST => Reset,
            en  => LO_Enable,
            D   => ALU_Result,
            Q   => LO_Reg_Out
        );

    -- ALUOut Register
    alu_out_reg: entity work.Reg
        port map (
            CLK => CLK,
				RST => Reset,
            en  => '1',
            D   => ALU_Result,
            Q   => ALUOut_Out
        );

    -- ALU Control
    alu_control: entity work.ALUControl
        port map (
            IR       => IR_Out(5 downto 0),
            ALUOp    => ALUOp,
            OPSelect => ALU_Control_Out,
            ALU_LOHI => ALU_LO_HI_Out,
            HI_en    => HI_Enable,
            LO_en    => LO_Enable
        );

    -- Main ALU
    main_alu: entity work.ALU
        port map (
            A           => ALU_SrcA_Out,
            B           => ALU_SrcB_Out,
            sel         => ALU_Control_Out,
            IR          => IR_Out(10 downto 6),
            result      => ALU_Result,
            result_HI   => ALU_HI_Result,
            branchTaken => Branch_Taken
        );

    -- Sign Extension
    sign_extend: entity work.SignExtend
        port map (
            D        => IR_Out(15 downto 0),
            IsSigned => IsSigned,
            Q        => Sign_Ext_Out
        );

    -- Shift Left 2
    shift_left2: entity work.ShiftLeft2
        port map (
            D => Sign_Ext_Out,
            Q => Shift_Left2_Out
        );
		  
		 -- Zero Extension
	zero_extend: entity work.ZeroExtend
		 port map (
			  input  => IR_Out(15 downto 0),
			  output => ZeroExt_Out
		 );

	-- Shift Left 2 for Jump Address
	shift_left2_jump: entity work.ShiftLeft2
		 port map (
			  D => Jump_Shift_Input,  -- Concatenate zeros for full 32-bit input
			  Q => ShiftLeft2_Jump_Out
		 );

    -- Jump Address Calculator
	jump_addr: entity work.JumpAddr
		 port map (
			  PC_31_28   => PC_Out(31 downto 28),
			  Instr_25_0 => ShiftLeft2_Jump_Out(27 downto 2),  -- Use shifted instruction
			  JumpAddr   => Jump_Addr_Out
		 );

    -- ALU Source A Multiplexer
    alusrca_mux: entity work.Mux2to1
        port map (
            A      => PC_Out,
            B      => RegA_Out,
            sel    => ALUSrcA,
            output => ALU_SrcA_Out
        );

    -- ALU Source B Multiplexer
    alusrcb_mux: entity work.Mux4to1
        port map (
            A      => RegB_Out,
            B      => x"00000004",
            C      => Sign_Ext_Out,
            D      => Shift_Left2_Out,
            sel    => ALUSrcB,
            output => ALU_SrcB_Out
        );

    -- Register Destination Multiplexer
    regdst_mux: entity work.Mux2to1_5bit
        port map (
            A      => IR_Out(20 downto 16),
            B      => IR_Out(15 downto 11),
            sel    => RegDst,
            output => WriteReg_Addr
        );

    -- ALU/LO/HI Output Multiplexer
    alu_lohi_mux: entity work.Mux3to1
        port map (
            A      => ALU_Result,
            B      => LO_Reg_Out,
            C      => HI_Reg_Out,
            sel    => ALU_LO_HI_Out,
            output => Write_Data
        );

    -- Memory to Register Multiplexer
    memtoreg_mux: entity work.Mux2to1
        port map (
            A      => Write_Data,
            B      => MDR_Out,
            sel    => MemToReg,
            output => WriteData_Final
        );

    -- Jump Address Multiplexer
    jump_addr_mux: entity work.Mux3to1
        port map (
            A      => ALU_Result,
            B      => ALUOut_Out,
            C      => Jump_Addr_Out,
            sel    => PCSource,
            output => PC_Next
        );

		  
	
    -- Address output assignment
    Address <= MemAddress;

end Behavioral;