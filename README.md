# RISC-V CPU Implementations (RV32I)

This repository contains my implementations of the **RISC-V RV32I CPU architecture** written in **Verilog**.  
The goal of this project is to learn and explore **CPU microarchitecture design**, starting from a simple design and progressively moving toward more advanced implementations.

The project currently includes a **fully functional single-cycle RV32I processor**, with future plans to extend it with **pipelined and optimized versions**.

---

## Implementations

### Single-Cycle RV32I CPU
Location: `single-cycle/`

A complete **single-cycle implementation of the RV32I base ISA**.

Features:

- Implements **all 37 RV32I instructions**
- Excludes **system and privileged instructions**
- Fully functional datapath and control unit
- Separate instruction and data memory
- Written in modular Verilog components

Supported instruction categories:

| Category | Instructions |
|--------|--------|
| Arithmetic (R-type) | `ADD SUB SLL SLT SLTU XOR SRL SRA OR AND` |
| Immediate arithmetic | `ADDI SLLI SLTI SLTIU XORI SRLI SRAI ORI ANDI` |
| Loads | `LB LH LW LBU LHU` |
| Stores | `SB SH SW` |
| Branches | `BEQ BNE BLT BGE BLTU BGEU` |
| Jumps | `JAL JALR` |
| Upper immediates | `LUI AUIPC` |

System instructions (`ECALL`, `EBREAK`, `FENCE`) and privileged instructions are **not implemented**.

---

## Architecture Overview

The processor follows the classic **single-cycle datapath architecture** where each instruction completes in **one clock cycle**.

Core components include:

- Program Counter (PC)
- Instruction Memory
- Register File (32 registers)
- Immediate Generator
- Arithmetic Logic Unit (ALU)
- Data Memory
- Control Unit
- Branch / PC selection logic

The design separates **datapath and control logic**, making the architecture easier to understand and extend.

---

## Repository Structure

risc-v/ <br>
│  <br>
├── single-cycle/        ................Single-cycle RV32I CPU implementation <br>
│   ├── src/             ................Verilog source files <br>
│   ├── sim/             ................Testbenches / simulation <br>
│   └── docs/            ................Architecture diagrams and notes <br> 
│  <br>
└── README.md <br>

Future implementations (such as a pipelined CPU) will be added alongside the single-cycle design.

---

## Design Goals

This project focuses on understanding **how processors are built from first principles** rather than simply reproducing existing designs.

Key learning goals include:

- CPU datapath design
- Control unit implementation
- Instruction decoding
- RISC-V ISA understanding
- Hardware modularity in Verilog
- Simulation and verification of processor behavior

---

## Future Work

Planned improvements and extensions:

- 5-stage pipelined RV32I CPU
- Hazard detection and forwarding
- Branch prediction
- Cache experiments
- FPGA implementation


---

## Tools Required

`make` - To execute the makefile <br>

To compile tests: <br>
`riscv64-linux-gnu-gcc` - To provide assembly and objcopy commands <br>

To simulate: <br>
`iverilog` - To build and run simulations <br>

---
