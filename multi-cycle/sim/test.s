.section .text
.global _start

_start:
    # LUI tests
    lui  x1, 0x12345        # x1 = 0x12345000
    lui  x2, 0xFFFFF        # x2 = 0xFFFFF000 (max immediate)
    lui  x3, 0x1            # x3 = 0x00001000
    lui  x4, 0x00000        # x4 = 0x00000000 (zero immediate)

    # AUIPC tests — result depends on PC at that instruction
    auipc x5, 0x1           # x5 = PC + 0x00001000
    auipc x6, 0x0           # x6 = PC itself (offset 0)

    # LUI + ADDI combo — standard way to load 32 bit constant
    lui  x7, 0xDEADB        # x7 = 0xDEADB000
    addi x7, x7, 0x7EF      # x7 = 0xDEADB7EF (note: avoid negative addi here)

    # AUIPC + ADDI — PC relative addressing
    auipc x8, 0x0
    addi  x8, x8, 8         # x8 = PC of auipc + 8