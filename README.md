<img width="808" alt="MIPS-architecture" src="https://github.com/user-attachments/assets/3c14efcc-73eb-4211-a68a-ee68219fe0b0" />


# MIPS-4712 Processor Implementation

## Project Overview
This repository contains the VHDL implementation of a 32-bit MIPS processor. The processor is designed to execute a subset of the MIPS instruction set and includes a memory-mapped I/O system for interaction with external devices.

## Architecture
The processor follows a multi-cycle implementation with the following major components:

### CPU Components
- **ALU**: Performs arithmetic, logical, and shift operations
- **Register File**: 32 registers with two read ports and one write port
- **Controller**: Finite state machine that controls the datapath
- **Datapath**: Contains the ALU, register file, and various registers
- **Special Purpose Registers**: Including PC, IR, RegA, RegB, ALUout, HI, and LO

### Memory System
- **RAM**: 256 32-bit words mapped to address 0
- **Memory-Mapped I/O**: 
  - Two 32-bit input ports (INPORT0: 0x0000FFF8, INPORT1: 0x0000FFFC)
  - One 32-bit output port (OUTPORT: 0x0000FFFC)

## Instruction Set
The processor implements a subset of the MIPS instruction set, including:
- Arithmetic operations: add, addi, sub, subi, mult
- Logical operations: and, andi, or, ori, xor, xori
- Shift operations: sll, srl, sra
- Comparison: slt, slti, sltu, sltiu
- Memory access: lw, sw
- Control flow: beq, bne, blez, bgtz, bltz, bgez, j, jal, jr

## Implementation Details

### ALU Operations
The ALU supports the following operations:
- Addition and subtraction (signed and unsigned)
- Multiplication (signed and unsigned)
- Logical operations (AND, OR, XOR)
- Shift operations (logical left/right, arithmetic right)
- Comparison operations

### Controller
The controller is implemented as a finite state machine with the following main states:
1. Instruction Fetch
2. Instruction Decode
3. Execution
4. Memory Access
5. Write Back

The controller generates control signals to coordinate the datapath components during instruction execution.

### Memory System
The memory system uses word-aligned addressing, with the lower two bits of the 32-bit address removed when accessing the RAM. The I/O ports are memory-mapped to specific addresses as defined in the project specification.

## I/O Interface
- **Input Ports**: Two 32-bit input ports (INPORT0, INPORT1) that read from external switches
- **Output Port**: One 32-bit output port (OUTPORT) connected to LED displays
- **Port Selection**: A 10th switch is used to select between INPORT0 and INPORT1
- **Port Enable**: A button is used to load values from the switches into the selected input port
