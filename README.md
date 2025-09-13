# Pipelined CPU for Custom ISA

This project implements a 5-stage pipelined CPU processor designed for a custom Instruction Set Architecture (ISA). The processor was developed as part of the CSEN122 course project in Spring 2025 and demonstrates fundamental concepts of computer architecture including pipelining, control hazards, and memory hierarchy.

## Overview

Our team designed and implemented a complete pipelined CPU that executes instructions from a custom 32-bit ISA. The processor uses a classic 5-stage pipeline architecture with proper hazard handling and supports arithmetic operations, memory access, and control flow instructions.

## ⚠️ Important Implementation Notes

**The datapath drawing is not fully accurate but the Verilog code implementation is correct.**

1. **Branch Control Handling**: The branch decision logic requires proper handling of ALU flags from the immediately preceding instruction. Branch instructions should use ALU flags from the previous instruction, which can be implemented by sending ALU flags backwards through the pipeline stages.

2. **PC Addressing**: The PC correctly increments by 1 (not 4) because the SCU ISA uses word addressing rather than byte addressing. Each instruction is stored at consecutive word addresses (0, 1, 2, 3, ...) rather than byte addresses (0, 4, 8, 12, ...).

## Custom ISA Instruction Set

The processor supports the following instruction types with 4-bit opcodes (bits 31-28):

### Arithmetic Instructions
- **ADD** (`0100`): Add two registers → `ADD rd, rs, rt`
- **SUB** (`0111`): Subtract two registers → `SUB rd, rs, rt`  
- **INC** (`0101`): Increment register by immediate → `INC rd, rs, imm16`
- **NEG** (`0110`): Negate register → `NEG rd, rs`

### Memory Instructions
- **LD** (`1110`): Load from memory → `LD rd, rs`
- **ST** (`0011`): Store to memory → `ST rs, rt`

### Control Flow Instructions
- **J** (`1000`): Unconditional jump → `J target`
- **JM** (`1010`): Jump to memory address → `JM rs`
- **BRZ** (`1001`): Branch if zero → `BRZ rs`
- **BRN** (`1011`): Branch if negative → `BRN rs`

### Special Instructions
- **SVPC** (`1111`): Save PC + immediate to register → `SVPC rd, imm22`
- **NOP** (`0000`): No operation

## Pipeline Architecture

The processor implements a classic 5-stage pipeline:

```
IF → ID → EX → MEM → WB
```

### Stage 1: Instruction Fetch (IF)

**Components:**
- Program Counter (PC)
- PC Adder (+1)
- Instruction Memory
- IF/ID Pipeline Buffer
- PC Source Multiplexer

**Functionality:**
- Fetches 32-bit instructions from instruction memory using the current PC value
- Increments PC by 1 for sequential execution
- Handles branch/jump target selection through PC source multiplexer
- Passes instruction and PC+1 to the ID stage via IF/ID buffer

**Key Signals:**
- `instruction_address`: Current PC value used to fetch instruction
- `pcAdder_out`: PC + 1 for sequential execution
- `jump_out`: Target address for branches/jumps
- `PCSrc`: Control signal to select between sequential and branch/jump addresses

### Stage 2: Instruction Decode (ID)

**Components:**
- Control Unit
- Register File (64 × 32-bit registers)
- Immediate Generators (16-bit and 22-bit)
- ID/EX Pipeline Buffer

**Functionality:**
- Decodes the 32-bit instruction to extract opcode, register addresses, and immediates
- Generates all control signals based on instruction type
- Reads source registers from the 64-entry register file
- Sign-extends immediate values (16-bit for most instructions, 22-bit for SVPC)
- Forwards all control signals, data, and immediate values to EX stage

**Instruction Format:**
```
[31:28] [27:22] [21:16] [15:10] [9:0] or [21:0]
Opcode    rd      rs      rt    imm16/imm22
```

**Control Signals Generated:**
- `regWrite`: Enable register write-back
- `memToReg`: Select ALU result or memory data for write-back
- `ALUSrc`: Select register or immediate for ALU input
- `MemRead/MemWrite`: Memory access control
- `Jump/JumpMem`: Jump control signals
- `BranchZero/BranchNeg`: Branch condition signals
- `ALUOp[2:0]`: ALU operation selection

### Stage 3: Execute (EX)

**Components:**
- Arithmetic Logic Unit (ALU)
- ALU Input Multiplexers
- EX/MEM Pipeline Buffer

**Functionality:**
- Performs arithmetic and logical operations based on `ALUOp` control signals
- Selects ALU inputs using multiplexers:
  - Input A: Register data or PC (for SVPC instruction)
  - Input B: Register data or sign-extended immediate
- Generates condition flags (Zero and Negative) for branch decisions
- Calculates memory addresses for load/store operations
- Forwards results and control signals to MEM stage

**ALU Operations:**
- `000`: Addition (A + B)
- `101`: Subtraction (B - A) 
- `110`: Negation (-B)
- `111`: Pass A (used for certain operations)

**ALU Outputs:**
- `ALUResult`: 32-bit computation result
- `Zero`: Flag indicating result is zero
- `Neg`: Flag indicating result is negative (MSB = 1)

### Stage 4: Memory Access (MEM)

**Components:**
- Data Memory (1024 × 32-bit words)
- Branch Decision Logic
- PC Override Multiplexer
- MEM/WB Pipeline Buffer

**Functionality:**
- Performs memory read operations for load instructions
- Performs memory write operations for store instructions
- Resolves branch conditions by combining branch control signals with ALU flags
- Determines next PC value for branches and jumps
- Forwards final results to write-back stage

**Branch Resolution:**
```verilog
PCSrc = Jump | ((BranchNeg & negWB) | (BranchZero & zeroWB))
```

**Memory Interface:**
- Address: ALU result (for load/store) or register value (for jump-memory)
- Write Data: Register data from rt field
- Read Data: 32-bit value from memory

### Stage 5: Write Back (WB)

**Components:**
- Write-back Multiplexer
- Register File Write Port

**Functionality:**
- Selects final result for register write-back:
  - ALU result (for arithmetic operations)
  - Memory data (for load operations)
- Writes result to destination register if `regWrite` is enabled
- Provides branch condition flags to earlier stages for hazard resolution

## Pipeline Buffers

The design includes four pipeline buffers to maintain proper data flow:

1. **IF/ID Buffer**: Stores instruction and PC between fetch and decode stages
2. **ID/EX Buffer**: Stores control signals, register data, immediates, and PC
3. **EX/MEM Buffer**: Stores ALU results, memory control signals, and condition flags  
4. **MEM/WB Buffer**: Stores final results and write-back control signals

## Hazard Handling

The processor handles control hazards through:
- **Branch Resolution**: Branches are resolved in the MEM stage
- **Jump Handling**: Unconditional jumps update PC immediately
- **Pipeline Stalls**: NOPs are used to handle data dependencies

## Memory Organization

- **Instruction Memory**: 256 × 32-bit words, initialized with test program
- **Data Memory**: 1024 × 32-bit words, supports both read and write operations
- **Register File**: 64 × 32-bit registers, with register 0 hardwired to 0

## Test Program

The processor includes a sample program that implements a minimum-finding algorithm:
- Initializes array base address and size in registers
- Iterates through array elements
- Compares values and maintains minimum
- Demonstrates all major instruction types and pipeline operation

## Files Structure

```
components/
├── ALU.v              # Arithmetic Logic Unit
├── Control.v          # Instruction decoder and control unit
├── Data_Memory.v      # Data memory module
├── EX_MEM.v          # Execute to Memory pipeline buffer
├── ID_EX.v           # Decode to Execute pipeline buffer
├── IF_ID.v           # Fetch to Decode pipeline buffer
├── Instruction_Memory.v # Instruction memory with test program
├── MEM_WB.v          # Memory to Write-back pipeline buffer
├── PC_Adder.v        # PC increment logic
├── pc.v              # Program Counter
├── Register_File.v   # 64-entry register file
└── TwoToOneMux.v     # 2:1 multiplexer component

tb.v                  # Top-level testbench
```

## Simulation

The testbench (`tb.v`) instantiates the complete processor and runs for 3000ns to demonstrate pipeline operation. The design uses a 10ns clock period (100MHz) and includes proper initialization of all memory components.

## Features

- ✅ 5-stage pipeline with proper hazard handling
- ✅ Custom 32-bit ISA with 11 instruction types
- ✅ 64-entry register file
- ✅ Separate instruction and data memories
- ✅ Branch prediction and jump handling
- ✅ Comprehensive testbench with sample program
- ✅ Modular design with reusable components

This implementation demonstrates key computer architecture concepts and provides a solid foundation for understanding pipelined processor design. 