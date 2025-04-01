library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        A           : in  std_logic_vector(31 downto 0);
        B           : in  std_logic_vector(31 downto 0);
        sel         : in  std_logic_vector(4 downto 0);
        IR          : in  std_logic_vector(4 downto 0);
        result      : out std_logic_vector(31 downto 0);
        result_HI   : out std_logic_vector(31 downto 0);
        branchTaken : out std_logic
    );
end ALU;

architecture behavioral of ALU is
    -- Internal signals for storing temporary results
    signal temp_output     : std_logic_vector(31 downto 0);
    signal temp_HI        : std_logic_vector(31 downto 0);
    signal temp_branchTaken : std_logic;

begin
    process(sel, A, B, IR)
        -- Variables for arithmetic operations
        variable temp_sum     : unsigned(31 downto 0);
        variable temp_diff    : unsigned(31 downto 0);
        variable temp_product : std_logic_vector(63 downto 0);
        variable shift_amount : integer;
    begin
        -- Default signal assignments
        temp_branchTaken <= '0';
        temp_output <= (others => '0');
        temp_HI <= (others => '0');
        shift_amount := to_integer(unsigned(IR));

        case sel is
            -- Arithmetic Operations
            when "00000" =>  -- ADD/ADDU/ADDI
                temp_sum := unsigned(A) + unsigned(B);
                temp_output <= std_logic_vector(temp_sum);

            when "00001" =>  -- SUB/SUBU
                temp_diff := unsigned(A) - unsigned(B);
                temp_output <= std_logic_vector(temp_diff);

            when "00010" =>  -- MULT (Signed)
                temp_product := std_logic_vector(signed(A) * signed(B));
                temp_output <= temp_product(31 downto 0);   -- LO
                temp_HI <= temp_product(63 downto 32);      -- HI

            when "00011" =>  -- MULTU (Unsigned)
                temp_product := std_logic_vector(unsigned(A) * unsigned(B));
                temp_output <= temp_product(31 downto 0);   -- LO
                temp_HI <= temp_product(63 downto 32);      -- HI

            -- Logical Operations
            when "00100" =>  -- AND/ANDI
                temp_output <= A and B;

            when "00101" =>  -- OR/ORI
                temp_output <= A or B;

            when "00110" =>  -- XOR/XORI
                temp_output <= A xor B;

            -- Shift Operations
            when "00111" =>  -- SRL
                temp_output <= std_logic_vector(shift_right(unsigned(A), shift_amount));

            when "01000" =>  -- SLL
                temp_output <= std_logic_vector(shift_left(unsigned(A), shift_amount));

            when "01001" =>  -- SRA
                temp_output <= std_logic_vector(shift_right(signed(A), shift_amount));

            -- Set Operations
            when "01010" =>  -- SLT/SLTI
                if signed(A) < signed(B) then
                    temp_output <= x"00000001";
                else
                    temp_output <= x"00000000";
                end if;

            when "01011" =>  -- SLTU/SLTIU
                if unsigned(A) < unsigned(B) then
                    temp_output <= x"00000001";
                else
                    temp_output <= x"00000000";
                end if;

            -- Move Operations
            when "01100" =>  -- MFHI
                temp_output <= A;

            when "01101" =>  -- MFLO
                temp_output <= A;

            when "01110" =>  -- JR
                temp_output <= A;
                temp_branchTaken <= '1';

            -- Branch Operations
            when "10000" =>  -- BEQ
                if A = B then
                    temp_branchTaken <= '1';
                end if;
                temp_output <= std_logic_vector(unsigned(A) - unsigned(B));

            when "10001" =>  -- BNE
                if A /= B then
                    temp_branchTaken <= '1';
                end if;
                temp_output <= std_logic_vector(unsigned(A) - unsigned(B));

            when "10010" =>  -- BLEZ
                if signed(A) <= 0 then
                    temp_branchTaken <= '1';
                end if;
                temp_output <= A;

            when "10011" =>  -- BGTZ
                if signed(A) > 0 then
                    temp_branchTaken <= '1';
                end if;
                temp_output <= A;

            when "10100" =>  -- BLTZ
                if signed(A) < 0 then
                    temp_branchTaken <= '1';
                end if;
                temp_output <= A;

            -- Jump Operations
            when "10101" =>  -- J
                temp_output <= A;
                temp_branchTaken <= '1';

            when "10110" =>  -- JAL
                temp_output <= B;
                temp_branchTaken <= '1';

            -- Default case
            when others =>
                temp_output <= (others => '0');
                temp_HI <= (others => '0');
                temp_branchTaken <= '0';

        end case;
    end process;

    -- Output assignments
    result <= temp_output;
    result_HI <= temp_HI;
    branchTaken <= temp_branchTaken;

end behavioral;